//
//  TopographyViewControllerEx.swift
//  ExpressLogic
//
//  Created by Wang Yu on 3/9/17.
//  Copyright © 2017 Express Logic. All rights reserved.
//

import UIKit

extension TopographyViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return scrollView
    }
    
}
