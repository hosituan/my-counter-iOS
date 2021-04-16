//
//  ThenSwift.swift
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 15/04/2021.
//

import Foundation
import UIKit
protocol Then {}

extension Then where Self: Any {
    
    /// Makes it available to set properties with closures just after initializing.
    ///
    ///     let frame = CGRect().with {
    ///       $0.origin.x = 10
    ///       $0.size.width = 100
    ///     }
    func with(_ block: (inout Self) -> Void) -> Self {
        var copy = self
        block(&copy)
        return copy
    }
    
    /// Makes it available to execute something with closures.
    ///
    ///     UserDefaults.standard.do {
    ///       $0.set("devxoul", forKey: "username")
    ///       $0.set("devxoul@gmail.com", forKey: "email")
    ///       $0.synchronize()
    ///     }
    func `do`(_ block: (Self) -> Void) {
        block(self)
    }
    
}

extension Then where Self: AnyObject {
    
    /// Makes it available to set properties with closures just after initializing.
    ///
    ///     let label = UILabel().then {
    ///       $0.textAlignment = .Center
    ///       $0.textColor = UIColor.blackColor()
    ///       $0.text = "Hello, World!"
    ///     }
    func then(_ block: (Self) -> Void) -> Self {
        block(self)
        return self
    }
    
}

extension CGRect: Then {}
extension UIEdgeInsets: Then {}
extension NSObject: Then {}
