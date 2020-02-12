//
//  Storyboarded.swift
//  DeezerFun
//
//  Created by Erick Vavretchek on 11/2/20.
//  Copyright © 2020 Erick Vavretchek. All rights reserved.
//

import UIKit

protocol Storyboarded { }

extension Storyboarded where Self: UIViewController  {
    
    static func instantiate(withStoryboard storyboardName: String? = nil, bundle: Bundle = Bundle.main) -> Self {
        
        let storyboardIdentifier = String(describing: self)
        var storyboard: UIStoryboard?
        
        if let storyboardName = storyboardName {
            if isStoryboard(name: storyboardName, bundle: bundle) {
                storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
            }
        } else {
            let probableStoryboardName = String(describing: self).replacingOccurrences(of: "ViewController", with: "")
            if isStoryboard(name: probableStoryboardName, bundle: bundle) {
                storyboard = UIStoryboard(name: probableStoryboardName, bundle: Bundle.main)
            }
        }
        
        guard storyboard != nil else {
            fatalError("No storyboard found")
        }
        
        return storyboard!.instantiateViewController(withIdentifier: storyboardIdentifier) as! Self
    }
    
    private static func isStoryboard(name: String, bundle: Bundle) -> Bool {
        return bundle.path(forResource: name, ofType: "storyboardc") != nil ? true : false
    }
}
