//
//  RTNode.swift
//  ExpressLogic
//
//  Created by Wang Yu on 3/8/17.
//  Copyright © 2017 Express Logic. All rights reserved.
//

import Foundation

class RTNode {
    
    var address: String
    var children: [RTNode] = []
    
    var width: Int = 0
    var level: Int = 0
    var top: Int = 0
    var nodeView: TagView?
    
    init(address: String) {
        self.address = address
    }
    
}
