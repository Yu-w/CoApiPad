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
        let circle = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 12.0, height: 12.0))
        circle.center = start
        circle.layer.cornerRadius = 6
        circle.backgroundColor = UIColor.white
        circle.clipsToBounds = true
        view.addSubview(circle)
        
        let line = CAShapeLayer()
        var linePath = UIBezierPath()
        let tailwidth:CGFloat = 2.5
        let headwidth:CGFloat = 12
        let path = CGMutablePath()
        path.move(to: start)
        
        end.forEach { (p) in
            let length = hypot(p.x - start.x, p.y - start.y)
            let tailLength = length - 16
            
            func m(_ x: CGFloat, _ y: CGFloat) -> CGPoint { return CGPoint(x: x, y: y) }
            let points: [CGPoint] = [
                m(0, tailwidth / 2),
                m(tailLength, tailwidth / 2),
                m(tailLength, headwidth / 2),
                m(length, 0),
                m(tailLength, -headwidth / 2),
                m(tailLength, -tailwidth / 2),
                m(0, -tailwidth / 2)
            ]

            let cosine = (p.x - start.x) / length
            let sine = (p.y - start.y) / length
            let transform = CGAffineTransform(a: cosine, b: sine, c: -sine, d: cosine, tx: start.x, ty: start.y)

            path.addLines(between: points, transform: transform )
            path.move(to: start)
            path.closeSubpath()
        }
        linePath.cgPath = path
        line.path = linePath.cgPath
        line.strokeColor = UIColor.white.cgColor
        line.fillColor = UIColor.white.cgColor
        line.lineWidth = 1.6
        view.layer.addSublayer(line)
        
    }
}

extension UIBezierPath {
    
    class func arrow(from start: CGPoint, to end: CGPoint, tailWidth: CGFloat, headWidth: CGFloat, headLength: CGFloat) -> Self {
        let length = hypot(end.x - start.x, end.y - start.y)
        let tailLength = length - headLength
        
        func p(_ x: CGFloat, _ y: CGFloat) -> CGPoint { return CGPoint(x: x, y: y) }
        let points: [CGPoint] = [
            p(0, tailWidth / 2),
            p(tailLength, tailWidth / 2),
            p(tailLength, headWidth / 2),
            p(length, 0),
            p(tailLength, -headWidth / 2),
            p(tailLength, -tailWidth / 2),
            p(0, -tailWidth / 2)
        ]
        
        let cosine = (end.x - start.x) / length
        let sine = (end.y - start.y) / length
        let transform = CGAffineTransform(a: cosine, b: sine, c: -sine, d: cosine, tx: start.x, ty: start.y)
        
        let path = CGMutablePath()
        path.addLines(between: points, transform: transform )
        path.closeSubpath()
        return self.init(cgPath: path)
    
    }
    
}
