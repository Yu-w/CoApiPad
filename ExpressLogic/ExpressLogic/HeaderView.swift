//
//  HeaderView.swift
//  ExpressLogic
//
//  Created by Dave Guo on 3/9/17.
//  Copyright © 2017 Express Logic. All rights reserved.
//

import UIKit

class HeaderView: UIView {
    var logo: UIImageView!
    var tabs: [UIButton]
    
    override init(frame: CGRect, buttons: ) {
        super.init(frame: frame)
        
        logo = UIImageView(frame: CGRect(x: 84, y: 75, width: 222, height: 37))
        logo.image = UIImage(named: "logo.png")
        self.addSubview(logo)
        
        tabs = UIButton

        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
