//
//  ViewController.swift
//  ExpressLogic
//
//  Created by Wang Yu on 3/8/17.
//  Copyright © 2017 Express Logic. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var scrollView: UIScrollView!
    let heightSpacing: CGFloat = 32
    let widthSpacing: CGFloat = 100
        
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

        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Poly2.png")!)
        
        let blackView = UIView()
        blackView.frame = view.bounds
        blackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.view.addSubview(blackView)
        
        let logo = UIImageView(frame: CGRect(x: 84, y: 75, width: 222, height: 37))
        logo.image = UIImage(named: "logo.png")
        self.view.addSubview(logo)
        
        func ratingButtonTapped() {
            print("Button pressed")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let screenBounds = UIScreen.main.bounds
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 160, width: screenBounds.width, height: UIScreen.main.bounds.height - 160))
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: screenBounds.width * 1.4, height: screenBounds.height * 2)
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
        Line.drawLine(in: self.scrollView, from: CGPoint(x: 0, y: 0), to: [self.scrollView.center])
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
<<<<<<< HEAD

=======
    
>>>>>>> 3ccfbcdac3fb8ab8b5e7ae7ec880a6a94731dd3b
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonDidClicked(_ sender: UIButton) {

    }

}


