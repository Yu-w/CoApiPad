//
//  shakingNode.swift
//  ExpressLogic
//
//  Created by Dave Guo on 11/7/17.
//  Copyright © 2017 Express Logic. All rights reserved.
//

import Foundation
import UIKit

let offset = 10

func shakeNodes(address: String) {
    let view = routingMap[address]?.nodeView
    let randomNum:UInt32 = arc4random_uniform(UInt32(offset))
    let x = stationLoc[view!.tag].0 + CGFloat(randomNum)
    let y = stationLoc[view!.tag].1 + CGFloat(randomNum)
    view!.frame = CGRect(origin: CGPoint.init(x: x, y: y), size: view!.frame.size)
}
