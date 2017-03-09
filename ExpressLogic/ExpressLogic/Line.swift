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
        let circle = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 18.0, height: 18.0))
        circle.center = start
        circle.layer.cornerRadius = 9
        circle.backgroundColor = UIColor.white
        circle.clipsToBounds = true
        view.addSubview(circle)
        
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: start)

        end.forEach { (p) in
            if p.y>start.y{
                linePath.addLine(to: CGPoint(x: start.x, y: p.y-15))
                linePath.addQuadCurve(to: CGPoint(x: start.x+15, y: p.y), controlPoint:CGPoint(x: start.x, y: p.y))
            }else{
                linePath.addLine(to: CGPoint(x: start.x, y: p.y+15))
                linePath.addQuadCurve(to: CGPoint(x: start.x+15, y: p.y), controlPoint:CGPoint(x: start.x, y: p.y))
            }
            linePath.addLine(to: p)
            linePath.move(to: start)
        }
        linePath.close()
        line.path = linePath.cgPath
        line.strokeColor = UIColor.white.cgColor
        line.fillColor = UIColor.clear.cgColor
        line.lineWidth = 6
        view.layer.addSublayer(line)
        
    }
    
}
