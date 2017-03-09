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

    weak var delegate: CoApServiceDelegate?
    var coapClient: SCClient!
    
    override init() {
        super.init()
        coapClient = SCClient(delegate: self)
    }
    
    func sendMessage(payload: Data, data: Data, hostName: String="localhost") {
        let m = SCMessage(code: SCCodeValue(classValue: 0, detailValue: 01)!, type: .confirmable, payload: payload)
        m.addOption(SCOption.uriPath.rawValue, data: data)
        coapClient.sendCoAPMessage(m, hostName: hostName, port: 5683)
    }
    
}

extension CoApService: SCClientDelegate {
    
    func swiftCoapClient(_ client: SCClient, didReceiveMessage message: SCMessage) {
        self.delegate?.coapService(didReceiveMessage: message)
    }
    
}
