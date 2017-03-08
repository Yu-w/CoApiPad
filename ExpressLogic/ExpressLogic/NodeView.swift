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
    
    static let size = CGSize(width: 180, height: 44)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label = UILabel(frame: CGRect.zero)
        self.addSubview(label)
        self.backgroundColor = UIColor.red
    }
    
    func setNodeString(_ text: String) {
        self.label.text = text
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = self.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
