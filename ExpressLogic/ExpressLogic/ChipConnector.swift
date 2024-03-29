//
//  ChipConnector.swift
//  ExpressLogic
//
//  Created by Wang Yu on 10/30/17.
//  Copyright © 2017 Express Logic. All rights reserved.
//

import UIKit

class ChipConnector: NSObject {
    
    static let shared = ChipConnector()
    var chipMap = [String: R21Connector]()
    var updateViewOnce = true
    
    override init() {
        super.init()
        CoApService.sharedInstance.v71Delegate = self
    }
    
    func getR21Connector(address: String) -> R21Connector? {
        return chipMap[address]
    }
    
    func run() {
        self.updateDestTable()
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
            self.updateDestTable()
        }
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            self.updateRSSITable()
        }
    }
    
    func updateDestTable() {
        debugPrint("Request update dest_table ...")
        CoApService.sharedInstance.getDestTable(hostName: CoApService.Host.fullAddress())
    }
    
    func updateRSSITable() {
        debugPrint("Request update RSSI ...")
        for i in 0..<chipMap.values.count {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1 * Double(i)) {
                Array(self.chipMap.values)[i].getRSSI()
            }
        }
    }
    
}

extension ChipConnector: CoApServiceV71Delegate {
    
    func coapService(didReceiveDestTable destTable: [String]) {
        let destTable = Array(Set(destTable)).filter({ address in chipMap[address] == nil })

        destTable.forEach { address in
            self.chipMap[address] = R21Connector(address: address)
        }
        
        if (updateViewOnce) {
            updateViewOnce = false
            debugPrint(destTable)
            routingMap.removeAll()
            destTable.forEach { routingInfo.append(($0, $0)) }
            NotificationCenter.default.post(name:  NSNotification.Name(rawValue: "receiveRountingTable"), object: nil)
        }
//        debugPrint("dest_table recevied")
//        debugPrint(destTable)
//        let shortDestTable = Array(Set(destTable.map { x in x.replacingOccurrences(of: ":", with: "").dropFirst(10).toString() }))
//        debugPrint(shortDestTable)
    }
    
    func coapService(didReceiveRSSI rssi: Dictionary<String, Int>) {
//        debugPrint("RSSI recevied")
//        debugPrint(rssi)
    }
    
}
