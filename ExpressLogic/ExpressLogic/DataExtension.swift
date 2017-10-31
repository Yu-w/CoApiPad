//
//  DataUtils.swift
//  ExpressLogic
//
//  Created by Wang Yu on 10/27/17.
//  Copyright © 2017 Express Logic. All rights reserved.
//

import Foundation

public extension Data {
    
    func toIPv6(_ num: Int=4) -> [String] {
        let bytes = self.swapUInt32Data().hexEncodedString()
        var res = ""
        for i in 0..<bytes.count {
            res += bytes[i]
            if (i + 1) % (num * 2) == 0 {
                res += " "
            } else if (i + 1) % 2 == 0 {
                res += ":"
            }
        }
        res = String(res.characters.dropLast())
        return res.components(separatedBy: " ")
    }
    
    func toAscii() -> String? {
        return String(data: self, encoding: .ascii)
    }
    
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

extension String.SubSequence {
    
    func toString() -> String {
        return String(self)
    }
    
}
