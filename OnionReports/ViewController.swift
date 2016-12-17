//
//  ViewController.swift
//  OnionReports
//
//  Created by Lyle Christianne Jover on 16/12/2016.
//  Copyright © 2016 OnionApps Inc. All rights reserved.
//
import Foundation
import SystemConfiguration
import UIKit
import Alamofire
import Firebase
import FirebaseDatabase
import SwiftSpinner

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    
    @IBOutlet weak var fromDateText: UITextField!
    @IBOutlet weak var toDateText: UITextField!
    @IBOutlet weak var clientNameText: UITextField!
    @IBOutlet weak var clientEmailText: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    
    var clientPicker = UIPickerView()
    let userCalendar = Calendar.current
    let DATE_FORMAT1 = "MMM dd, yyyy"
    
    
    //MAILGUN
    let mailGunKey = "key-5b34852ee5f4c8467b150056b0b5ca1e"
    let mailGunURL = "onionapps.com"
    
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
        
        SwiftSpinner.show("the elves are working...").addTapHandler({
            SwiftSpinner.hide()
        }, subtitle: "tap anytime to exit")
        
        if checkConnectivity()  {
            
            if fromDateText.text! != "" && toDateText.text! != "" && clientNameText.text! != "" && clientEmailText.text! != "" {
        
                downloadData(client: clientNameText.text!, completion: { (result) in
                    print(result)
                    
                    
                    self.sendEmail()
                })
                
               
                
                
                
                
                
                
                
                
                
                
                
                
                
            }else {
                SwiftSpinner.hide()
                self.showErrorAlert("Incomplete Information", msg: "Please complete all required information.", VC: self)
                
            }
        }else {
            SwiftSpinner.hide()
            self.showErrorAlert("Network Error", msg: "Please check your internet connection.", VC: self)
                
        }
        

       
    }
  
    @IBAction func fromDateEditingBegun(_ sender: UITextField) {
        let inputView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 240))
        
        let datePickerView  : UIDatePicker = UIDatePicker(frame: CGRect(x: (self.view.frame.size.width/2) - (320/2), y: 40, width: 0, height: 0))
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        
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
    
    func checkConnectivity() -> Bool {
        if Reachability.isConnectedToNetwork() {
            return true
        } else {
            
            return false
        }
    }
    
    open class Reachability {
        
        class func isConnectedToNetwork() -> Bool {
            var zeroAddress = sockaddr_in()
            zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
            zeroAddress.sin_family = sa_family_t(AF_INET)
            
            guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
                $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                    SCNetworkReachabilityCreateWithAddress(nil, $0)
                }
            }) else {
                return false
            }
            
            var flags: SCNetworkReachabilityFlags = []
            if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
                return false
            }
            
            let isReachable = flags.contains(.reachable)
            let needsConnection = flags.contains(.connectionRequired)
            
            return (isReachable && !needsConnection)
        }
        
    }
    
    func showErrorAlert(_ title: String, msg: String, VC: UIViewController) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        VC.present(alert, animated: true, completion: nil)
        
    }
    
    func sendEmail(){
        
       
        let contents = "One,Two,Three,Four,Five"
        dataToFile(contents: contents, period: "\(fromDateText.text!)\(toDateText.text!)")
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let path = dir?.appendingPathComponent("OnionReport.csv")
        
//        let headers: HTTPHeaders = [
//            "Content-Type": "multipart/form-data"
//        ]
        let URL = try! URLRequest(url: "https://api.mailgun.net/v3/\(mailGunURL)/messages", method: .post)

        let key = mailGunKey
    

        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            multipartFormData.append("multipart/form-data".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "Content-Type")
            multipartFormData.append("api:\(key)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "Authorization")
            multipartFormData.append("info@\(self.mailGunURL)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "from")
            multipartFormData.append("\(self.clientEmailText.text!)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "to")
            multipartFormData.append("OnionApps Report for \(self.clientNameText.text!): \(self.fromDateText.text!) - \(self.toDateText.text!)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "subject")
            multipartFormData.append("Dear \(self.clientNameText.text!), Attached is the report for this period. Thank you!".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "text")
            multipartFormData.append(path!, withName: "attachment")
      
      
        }, with: URL, encodingCompletion: { (result) in
            
            switch (result){
            case .success(let upload, _, _):
                upload.response(completionHandler: { (response) in
                    print(response.request)
                    print(response.response)
                    if response.error == nil{
                        SwiftSpinner.hide()
                        self.showErrorAlert("Thank You", msg: "In a few moments, we will contact you to confirm your request.", VC: self)
                    } else {
                        SwiftSpinner.hide()
                        self.showErrorAlert("Something Went Wrong", msg: "We're working on it. Please try again later.", VC: self)
                    }
                })
                
                
            case .failure(let encodingError):
                SwiftSpinner.hide()
                self.showErrorAlert("Something Went Wrong", msg: "We're working on it. Please try again later.", VC: self)
            }
            
            
        })
    

        
    }
    
    func dataToFile(contents: String, period: String){
        // Set the file path
        let file = "OnionReport.csv"
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

            let path = dir.appendingPathComponent(file)
            
            //writing
            do {
                try contents.write(to: path, atomically: false, encoding: String.Encoding.utf8)
                print("WROTE OnionReport.csv created at tmp directory")
            }
            catch {/* error handling here */}
            
            //reading
            do {
                let data = try String(contentsOf: path, encoding: String.Encoding.utf8)
                print("READ \(data) from File OnionReport.csv created at tmp directory")
            }
            catch {/* error handling here */}
            
        }
    }

}

