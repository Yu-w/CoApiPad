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
    var iconImageView: UIImageView!
    
    let spacing: CGFloat = 16
    static let size = CGSize(width: 280, height: 72)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label = UILabel(frame: CGRect.zero)
        iconImageView = UIImageView(frame: CGRect.zero)
        
        iconImageView.backgroundColor = UIColor.blue
        iconImageView.image = #imageLiteral(resourceName: "circuit-icon")
        
        self.addSubview(label)
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
        label.frame = self.bounds
        iconImageView.frame = CGRect(x: spacing, y: self.center.y - 16, width: 24, height: 32)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
