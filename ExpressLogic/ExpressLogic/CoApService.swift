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
    
    func sendMessage(payload: Data, data: Data, hostName: String="2003:6a57:35b7:3d4c:211:22ff:fe33:4422") {
        let m = SCMessage(code: SCCodeValue(classValue: 0, detailValue: 01)!, type: .confirmable, payload: nil)
        m.addOption(SCOption.uriPath.rawValue, data: "dest_table".data(using: .utf8)!)
        m.addOption(SCOption.uriPath.rawValue, data: "ascii".data(using: .utf8)!)
        m.addOption(SCOption.block2.rawValue, data: Data(bytes: [4]))
        coapClient.sendToken = false
        coapClient.cachingActive = false
        
        coapClient.sendCoAPMessage(m, hostName: hostName, port: 5683)
    }
    
}

extension CoApService: SCClientDelegate {
    
    func swiftCoapClient(_ client: SCClient, didReceiveMessage message: SCMessage) {
        self.delegate?.coapService(didReceiveMessage: message)
    }
    
    func swiftCoapClient(_ client: SCClient, didSendMessage message: SCMessage, number: Int) {
        print("Did Send Message")
        print("Message: ", message)
    }
    
}

extension SCMessage {
    
    func decodePayload() -> String? {
        return String(data: self.payload!, encoding: .ascii)
    }
    
}
