//
//  NodeView.swift
//  ExpressLogic
//
//  Created by Wang Yu on 3/8/17.
//  Copyright © 2017 Express Logic. All rights reserved.
//

import UIKit


/// DEPRECATED VIEW! DO NOT USE!
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
        leftLabel.textAlignment = .right
        label.lineBreakMode = .byTruncatingMiddle
        label.textAlignment = .right
        
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
        let iconHeight: CGFloat = 30
        iconImageView.frame = CGRect(x: spacing * 1.2, y: self.bounds.midY - iconHeight / 2, width: iconHeight * 2 / 3, height: iconHeight)
        leftLabel.frame = CGRect(x: iconImageView.bounds.maxX + spacing,
                                 y: 0,
                                 width: 140,
                                 height: NodeView.size.height)
        label.frame = CGRect(x: leftLabel.bounds.maxX + spacing * 3,
                             y: 0,
                             width: NodeView.size.width - (leftLabel.bounds.maxX + spacing * 4),
                             height: NodeView.size.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


extension NodeView {
    
    func tailPoint() -> CGPoint {
        return CGPoint(x: self.frame.maxX + spacing * 1.6, y: self.frame.midY)
    }
    
    func headPoint() -> CGPoint {
        return CGPoint(x: self.frame.minX, y: self.frame.midY)
    }
    
}
