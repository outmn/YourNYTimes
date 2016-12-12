//
//  WebViewController.swift
//  YourNYTimes
//
//  Created by Maxim  Grozniy on 11.07.16.
//  Copyright © 2016 Maxim  Grozniy. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    var url: String?

    override func viewWillAppear(_ animated: Bool) {
        if (url != nil) {
            let pageURL = URL(string: url!)
            let request = URLRequest(url: pageURL!)
            webView.loadRequest(request)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }

    
    @IBAction func back(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    


}
