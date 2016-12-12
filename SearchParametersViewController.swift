//
//  SearchParametersViewController.swift
//  YourNYTimes
//
//  Created by Maxim  Grozniy on 08.07.16.
//  Copyright © 2016 Maxim  Grozniy. All rights reserved.
//

import UIKit

class SearchParametersViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate {
    
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var sirdView: UIView!
    
    
    @IBOutlet weak var lucenTextField: UITextField!
    @IBOutlet weak var pagesValueTextField: UITextField!
    
    @IBOutlet weak var fromDateButton: UIButton!
    @IBOutlet weak var toDateButton: UIButton!
    
    @IBOutlet weak var rangeSegment: UISegmentedControl!
    
    var pickerView: UIView?
    var datePicker: UIDatePicker?
    
    var currentDateButton: UIButton?
    
    var yPositions = [CGFloat]()

    override func viewDidLoad() {
        super.viewDidLoad()
        yPositions.append(firstView.center.y)
        yPositions.append(sirdView.center.y)
        createDownSwipe()
        
        if settings.fromDate != "" {
            fromDateButton.setTitle(settings.fromDate, for: UIControlState())
        } else {
            fromDateButton.setTitle("select From date", for: UIControlState())
        }
        
        if settings.toDate != "" {
            toDateButton.setTitle(settings.toDate, for: UIControlState())
        } else {
            toDateButton.setTitle("select To date", for: UIControlState())
        }
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(SearchParametersViewController.gestureAnimation))
//        lucenTextField.addGestureRecognizer(tap)
        
    }
    
//    func gestureAnimation() {
//        self.animateView(self.firstView, show: true, y: 300)
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }

    
    func makeShadow(_ view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 2
//        view.layer.shadowPath = UIBezierPath(rect: view.bounds).CGPath
//        view.layer.shouldRasterize = true
    }
    
    // MARK: - Creating Down Swipe
    
    func createDownSwipe() {
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(SearchParametersViewController.handleSwipe(_:)))
        downSwipe.direction = .down
        view.addGestureRecognizer(downSwipe)
    }
    
    func handleSwipe(_ sender: UISwipeGestureRecognizer) {
        if (sender.direction == .down) {
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func saveLucenWords(_ sender: UITextField) {
        settings.lucen = lucenTextField.text!
        let defaults = UserDefaults.standard
        defaults.set(settings.lucen, forKey: "lucen")
        defaults.synchronize()
        
    }
    @IBAction func saveListOfPages(_ sender: UITextField) {
        settings.pagesValue = pagesValueTextField.text!
        let defaults = UserDefaults.standard
        defaults.set(settings.pagesValue, forKey: "pagesValue")
        defaults.synchronize()
    }
    
    @IBAction func saveRangeSegment(_ sender: UISegmentedControl) {
        switch rangeSegment.selectedSegmentIndex {
            case 0:
                settings.rangeWay = "newest"
            case 1:
                settings.rangeWay = "oldest"
            default:
                break;
        }
        
        let defaults = UserDefaults.standard
        defaults.set(settings.rangeWay, forKey: "rangeWay")
        defaults.synchronize()
    }
    
    @IBAction func openFromDateField(_ sender: UIButton) {
        currentDateButton = sender
        createDatePicker()
    }
    
    @IBAction func openToDateField(_ sender: UIButton) {
        currentDateButton = sender
        createDatePicker()
    }
    
    func createDatePicker() {
        pickerView = UIView()
        datePicker = UIDatePicker()
        
        pickerView!.frame.size = UIScreen.main.bounds.size
        pickerView!.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        pickerView?.backgroundColor = UIColor.white
        
        datePicker!.frame = CGRect(x: 0, y: view.frame.height/2 - 100, width: view.frame.width, height: 200)
        datePicker!.datePickerMode = .date
        
        pickerView!.addSubview(datePicker!)
        
        let okDateButton = UIButton(type: .system)
        okDateButton.frame = CGRect(x: 0, y: 200, width: view.frame.width, height: 30)
        okDateButton.setTitle("OK", for: UIControlState())
        okDateButton.setTitleColor(UIColor.black, for: UIControlState())
        okDateButton.addTarget(self, action: #selector(SearchParametersViewController.okPicker(_:)), for: .touchUpInside)
        
        pickerView!.addSubview(okDateButton)
        view.addSubview(pickerView!)
    }
    
    func okPicker(_ sender: UIButton) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        if currentDateButton == fromDateButton {
            settings.fromDate = dateFormatter.string(from: datePicker!.date)
            currentDateButton!.setTitle(settings.fromDate, for: UIControlState())
            let defaults = UserDefaults.standard
            defaults.set(settings.fromDate, forKey: "fromDate")
            defaults.synchronize()
        } else {
            settings.toDate = dateFormatter.string(from: datePicker!.date)
            currentDateButton!.setTitle(settings.toDate, for: UIControlState())
            let defaults = UserDefaults.standard
            defaults.set(settings.toDate, forKey: "toDate")
            defaults.synchronize()
        }
        
        pickerView!.removeFromSuperview()
        datePicker = nil
        pickerView = nil
        
    }
    
    @IBAction func ok(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Animation
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let shift = (self.view.frame.height - 240)/2
        
            if textField == self.lucenTextField {
                self.animateView(self.firstView, show: true, y: shift)
            } else {
                self.animateView(self.sirdView, show: true, y: shift)
            }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
            if textField == self.lucenTextField {
                self.animateView(self.firstView, show: false, y: yPositions[0])
            } else {
                self.animateView(self.sirdView, show: false, y: yPositions[1])
            }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.yPositions[0] = firstView.center.y
        self.yPositions[1] = sirdView.center.y
    }
    
    func animateView(_ animateView: UIView, show: Bool, y: CGFloat) {
        animateView.layer.zPosition = CGFloat.greatestFiniteMagnitude
    
        UIView.animate(withDuration: 0.3, animations: {
            if show == true {
                animateView.center.y = y
                animateView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                animateView.layer.cornerRadius = 5
                self.makeShadow(animateView)
            } else {
                animateView.center.y = y
                animateView.transform = CGAffineTransform(scaleX: 1, y: 1)
                animateView.layer.shadowOpacity = 0
                animateView.layer.cornerRadius = 0
            }
        }) 
    }
    
    
}
