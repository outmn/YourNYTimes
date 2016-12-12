//
//  SearchViewController.swift
//  YourNYTimes
//
//  Created by Maxim  Grozniy on 08.07.16.
//  Copyright © 2016 Maxim  Grozniy. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


var settings = Settings()

class SearchViewController: UIViewController, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchTextView: UITextField!
    @IBOutlet weak var editSearchRequestButton: UIButton!
    
    var urlSession: URLSession?

    
    var nytimesURL: String!
    
    let refreshControl = UIRefreshControl()
    
    var articles = [ArticleNYTimes]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createSearchButton()
        Support.loadCommonSettings()
        refreshControl.backgroundColor = UIColor.white
        refreshControl.tintColor = UIColor.blue
        refreshControl.addTarget(self, action: #selector(SearchViewController.refreshData), for: UIControlEvents.valueChanged)
        collectionView.addSubview(refreshControl)
        
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ResultCollectionViewCell
        
        let element = articles[(indexPath as NSIndexPath).row]
        
        cell.headlineLabel.text = element.main
        cell.snippetLabel.text = element.snippet
        cell.sourseLabel.text = element.original
        if element.image_URL?.count > 0 {
            DispatchQueue.main.async(execute: {
                let url = URL(string: "http://nytimes.com/\(element.image_URL![0].url)")
                let data = try? Data(contentsOf: url!)
                cell.img.image = UIImage(data: data!)
            })
        }
        
        
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 10, height: 110)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.reloadData()
    }
    
    func refreshData() {
//        getArticles()
        collectionView.reloadData()
        refreshControl.endRefreshing()
    }
    
    // MARK: - Touches Began
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    // MARK: - Search Text Field
    func createSearchButton() {
        let searchButton = UIButton(type: .custom)
        searchButton.frame = CGRect(x: 2, y: 2, width: 26, height: 26)
        searchButton.backgroundColor = UIColor.clear
        searchButton.setImage(UIImage(named: "search"), for: UIControlState())
        searchButton.addTarget(self, action: #selector(SearchViewController.search), for: .touchUpInside)
        searchTextView.leftView = searchButton
        searchTextView.leftViewMode = .always
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func search() {
        if Reachability.isConnectedToNetwork() == true {
            getArticles(searchTextView.text!)
        } else {
            Support.getAlert("Internet", alMessage: "No Internet connection! Check your settins.")
        }
        
    }
    
    
    // MARK: - Request Articles
    func getArticles(_ searchString: String) {
        let request = URLRequest(url: URL(string: settings.getString() + "&q=" + searchString)!)
            
        if urlSession == nil {
            urlSession = URLSession.shared
        }
        
        let task = urlSession!.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
            
            //Check Errors
            if let error = error {
                print(error)
                return
            }
            
            //Parsing from JSON file recieved from www.nytimes.com
            if let data = data {
                self.parseJsonData(data)
                //self.collectionView.reloadData()
            
            }
        })
        task.resume()
    }
    
    func parseJsonData(_ data: Data) {
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions())
            
            let jsonResponse = jsonResult["response"] as! [String: AnyObject]
            
            let jsonArticle = jsonResponse["docs"] as! [[String: AnyObject]]
            
            for jsonArticle in jsonArticle {
                let article = ArticleNYTimes()
                
                let headline = jsonArticle["headline"] as! [String: AnyObject]
                article.main = headline["main"] as! String
                
                article.snippet = jsonArticle["snippet"] as! String
                
                if let byline = jsonArticle["byline"] as? [String: AnyObject] {
                    if let orig = byline["original"] as? String {
                        article.original = orig
                    }
                }
                
                if let pubdate = jsonArticle["pub_date"]  {
                    article.pub_date = pubdate as! String
                }
                
                if let leadparagraph = jsonArticle["lead_paragraph"] {
                    article.lead_paragraph = leadparagraph as! String
                }
                
                if let pictures = jsonArticle["multimedia"]  {
                    let multimedia = pictures as! [[String: AnyObject]]
                    var imgArray = [Multimedia]()
                    for img in multimedia {
                        imgArray.append(Multimedia.init(name: img["subtype"] as! String, url: img["url"] as! String))
                        
                    }
                    article.image_URL = imgArray
                }
                
                
                if let url = jsonArticle["web_url"] {
                    article.web_url = url as! String
                }
                
                articles.append(article)
            }
            
            DispatchQueue.main.async(execute: {self.collectionView.reloadData()})
        } catch {
            print(error)
        }
    }
    
    
     // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWeb" {
            let controller = segue.destination as! WebViewController
            
            let cell = sender as! ResultCollectionViewCell
            let indexpath = collectionView.indexPath(for: cell)
            
            controller.url = articles[((indexpath as NSIndexPath?)?.row)!].web_url
        }
     }
     

}
