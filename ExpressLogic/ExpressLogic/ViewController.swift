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
    let heightSpacing: CGFloat = 10
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor.darkGray
        let screenBounds = UIScreen.main.bounds
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: screenBounds.width, height: UIScreen.main.bounds.height))
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: screenBounds.width * 1.4, height: screenBounds.height * 2)
        _ = RTTree(root: rootAddress, routingInfo: routingInfo)
        routingMap.forEach { addr, node in
            let view = NodeView(frame: CGRect(
                x: CGFloat(node.level - 1) * (NodeView.size.width + widthSpacing) + widthSpacing,
                y: (NodeView.size.height + heightSpacing) * CGFloat(node.top),
                width:  NodeView.size.width,
                height: NodeView.size.height))
            view.setNodeString(node.address)
            view.setNeedsLayout()
            self.scrollView.addSubview(view)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonDidClicked(_ sender: UIButton) {
        let m = SCMessage(code: SCCodeValue(classValue: 0, detailValue: 01)!, type: .confirmable, payload: "test".data(using: String.Encoding.utf8))
        m.addOption(SCOption.uriPath.rawValue, data: "test".data(using: String.Encoding.utf8)!)
        let coapClient = SCClient(delegate: self)
        coapClient.sendCoAPMessage(m, hostName: "localhost", port: 5683)
    }

}

extension ViewController: SCClientDelegate {
    func swiftCoapClient(_ client: SCClient, didReceiveMessage message: SCMessage) {
        print(String(data: message.payload!, encoding: String.Encoding.utf8) as String!)
    }
}

