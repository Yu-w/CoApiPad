//
//  Model.swift
//  ExpressLogic
//
//  Created by Wang Yu on 10/30/17.
//  Copyright © 2017 Express Logic. All rights reserved.
//

import Foundation

class Model {
    
    static var r21toR21 = [1227.3935058, -21.675266, 0.0494686]
    
    static func getDistanceFromRSSI(rssi: Int) -> Double {
        var sum = 0.0
        for i in 0..<Model.r21toR21.count {
            sum += pow(Double(rssi), Double(i)) * Model.r21toR21[i]
        }
        return sum
    }
    
}
