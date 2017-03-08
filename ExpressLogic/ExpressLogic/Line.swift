//
//  Line.swift
//  ExpressLogic
//
//  Created by Jenny Qu on 3/8/17.
//  Copyright © 2017 Express Logic. All rights reserved.
//

import UIKit
import CoreGraphics

class Line: NSObject {
    
    static func drawLine(in view: UIView, from start: CGPoint, to end: [CGPoint]) {
        
        UIGraphicsBeginImageContext(view.bounds.size);
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(UIColor.white.cgColor)
        context?.move(to: start)
        
        end.forEach { (p) in
            let mid = CGPoint(x: start.x, y: p.y)
            context?.addLine(to: mid)
            context?.addLine(to: y)
        }
        
        UIGraphicsEndImageContext()
        
        
        
    }
    
}
