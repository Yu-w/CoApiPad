//
//  CoApServiceDelegate.swift
//  ExpressLogic
//
//  Created by Wang Yu on 10/30/17.
//  Copyright © 2017 Express Logic. All rights reserved.
//

import Foundation

protocol CoApServiceV71Delegate: class {
    
    func coapService(didReceiveDestTable destTable: [String])
    
    func coapService(didReceiveRSSI rssi: Dictionary<String, Int>)
    
}


protocol CoApServiceR21Delegate: class {
    
    func coapService(didReceiveRSSI rssi: Dictionary<String, Int>)
    
}
