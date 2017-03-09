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
    var tabView: UIView!
    var tabs: [UIButton] = []
    var previousTab: UIButton!
    
    let numOfTabs = 2
    let width: CGFloat = 100
    let spacing: CGFloat = 32
    let tabNames = ["Dashboard", "Topography"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        logo = UIImageView(frame: CGRect.zero)
        logo.image = UIImage(named: "logo.png")
        self.addSubview(logo)
        
        tabView = UIView(frame: CGRect.zero)
        for index in 0..<numOfTabs {
            let button = UIButton(frame: CGRect(x: CGFloat(index) * (width+spacing)+spacing/2, y: 0, width: width, height: 32))
            button.setTitle(tabNames[index], for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
            button.setTitleColor(UIColor.white, for: .normal)
            let selectedImage = #imageLiteral(resourceName: "under")
            button.setBackgroundImage(selectedImage, for: .selected)
            button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
            
            tabView.addSubview(button)
            tabs.append(button)
        }
        tabs[1].isSelected = true
        previousTab = tabs[1]
        
        self.addSubview(tabView)
        
        self.backgroundColor = UIColor.clear
    }
    
    func didTapButton(sender: UIButton) {
        if previousTab != nil {
            previousTab.isSelected = false
        }
        sender.isSelected = true
        previousTab = sender
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        logo.frame = CGRect(x: 84, y: 75, width: 222, height: 37)
        tabView.frame = CGRect(
            x: self.bounds.width - CGFloat(numOfTabs + 1) * (width+spacing),
            y: 75.0,
            width:
            CGFloat(numOfTabs) * (width+spacing), height: 42.0)
    }
}
