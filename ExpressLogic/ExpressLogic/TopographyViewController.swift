//
//  ViewController.swift
//  ExpressLogic
//
//  Created by Wang Yu on 3/8/17.
//  Copyright © 2017 Express Logic. All rights reserved.
//

import UIKit

class TopographyViewController: UIViewController {
    
    var scrollView: UIScrollView!
    let heightSpacing: CGFloat = 32
    let widthSpacing: CGFloat = 120
        
    let rootAddress = "2001:470:f81e:3000:2c09:aff:fe00:76c8"
    let routingInfo = [("fe80:0000:0000:0000:fec2:3d00:0004:a2da", "fe80:0000:0000:0000:fec2:3d00:0004:a2da"),
                       ("fe80:0000:0000:0000:fec2:3d00:0004:7bde", "fe80:0000:0000:0000:fec2:3d00:0004:7bde"),
                       ("fe80:0000:0000:0000:fec2:3d00:0004:a063", "fe80:0000:0000:0000:fec2:3d00:0004:a063"),
                       ("fe80:0000:0000:0000:fec2:3d00:0004:e9c1", "fe80:0000:0000:0000:fec2:3d00:0004:e9c1"),
                       ("2001:0470:f81e:3000:fec2:3d00:0004:a063", "2001:0470:f81e:3000:fec2:3d00:0004:a063"),
                       ("2001:0470:f81e:3000:fec2:3d00:0004:a2da", "2001:0470:f81e:3000:fec2:3d00:0004:a2da"),
                       ("2001:0470:f81e:3000:fec2:3d00:0004:7bde", "2001:0470:f81e:3000:fec2:3d00:0004:7bde"),
                       ("2001:0470:f81e:3000:fec2:3d00:0004:e9c1", "2001:0470:f81e:3000:fec2:3d00:0004:e9c1"),
                       ("2001:0470:f81e:3000:0204:2519:1801:aa3b", "2001:0470:f81e:3000:fec2:3d00:0004:a063"),
                       ("2001:0470:f81e:3000:0204:2519:1801:aa3a", "2001:0470:f81e:3000:fec2:3d00:0004:a063")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = #imageLiteral(resourceName: "background_1")
        backgroundImage.contentMode = UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        let blackView = UIView()
        blackView.frame = view.bounds
        blackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.view.addSubview(blackView)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let headerHeight: CGFloat = 160
        let bounds = view.bounds
        let headerView = HeaderView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: headerHeight))
        scrollView = UIScrollView(frame: CGRect(x: 0, y: headerHeight, width: bounds.width, height: bounds.height - headerHeight))
        self.view.addSubview(headerView)
        self.view.addSubview(scrollView)
        headerView.setNeedsLayout()
        scrollView.contentSize = CGSize.zero
        scrollView.setContentOffset(CGPoint.zero, animated: false)
        scrollView.delegate = self
        let rttree = RTTree(root: rootAddress, routingInfo: routingInfo)
        routingMap.forEach { _, node in
            let view = NodeView(frame: CGRect(
                x: CGFloat(node.level - 1) * (NodeView.size.width + widthSpacing) + widthSpacing,
                y: (NodeView.size.height / 2 + heightSpacing) * CGFloat(node.top),
                width:  NodeView.size.width,
                height: NodeView.size.height))
            view.setNodeString(node.address)
            view.setNeedsLayout()
            self.scrollView.addSubview(view)
            node.nodeView = view
        }
        drawLineBetweenNodes(root: rttree.root)
        let maxSize = routingMap
            .map {_, v in v}
            .flatMap {n in n.nodeView}
            .reduce(CGSize.zero) {
                accum, cur in
                return CGSize(width: max(accum.width, cur.frame.maxX),
                              height: max(accum.height, cur.frame.maxY))
        }
        scrollView.contentSize = CGSize.init(width: maxSize.width + widthSpacing,
                                             height: maxSize.height + heightSpacing * 4)
        
    }
    
    private func drawLineBetweenNodes(root: RTNode) {
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

}

