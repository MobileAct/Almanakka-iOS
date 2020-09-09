//
//  BundleLoader.swift
//  Almanakka
//
//  Created by Oscar Peredo on 2020/08/06.
//

import Foundation

internal class BundleLoader {
    
    static func AlmanakkaBundle() -> Bundle {
        
        let bundleForClass = Bundle(for: self)
        
        guard let libraryBundlePath = bundleForClass.path(forResource: "Almanakka", ofType: "bundle") else {
            preconditionFailure("Almanakka bundle not found inside: '\(bundleForClass)'.")
        }
        
        guard let libraryBundle = Bundle(path: libraryBundlePath) else {
            preconditionFailure("Almanakka bundle not found at path: '\(libraryBundlePath)'.")

        }
                
        return libraryBundle
    }
}
