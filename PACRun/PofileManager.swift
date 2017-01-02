//
//  PofileManager.swift
//  PACRun
//
//  Created by 馮仰靚 on 20/12/2016.
//  Copyright © 2016 YC. All rights reserved.
//

import Foundation
import CoreLocation

class RecordManager{
    var date: String
    var distance : Double
    var time : String
    init(date:String,distance:Double,time:String){
        self.date = date
        self.distance = distance
        self.time = time
    }

}
