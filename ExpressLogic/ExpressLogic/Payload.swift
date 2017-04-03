//
//  Payload.swift
//  ExpressLogic
//
//  Created by Wang Yu on 3/29/17.
//  Copyright © 2017 Express Logic. All rights reserved.
//

import Foundation

class Payload {
    
    init(buffer: Data) {
        switch buffer.first! {
        case UInt8(3):
            let bytes = buffer.subdata(in: 1..<buffer.count).swapUInt32Data().hexEncodedString()
            var res = ""
            for i in 0..<bytes.count {
                res += bytes[i]
                if (i + 1) % 16 == 0 {
                    res += " "
                } else if (i + 1) % 2 == 0 {
                    res += ":"
                }
            }
            res = String(res.characters.dropLast())
            let arr = res.components(separatedBy: " ")
            var routingTable: [(String, String)] = []
            for i in 0..<arr.count / 2 {
                routingTable.append((arr[i * 2], arr[i * 2 + 1]))
            }
            routingInfo = routingTable
            print(routingInfo)
            NotificationCenter.default.post(name:  NSNotification.Name(rawValue: "receiveRountingTable"), object: nil)
            break
        default: break
        }
    }
    
}

extension Data {
    func hexEncodedString() -> [String] {
        return map { String(format: "%02hhx", $0) }
    }
    
    func swapUInt32Data() -> Data {
        var mdata = self // make a mutable copy
        let count = self.count / MemoryLayout<UInt32>.size
        mdata.withUnsafeMutableBytes { (i32ptr: UnsafeMutablePointer<UInt32>) in
            for i in 0..<count {
                i32ptr[i] =  i32ptr[i].byteSwapped
            }
        }
        return mdata
    }
    
}
