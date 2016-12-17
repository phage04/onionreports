//
//  ViewController.swift
//  OnionReports
//
//  Created by Lyle Christianne Jover on 16/12/2016.
//  Copyright © 2016 OnionApps Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    
    @IBOutlet weak var fromDateText: UITextField!
    @IBOutlet weak var toDateText: UITextField!
    @IBOutlet weak var clientNameText: UITextField!
    @IBOutlet weak var clientEmailText: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    
    var clientPicker = UIPickerView()
    let userCalendar = Calendar.current
    let DATE_FORMAT1 = "MMM dd, yyyy"
    let clientPickerData = ["Burger St.",
                            "Size Matters"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendBtn.layer.backgroundColor = UIColor(red: CGFloat(103.0 / 255.0), green: CGFloat(58.0 / 255.0), blue: CGFloat(183.0 / 255.0), alpha: 1.0).cgColor
        sendBtn.setTitleColor(UIColor.white, for: .normal)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    

    @IBAction func didPressSend(_ sender: Any) {
    }
  
    @IBAction func fromDateEditingBegun(_ sender: UITextField) {
        let inputView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 240))
        
        let datePickerView  : UIDatePicker = UIDatePicker(frame: CGRect(x: (self.view.frame.size.width/2) - (320/2), y: 40, width: 0, height: 0))
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        datePickerView.minuteInterval = 15
        
        let dateFromNow = (userCalendar as NSCalendar).date(
            byAdding: [.day],
            value: 90,
            to: Date(),
            options: [])
        
        datePickerView.maximumDate = dateFromNow
        datePickerView.minimumDate = Date()
        
        inputView.addSubview(datePickerView)
        inputView.backgroundColor = UIColor.white
        datePickerView.backgroundColor = UIColor.white
        
        
        sender.inputView = inputView
        datePickerView.addTarget(self, action: #selector(ViewController.handleDatePickerFrom(_:)), for: UIControlEvents.valueChanged)
        
        let timeFromNow = (userCalendar as NSCalendar).date(
            byAdding: [.hour],
            value: 1,
            to: Date(),
            options: [])
        
        if let unwrappedDate = timeFromNow {
            datePickerView.setDate(unwrappedDate, animated: false)
        }
        
        
        handleDatePickerFrom(datePickerView)
    }

    @IBAction func toDateEditingBegun(_ sender: UITextField) {
        let inputView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 240))
        
        let datePickerView  : UIDatePicker = UIDatePicker(frame: CGRect(x: (self.view.frame.size.width/2) - (320/2), y: 40, width: 0, height: 0))
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        datePickerView.minuteInterval = 15
        
        let dateFromNow = (userCalendar as NSCalendar).date(
            byAdding: [.day],
            value: 90,
            to: Date(),
            options: [])
        
        datePickerView.maximumDate = dateFromNow
        datePickerView.minimumDate = Date()
        
        inputView.addSubview(datePickerView)
        inputView.backgroundColor = UIColor.white
        datePickerView.backgroundColor = UIColor.white
        
        
        sender.inputView = inputView
        datePickerView.addTarget(self, action: #selector(ViewController.handleDatePickerTo(_:)), for: UIControlEvents.valueChanged)
        
        let timeFromNow = (userCalendar as NSCalendar).date(
            byAdding: [.hour],
            value: 1,
            to: Date(),
            options: [])
        
        if let unwrappedDate = timeFromNow {
            datePickerView.setDate(unwrappedDate, animated: false)
        }
        
        
        handleDatePickerTo(datePickerView)
    }

    @IBAction func clientNameEditingBegun(_ sender: UITextField) {
        let inputView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 240))
        
        let rect = CGRect(x: (self.view.frame.size.width/2) - (320/2), y: 0, width: 0, height: 0)
        clientPicker = UIPickerView(frame: rect)
        clientPicker.delegate = self
        clientPicker.dataSource = self
        
        inputView.backgroundColor = UIColor.white
        clientPicker.backgroundColor = UIColor.white
        clientNameText.text = clientPickerData[0]
        inputView.addSubview(clientPicker)
        sender.inputView = inputView

    }
    
    func handleDatePickerFrom(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DATE_FORMAT1
        fromDateText.text = dateFormatter.string(from: sender.date)
    }
    
    func handleDatePickerTo(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DATE_FORMAT1
        toDateText.text = dateFormatter.string(from: sender.date)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return clientPickerData.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return clientPickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        clientNameText.text = clientPickerData[row]
    }


}

