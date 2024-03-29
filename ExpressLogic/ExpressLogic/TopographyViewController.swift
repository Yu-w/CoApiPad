//
//  ViewController.swift
//  ExpressLogic
//
//  Created by Wang Yu on 3/8/17.
//  Copyright © 2017 Express Logic. All rights reserved.
//

import UIKit

var routingInfo: [(String, String)] = []
let movingR21Addr = "0204:2519:5535:befd" //"fe80:0000:0000:0000:fec2:3d00:0004:a2da" //   // TODO: change this

let stationLoc: [(CGFloat, CGFloat)] = [(195,8),
                                        (195,535),
                                        (848,23)]

let routingLoc: [(CGFloat, CGFloat)] =
                    [(195,138),
//                  (470,319),
//                  (773,262),
//                  (558,603),
//                  (571,455),
//                  (281,603),
                    (195,665),
                    (848,153)]
//                  (366,138)]

class TopographyViewController: UIViewController, TagViewDelegate {
    
    var scrollView: UIScrollView!
    let heightSpacing: CGFloat = 32
    let widthSpacing: CGFloat = 120
    let headerHeight: CGFloat = 160
    var rttree: RTTree!
    
    let rootAddress = "2003:6a57:35b7:3d4c:211:22ff:fe33:4422"
//    let routingInfo = [("fe80:0000:0000:0000:fec2:3d00:0004:a2da", "fe80:0000:0000:0000:fec2:3d00:0004:a2da"),
//                       ("fe80:0000:0000:0000:fec2:3d00:0004:7bde", "fe80:0000:0000:0000:fec2:3d00:0004:7bde"),
//                       ("fe80:0000:0000:0000:fec2:3d00:0004:a063", "fe80:0000:0000:0000:fec2:3d00:0004:a063"),
//                       ("fe80:0000:0000:0000:fec2:3d00:0004:e9c1", "fe80:0000:0000:0000:fec2:3d00:0004:e9c1")]
//                       ("2001:0470:f81e:3000:fec2:3d00:0004:a063", "2001:0470:f81e:3000:fec2:3d00:0004:a063"),
//                       ("2001:0470:f81e:3000:fec2:3d00:0004:a2da", "2001:0470:f81e:3000:fec2:3d00:0004:a2da"),
//                       ("2001:0470:f81e:3000:fec2:3d00:0004:7bde", "2001:0470:f81e:3000:fec2:3d00:0004:7bde"),
//                       ("2001:0470:f81e:3000:fec2:3d00:0004:e9c1", "2001:0470:f81e:3000:fec2:3d00:0004:e9c1"),
//                       ("2001:0470:f81e:3000:0204:2519:1801:aa3b", "2001:0470:f81e:3000:fec2:3d00:0004:a063")
//                       ("2001:0470:f81e:3000:0204:2519:1801:aa3a", "2001:0470:f81e:3000:fec2:3d00:0004:a063")]
    
    let rootLoc:(CGFloat, CGFloat) = (84,384)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = #imageLiteral(resourceName: "background_2")
        backgroundImage.contentMode = UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        let blackView = UIView()
        blackView.frame = view.bounds
        blackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.view.addSubview(blackView)
        
//        updateView()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateView), name: NSNotification.Name(rawValue: "receiveRountingTable"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.redrawLine), name: NSNotification.Name(rawValue: "redrawLine"), object: nil)
        
        ChipConnector.shared.run()
    }
    
    @objc func redrawLine() {
        Line.removeAllLines()
        Line.removeAllCircles()
        drawLineBetweenNodes(root: rttree.root)
    }
    
    @objc func updateView() {
        let bounds = view.bounds
        let headerView = HeaderView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: headerHeight))
        scrollView = UIScrollView(frame: CGRect(x: 0, y: headerHeight, width: bounds.width, height: bounds.height - headerHeight))
        self.view.addSubview(headerView)
        self.view.addSubview(scrollView)
        headerView.setNeedsLayout()
        scrollView.contentSize = CGSize(width: bounds.width, height: bounds.height - headerHeight)
        scrollView.setContentOffset(CGPoint.zero, animated: false)
        self.rttree = RTTree(root: rootAddress, routingInfo: routingInfo)
        var count = 0
        routingMap.forEach { _, node in
            let isRoot = node.address == rootAddress
            let isMovingR21 = node.address == movingR21Addr
            let view = TagView(frame: CGRect(
                x: CGFloat(isMovingR21 ? 300 : isRoot ? rootLoc.0 : routingLoc[count].0),
                y: CGFloat(isMovingR21 ? 300 : isRoot ? rootLoc.1 : routingLoc[count].1)-130,
                width:  TagView.size.width,
                height: TagView.size.height))
//            view.r21Connector = node
            view.tag = count
            count += isMovingR21 || isRoot ? 0 : 1
//            let nodeString = isRoot ? "00" : count < 10 ? "0" + count.description: count.description
            view.setNodeString(node.address) // TODO: use node.name
            view.address = node.address
            view.setNeedsLayout()
            view.delegate = self
            self.scrollView.addSubview(view)
            node.nodeView = view
        }
        drawLineBetweenNodes(root: rttree.root)
        
//        let maxSize = routingMap
//            .map {_, v in v}
//            .flatMap {n in n.nodeView}
//            .reduce(CGSize.zero) {
//                accum, cur in
//                return CGSize(width: max(accum.width, cur.frame.maxX),
//                              height: max(accum.height, cur.frame.maxY))
//        }
//        scrollView.contentSize = CGSize.init(width: maxSize.width + widthSpacing,
//                                             height: maxSize.height + heightSpacing * 4)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    public func drawLineBetweenNodes(root: RTNode) {
        if !root.children.isEmpty {
            if let nodeView = root.nodeView {
                let startPoint = nodeView.tailPoint()
                let endPoints = root.children
                    .flatMap { n in n.nodeView }
                    .map { x in x.headPoint() }
                Line.drawLine(in: scrollView, from: startPoint, to: endPoints)
            }
            root.children.forEach { node in drawLineBetweenNodes(root: node) }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tagViewDidClicked(target: TagView) {
        let glowCircle = GlowCircle(center: CGPoint(x: -200, y: 0), radius: 12)
        glowCircle.grow(isGrow: true)
        self.scrollView.addSubview(glowCircle)
        
        let path = UIBezierPath()
        var pathNodes = routingMap[target.address]?.findPathNodes()
//        var pulseAnimations = [LFTPulseAnimation]()
//        pathNodes?.forEach({ (p) in
//            let pulseEffect = LFTPulseAnimation(repeatCount: Float.infinity, radius: 44, position: p.nodeView!.headPoint())
//            pulseAnimations.append(pulseEffect)
//            scrollView.layer.insertSublayer(pulseEffect, below: p.nodeView!.layer)
//        })
        
        let firstNode = pathNodes?.first
        pathNodes = Array(pathNodes!.dropFirst())
        path.move(to: firstNode!.nodeView!.headPoint())
        pathNodes?.forEach { path.addLine(to: $0.nodeView!.headPoint()) }
        if (pathNodes!.last?.nodeView) != nil {
            path.addLine(to: pathNodes!.last!.nodeView!.headPoint()) // stop a key frame at the last node
        }
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            glowCircle.removeFromSuperview()
//            DispatchQueue.delay(1) {
//                pulseAnimations.forEach { $0.removeFromSuperlayer() }
//            }
        }
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = path.cgPath
        animation.repeatCount = 0
        animation.duration = TimeInterval(pathNodes?.count ?? 0)
        glowCircle.layer.add(animation, forKey: "animate position along path")
        CATransaction.commit()

        // LED
        ChipConnector.shared.getR21Connector(address: target.address)?.led()
    }
    
    func tagViewDidLongPress(target: TagView) {
        var popover: Popover
        if (target.frame.maxY + 400 > self.view.bounds.maxY){
            popover = Popover(options: [PopoverOption.type(.up)])
        }else {
            popover = Popover(options: [PopoverOption.type(.down)])
        }
        
        
        let popoverView = UIView.loadFromNibNamed("NodePopoverView") as! NodePopoverView
        popover.show(popoverView, fromView: target, inView: self.view)
//        popover.didDismissHandler = { () in
//            target.setNeedsLayout()
//        }
        popoverView.frame = CGRect(x: 0, y: 0, width: 320, height: 200)
    }
}


