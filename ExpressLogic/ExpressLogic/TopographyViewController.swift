//
//  ViewController.swift
//  ExpressLogic
//
//  Created by Wang Yu on 3/8/17.
//  Copyright © 2017 Express Logic. All rights reserved.
//

import UIKit

var routingInfo: [(String, String)] = []

class TopographyViewController: UIViewController, TagViewDelegate {
    
    var scrollView: UIScrollView!
    let heightSpacing: CGFloat = 32
    let widthSpacing: CGFloat = 120
        
    let rootAddress = "2001:0470:f81e:3000:2c09:0aff:fe00:76c8"
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
        
        let tag = TagView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.view.addSubview(tag)
        
        CoApService.sharedInstance.delegate = self
        send()
        updateView()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateView), name: NSNotification.Name(rawValue: "receiveRountingTable"), object: nil)
    }
    
    func send() {
        print("Send Packet")
        let api: Array<UInt8> = [1]
        let data = Data(bytes: api)
        CoApService.sharedInstance.sendMessage(payload: data, data: Data())
    }
    
    func updateView() {
        let headerHeight: CGFloat = 160
        let bounds = view.bounds
        let headerView = HeaderView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: headerHeight))
        scrollView = UIScrollView(frame: CGRect(x: 0, y: headerHeight, width: bounds.width, height: bounds.height - headerHeight))
        self.view.addSubview(headerView)
        self.view.addSubview(scrollView)
        headerView.setNeedsLayout()
        scrollView.contentSize = CGSize.zero
        scrollView.setContentOffset(CGPoint.zero, animated: false)
        let rttree = RTTree(root: rootAddress, routingInfo: routingInfo)
        routingMap.forEach { _, node in
            let view = TagView(frame: CGRect(
                x: CGFloat(node.level - 1) * (TagView.size.width + widthSpacing) + widthSpacing,
                y: (TagView.size.height / 2 + heightSpacing) * CGFloat(node.top),
                width:  TagView.size.width,
                height: TagView.size.height))
            view.setNodeString(node.address)
            view.setNeedsLayout()
            view.delegate = self
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    
    func tagViewDidClicked(target: TagView) {
        let popover = Popover(options: [PopoverOption.type(.up)])
        let popoverView = UIView.loadFromNibNamed("NodePopoverView") as! NodePopoverView
        popover.show(popoverView, fromView: target, inView: self.view)
        popover.didDismissHandler = { () in
            target.isSelected = false
            target.setNeedsLayout()
        }
        popoverView.frame = CGRect(x: 0, y: 0, width: 320, height: 200)
    }

}


