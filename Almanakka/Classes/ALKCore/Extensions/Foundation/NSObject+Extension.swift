//
//  NSObject+Extension.swift
//  Core
//
//  Created by Kosuke Nishimura on 2019/12/12.
//  Copyright © 2020 Mobile Act, All rights reserved.
//

import Foundation

public extension NSObject {
    
    class var className: String {
        return String(describing: self)
    }
    
    var className: String {
        return type(of: self).className
    }
}
