//
//  TagView.swift
//  ExpressLogic
//
//  Created by Dave Guo on 4/12/17.
//  Copyright © 2017 Express Logic. All rights reserved.
//

import UIKit

protocol TagViewDelegate: class {
    func tagViewDidClicked(target: TagView)
}

class TagView: UIView {
    
    var label: UILabel!
    var imageView: UIImageView!
    weak var delegate: TagViewDelegate?
    
    @IBInspectable var isSelected: Bool = false
    
    static let size = CGSize(width: 85, height: 38)
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        label = UILabel(frame: CGRect.zero)
        label.textAlignment = .right
        label.textColor = UIColor(red:0.96, green:0.65, blue:0.14, alpha:1.00)
        self.addSubview(label)
        imageView   = UIImageView(frame: self.bounds)
        self.addSubview(imageView)
        self.sendSubview(toBack: imageView)
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.clicked (_:)))
        self.addGestureRecognizer(gesture)

    }
    override func layoutSubviews() {
        super.layoutSubviews()
        var bgImage     = #imageLiteral(resourceName: "tag")
        if (isSelected){
            bgImage = #imageLiteral(resourceName: "tagSelected")
        }
        imageView.image = bgImage
        label.frame = CGRect(x: TagView.size.height,
                             y: 0,
                             width: TagView.size.width / 2,
                             height: TagView.size.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setNodeString(_ text: String) {
        self.label.text = "V71"
    }
    
    func clicked(_ sender:UITapGestureRecognizer){
        isSelected = true
        self.setNeedsLayout()
        delegate?.tagViewDidClicked(target: self)
    }
}

extension TagView {
    
    func tailPoint() -> CGPoint {
        return CGPoint(x: self.frame.maxX * 1.05, y: self.frame.midY)
    }
    
    func headPoint() -> CGPoint {
        return CGPoint(x: self.frame.minX * 0.98, y: self.frame.midY)
    }
    
    func centerPoint() -> CGPoint {
        return CGPoint(x: self.frame.midX, y: self.frame.midY)
    }
    
}
