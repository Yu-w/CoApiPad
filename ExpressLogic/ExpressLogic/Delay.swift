//
//  Delay.swift
//  ExpressLogic
//
//  Created by Wang Yu on 4/22/17.
//  Copyright © 2017 Express Logic. All rights reserved.
//

import Foundation

extension DispatchQueue {
    
    static func delay(_ time: Int, _ callback: @escaping () -> ()) {
        let deadlineTime = DispatchTime.now() + .seconds(time)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            callback()
        }
    }
    
}
