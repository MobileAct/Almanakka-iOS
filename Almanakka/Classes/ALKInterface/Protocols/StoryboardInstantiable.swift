//
//  StoryboardInstantiable.swift
//  Almanakka
//
//  Created by Kosuke Nishimura on 2019/12/19.
//  Copyright © 2020 Mobile Act, All rights reserved.
//

import UIKit

public protocol StoryboardInstantiable { }

public extension StoryboardInstantiable where Self: UIViewController {
    
    static func instantiateFromStoryboard(with identifier: String = className) -> Self {
                
        let bundle = Bundle(path: Bundle(for: self).path(forResource: "Almanakka", ofType: "bundle")!)
        
        let storyboard = UIStoryboard(name: className, bundle: bundle)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as? Self else {
            fatalError("failed to create \(className) with identifier `\(identifier)`")
        }
        
        return viewController
    }
}

extension UIViewController: StoryboardInstantiable { }
