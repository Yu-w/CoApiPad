//
//  CoApService.swift
//  ExpressLogic
//
//  Created by Wang Yu on 3/8/17.
//  Copyright © 2017 Express Logic. All rights reserved.
//

import UIKit

protocol CoApServiceDelegate: class {
    
    func coapService(didReceiveMessage message: SCMessage)
    
}

class CoApService: NSObject {

    static let sharedInstance = CoApService()
    
    weak var delegate: CoApServiceDelegate?
    var coapClient: SCClient!
    
    override init() {
        super.init()
        coapClient = SCClient(delegate: self)
    }
    
    func sendMessage(payload: Data, data: Data, hostName: String="2602:30a:2c15:56f0:0200:11:2233:4422") {
        let m = SCMessage(code: SCCodeValue(classValue: 0, detailValue: 01)!, type: .confirmable, payload: payload)
        m.addOption(SCOption.uriPath.rawValue, data: "dest_table".data(using: .utf8)!)
        m.addOption(SCOption.uriPath.rawValue, data: "6lowpan".data(using: .utf8)!)
        m.addOption(SCOption.uriPath.rawValue, data: "global".data(using: .utf8)!)
        coapClient.sendCoAPMessage(m, hostName: hostName, port: 5683)
    }
    
}

extension CoApService: SCClientDelegate {
    
    func swiftCoapClient(_ client: SCClient, didReceiveMessage message: SCMessage) {
        self.delegate?.coapService(didReceiveMessage: message)
    }
    
}
