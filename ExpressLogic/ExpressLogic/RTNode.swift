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
    var parents: [RTNode]? = []
    
    var width: Int = 0
    var level: Int = 0
    var top: Int = 0
    var nodeView: TagView?
    
    init(address: String) {
        self.address = address
    }
    
}

extension RTNode {
    
    func findPathNodes() -> [RTNode] {
        var path: [RTNode] = []
//        var curNode: RTNode? = self
//        while curNode != nil {
//            path.append(curNode!)
//            curNode = curNode?.parents?.first
//        }
//        path.reverse()
//        return path
        /// now node's parent contain all parent from that node, weird
        path.append(contentsOf: self.parents ?? [])
        path.append(self)
        return path
    }
    
}
