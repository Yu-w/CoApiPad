//
//  NodeView.swift
//  ExpressLogic
//
//  Created by Wang Yu on 3/8/17.
//  Copyright © 2017 Express Logic. All rights reserved.
//

import UIKit

class NodeView: UIView {

    var label: UILabel!
    var leftLabel: UILabel!
    var iconImageView: UIImageView!
    
    let spacing: CGFloat = 16
    static let size = CGSize(width: 320, height: 72)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label = UILabel(frame: CGRect.zero)
        leftLabel = UILabel(frame: CGRect.zero)
        iconImageView = UIImageView(frame: CGRect.zero)
        
        iconImageView.image = #imageLiteral(resourceName: "circuit-icon")
        leftLabel.textColor = UIColor(red:0.96, green:0.65, blue:0.14, alpha:1.00)
        leftLabel.text = "ATMEL SAM V71"
        label.lineBreakMode = .byTruncatingMiddle
        
        self.addSubview(label)
        self.addSubview(leftLabel)
        self.addSubview(iconImageView)
        
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 6
        self.clipsToBounds = true
    }
    
    func setNodeString(_ text: String) {
        self.label.text = text
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconImageView.frame = CGRect(x: spacing, y: NodeView.size.height / 2 - 16, width: 24, height: 32)
        leftLabel.frame = CGRect(x: iconImageView.frame.origin.x + spacing + 24,
                                 y: 0,
                                 width: 140,
                                 height: NodeView.size.height)
        label.frame = CGRect(x: iconImageView.frame.origin.x + spacing + 24 + leftLabel.bounds.width,
                             y: 0,
                             width: NodeView.size.width - (iconImageView.frame.origin.x + spacing + 24 + leftLabel.bounds.width),
                             height: NodeView.size.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
