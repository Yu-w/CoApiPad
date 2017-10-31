//
//  CoApService.swift
//  ExpressLogic
//
//  Created by Wang Yu on 3/8/17.
//  Copyright © 2017 Express Logic. All rights reserved.
//

import UIKit

enum CoApEncodingType: String {
    case ascii
    case binary
}

class CoApService: NSObject {

    struct Host {
        static let prefix = "2003:6a57:35b7:3d4c"
        static let address = "211:22ff:fe33:4422"
        
        static func fullAddress() -> String {
            return Host.prefix + ":" + Host.address
        }
    }
    
    static let sharedInstance = CoApService()
    
    weak var v71Delegate: CoApServiceV71Delegate?
    weak var r21Delegate: CoApServiceR21Delegate?
    
    var coapClient: SCClient!
    
    override init() {
        super.init()
        coapClient = SCClient(delegate: self)
        coapClient.sendToken = false
        coapClient.cachingActive = false
    }
    
    static func getFullAddress(from address: String) -> String {
        return CoApService.Host.prefix + ":" + address
    }
    
    func getDestTable(hostName: String=CoApService.Host.fullAddress()) {
        get(hostName: hostName, method: "dest_table", encodingType: .binary)
    }
    
    func getRSSI(hostName: String) {
        get(hostName: hostName, method: "RSSI", encodingType: .ascii)
    }
    
    func ping(hostName: String) {
        let m = SCMessage(code: SCCodeValue(classValue: 0, detailValue: 01)!, type: .reset, payload: nil)
        coapClient.sendCoAPMessage(m, hostName: hostName, port: 5683)
    }
    
    private func get(hostName: String, method: String, encodingType: CoApEncodingType) {
        let m = SCMessage(code: SCCodeValue(classValue: 0, detailValue: 01)!, type: .confirmable, payload: nil)
        m.addOption(SCOption.uriPath.rawValue, data: method.data(using: .utf8)!)
        m.addOption(SCOption.uriPath.rawValue, data: encodingType.rawValue.data(using: .utf8)!)
        m.addOption(SCOption.block2.rawValue, data: Data(bytes: [4]))
        
        coapClient.sendCoAPMessage(m, hostName: hostName, port: 5683)
    }
    
//    func sendMessage(payload: Data, data: Data) {
//        let m = SCMessage(code: SCCodeValue(classValue: 0, detailValue: 01)!, type: .confirmable, payload: nil)
//        m.addOption(SCOption.uriPath.rawValue, data: "dest_table".data(using: .utf8)!)
//        m.addOption(SCOption.uriPath.rawValue, data: "binary".data(using: .utf8)!)
//        m.addOption(SCOption.block2.rawValue, data: Data(bytes: [4]))
//        coapClient.sendToken = false
//        coapClient.cachingActive = false
//
//        coapClient.sendCoAPMessage(m, hostName: CoApService.hostName, port: 5683)
//    }

    
}

extension CoApService: SCClientDelegate {
    
    func swiftCoapClient(_ client: SCClient, didReceiveMessage message: SCMessage) {
        if let asciiMessage = message.payload?.toAscii() {
            // RSSI
            if asciiMessage.contains("\n") {
                let rssi = asciiMessage
                    .split(separator: "\n")
                    .map { x in String(x) }
                var table = Dictionary<String, Int>()
                rssi.forEach { x in
                    let components = x.split(separator: " ").map { x in String(x) }
                    table[components[0].lowercased()] = Int(components[1])
                }
                self.v71Delegate?.coapService(didReceiveRSSI: table)
                self.r21Delegate?.coapService(didReceiveRSSI: table)
            // dest_table
            } else {
                self.v71Delegate?.coapService(didReceiveDestTable: message.payload!.toIPv6())
            }
        } else {
            fatalError()
        }
    }

}
