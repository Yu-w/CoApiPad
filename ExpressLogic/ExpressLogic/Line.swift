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
        
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: start)

        end.forEach { (p) in
            linePath.addLine(to: CGPoint(x: start.x, y: p.y))
            linePath.addLine(to: p)
        }
        
        line.path = linePath.cgPath
        line.strokeColor = UIColor.white.cgColor
        line.fillColor = UIColor.clear.cgColor
        line.lineWidth = 3
        view.layer.addSublayer(line)
        
    }
    
}
