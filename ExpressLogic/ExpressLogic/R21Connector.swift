//
//  R21Connector.swift
//  ExpressLogic
//
//  Created by Wang Yu on 10/30/17.
//  Copyright © 2017 Express Logic. All rights reserved.
//

import UIKit

class R21Connector: NSObject {
    let address: String
    let coapService: CoApService
    
    var distTable = [String: Double]()
    
    init(address: String) {
        self.address = address
        self.coapService = CoApService()
        super.init()
        self.coapService.r21Delegate = self
    }
    
    func getRSSI() {
        coapService.getRSSI(hostName: CoApService.getFullAddress(from: address))
    }
    
    func ping() {
        coapService.ping(hostName: CoApService.getFullAddress(from: address))
    }
    
}

extension R21Connector: CoApServiceR21Delegate {
    
    func coapService(didReceiveRSSI rssi: Dictionary<String, Int>) {
        var mutableRssi = rssi
        mutableRssi.removeValue(forKey: "053889")
        
//        rssi.removeValue(forKey: "053889")
        distTable = mutableRssi.mapValues { r in Model.getDistanceFromRSSI(rssi: r) }
//        debugPrint("R21 [\(address)] [distance]: \(distTable)")
//        debugPrint("R21 [\(address)] [rssi]: \(rssi)")
        
        if self.address == movingR21Addr && distTable.count == 3 {
            debugPrint(distTable)
            let bC = Model.barycentricCoordinate(verticesLoc: stationLoc, distances: distTable.map{ return $0.value })
            debugPrint(bC)
//            routingMap[movingR21Addr]?.nodeView?.transform = CGAffineTransform(translationX: bC.0, y: bC.1)
            routingMap[movingR21Addr]?.nodeView?.frame = CGRect(x: bC.0, y: bC.1, width: (routingMap[movingR21Addr]?.nodeView?.frame.width)!, height: (routingMap[movingR21Addr]?.nodeView?.frame.height)!)
            NotificationCenter.default.post(name:  NSNotification.Name(rawValue: "redrawLine"), object: nil)
        } else {
            shakeNodes(address: self.address)
            NotificationCenter.default.post(name:  NSNotification.Name(rawValue: "redrawLine"), object: nil)
        }
    }
    
}
