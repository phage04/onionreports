//
//  DataCruncher.swift
//  OnionReports
//
//  Created by Lyle Christianne Jover on 16/12/2016.
//  Copyright © 2016 OnionApps Inc. All rights reserved.
//

import Foundation

let clientPickerData = ["Burger St.",
                        "Size Matters"]

func downloadData(client: String, completion: @escaping (_ result: Dictionary<String, AnyObject>) -> Void){
    switch(client){
    
    case "Burger St.":
        DataService.ds.REF_BURGERST.observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = snapshot.value as? Dictionary<String, AnyObject>{
                completion(data)
            }
        })
        break
        
    case "Size Matters":
        DataService.ds.REF_SIZEMATTERS.observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = snapshot.value as? Dictionary<String, AnyObject>{
                completion(data)
            }
        })
        break
    default:
        break
    }
}
