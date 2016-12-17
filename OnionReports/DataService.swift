//
//  DataService.swift
//  OnionReports
//
//  Created by Lyle Christianne Jover on 16/12/2016.
//  Copyright © 2016 OnionApps Inc. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth

let baseData1 = FIRDatabase.database(app: FIRApp.init(named: "BurgerSt")!).reference()
let baseData2 = FIRDatabase.database(app: FIRApp.init(named: "SizeMatters")!).reference()

var flights = [String]()

open class DataService {
    public static let ds = DataService()
    
    
    var REF_BURGERST = baseData1
    var REF_SIZEMATTERS = baseData2
   

}
