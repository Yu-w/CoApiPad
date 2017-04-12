//
//  UIViewExtension.swift
//  ExpressLogic
//
//  Created by Wang Yu on 4/12/17.
//  Copyright © 2017 Express Logic. All rights reserved.
//

import UIKit

extension UIView {

    //load a UIView fom xib
    class func loadFromNibNamed(_ nibNamed: String, bundle: Bundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }


}
