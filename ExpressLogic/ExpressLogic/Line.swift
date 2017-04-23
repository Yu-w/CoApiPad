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
    
    static func getPt(start:CGPoint,end:CGPoint,newX:CGFloat) -> CGPoint {
        let start_x = start.x
        let start_y = start.y
        let end_x = end.x
        let end_y = end.y
        let k = (end_y-start_y)/(end_x-start_x)
        let b = start_y - k*start_x
        let newY = k*newX+b
        return CGPoint(x:newX,y:newY)
    }
    
    static func offset(start:CGPoint, p:CGPoint) -> CGFloat {
        let a: CGFloat = TagView.size.width - 5
        let b: CGFloat = TagView.size.height / 2 + 10.0
        let sin_theta = pow(fabs(p.y-start.y) / sqrt(pow((p.y-start.y),2) + pow((p.x-start.x),2)), 2)
        return a * b / sqrt(a * a * sin_theta + b * b * (1 - sin_theta))
    }
    
    static func drawLine(in view: UIView, from start: CGPoint, to end: [CGPoint]) {
        end.forEach{ (p) in
            let newX = (fabs(p.x-start.x) * offset(start:start, p:p) / sqrt(pow((p.y-start.y),2) + pow((p.x-start.x),2))) + start.x
            let new_start = getPt(start: start, end: p, newX: newX)
            let new_end = getPt(start: start, end: p, newX: p.x-8)
            
            let circle = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 8.0, height: 8.0))
            circle.center = new_start
            circle.layer.cornerRadius = 4
            circle.backgroundColor = UIColor.white
            circle.clipsToBounds = true
            view.addSubview(circle)
        
            let line = CAShapeLayer()
            let linePath = UIBezierPath()
            let path = CGMutablePath()
            
            path.move(to: new_start)
            path.arrow(from: new_start, to: new_end, tailwidth: 2.5, headwidth: 12, headLength: 16)
            path.closeSubpath()
            
            linePath.cgPath = path
            line.path = linePath.cgPath
            line.strokeColor = UIColor.white.cgColor
            line.fillColor = UIColor.white.cgColor
            line.lineWidth = 1.6
            view.layer.addSublayer(line)
        }
    }
    
    
    static func drawLineWithoutCircle(in view: UIView, from start: CGPoint, to end: [CGPoint]) {
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        let path = CGMutablePath()
        
        end.forEach { (p) in
            let points = newPoints(from: start, to: p, distance: 40)
            let newstart = points[0]
            let newend = points[1]
            path.arrow(from: newstart, to: newend, tailwidth: 2.5, headwidth: 12, headLength: 16)
            path.move(to: newstart)
            path.closeSubpath()
        }
        linePath.cgPath = path
        line.path = linePath.cgPath
        line.strokeColor = UIColor.white.cgColor
        line.fillColor = UIColor.white.cgColor
        line.lineWidth = 1.6
        view.layer.addSublayer(line)
    }
    
    
    static func newPoints(from start: CGPoint, to end: CGPoint, distance d: CGFloat) -> [CGPoint] {
        let x = end.x - start.x
        let y = end.y - start.y
        let length = hypot(x, y)
        let normx = x / length
        let normy = y / length
        return [CGPoint(x: start.x + d * normx, y: start.y + d * normy),
                CGPoint(x: end.x - d * normx, y: end.y - d * normy)]
    }

}

extension CGMutablePath {
    
    func arrow(from start: CGPoint, to end: CGPoint, tailwidth: CGFloat, headwidth: CGFloat, headLength: CGFloat) -> Void {
        let length = hypot(end.x - start.x, end.y - start.y)
        let tailLength = length - headLength
        
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
        
        let cosine = (end.x - start.x) / length
        let sine = (end.y - start.y) / length
        let transform = CGAffineTransform(a: cosine, b: sine, c: -sine, d: cosine, tx: start.x, ty: start.y)
        
        self.addLines(between: points, transform: transform )
        self.closeSubpath()
    }
    
}
