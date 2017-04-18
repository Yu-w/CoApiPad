//
//  RTTree.swift
//  ExpressLogic
//
//  Created by Wang Yu on 3/8/17.
//  Copyright © 2017 Express Logic. All rights reserved.
//

import Foundation

var routingMap = [String: RTNode]()

class RTTree {
    
    var root: RTNode
    
    var widthMap = [Int: Int]()

    init(root: String, routingInfo: [(String, String)]) {
        routingMap[root] = RTNode(address: root)
        routingMap[root]?.parents = nil
        routingInfo.forEach { (dest, nextHop) in
            if routingMap[dest] == nil {
                routingMap[dest] = RTNode(address: dest)
            }
            if routingMap[nextHop] == nil {
                routingMap[nextHop] = RTNode(address: nextHop)
            }
        }
        routingInfo.forEach{ (dest, nextHop) in
            if dest == nextHop {
                routingMap[root]!.children.append(routingMap[dest]!)
                routingMap[dest]!.parents?.append(routingMap[root]!)
            } else {
                routingMap[nextHop]!.children.append(routingMap[dest]!)
                routingMap[dest]!.parents = routingMap[nextHop]!.parents
                routingMap[dest]!.parents?.append(routingMap[nextHop]!)
            }
        }
        self.root = routingMap[root]!
        
        maximumNodes()
    }

    func maximumNodes(current: RTNode, level: Int) -> Int {
        current.width = 0
        current.level = level
        current.children.forEach { child in
            current.width += maximumNodes(current: child, level: level + 1)
        }
        if current.width == 0 {
            current.width = 2
        }
        var l = level
        current.top = current.width / 2
        while l > 0 {
            if widthMap[l] == nil {
                widthMap[l] = 0
            }
            current.top = current.top + widthMap[l]!
            l = l - 1
        }
        
        widthMap[level] = widthMap[level]! + current.width
        return current.width
    }
    
    func maximumNodes() {
        _ = maximumNodes(current: root, level: 1)
    }

}

