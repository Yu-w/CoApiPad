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
        distTable = rssi.mapValues { r in Model.getDistanceFromRSSI(rssi: r) }
//        debugPrint("R21 [\(address)] [distance]: \(distTable)")
        debugPrint("R21 [\(address)] [rssi]: \(rssi)")
        
        if self.address == movingR21Addr {
            debugPrint(distTable)
            let bC = Model.barycentricCoordinate(verticesLoc: routingLoc, distances: distTable.map{ return $0.value })
            debugPrint(bC)
            routingMap[movingR21Addr]?.nodeView?.transform = CGAffineTransform(translationX: bC.0, y: bC.1)
        }
    }
    
}
