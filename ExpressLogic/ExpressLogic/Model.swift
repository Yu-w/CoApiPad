//
//  Model.swift
//  ExpressLogic
//
//  Created by Wang Yu on 10/30/17.
//  Copyright © 2017 Express Logic. All rights reserved.
//

import Foundation
import UIKit

class Model {
    
    static var r21toR21 = [1227.3935058, -21.675266, 0.0494686]
    
    static func getDistanceFromRSSI(rssi: Int) -> Double {
        var sum = 0.0
        for i in 0..<Model.r21toR21.count {
            sum += pow(Double(rssi), Double(i)) * Model.r21toR21[i]
        }
        return sum
    }
    
    static func barycentricCoordinate(verticesLoc: [(CGFloat, CGFloat)], distances: [Double]) -> (CGFloat, CGFloat) {
        var p : (CGFloat, CGFloat) = (0,0)
        var sum = 0.0
        for i in 0..<verticesLoc.count {
            p = addPair(pair1: p, pair2: timesPair(pair: verticesLoc[i], mul: distances[i]))
            sum += distances[i]
        }
        return timesPair(pair: p, mul: 1/sum)
    }
    
    static func timesPair(pair: (CGFloat, CGFloat), mul: Double) -> (CGFloat, CGFloat) {
        return (CGFloat(Double(pair.0) * mul), CGFloat(Double(pair.1) * mul))
    }
    
    static func addPair(pair1: (CGFloat, CGFloat), pair2: (CGFloat, CGFloat)) -> (CGFloat, CGFloat) {
        return (pair1.0 + pair2.0, pair1.1 + pair2.1)
    }
}
