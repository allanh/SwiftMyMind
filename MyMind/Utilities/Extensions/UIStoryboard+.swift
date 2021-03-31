//
//  UIStoryboard+.swift
//  MyMind
//
//  Created by Barry Chen on 2021/3/19.
//

import UIKit

extension UIStoryboard {
    func instantiateViewController<T>(ofType type: T.Type) -> T? {
        return instantiateViewController(withIdentifier: String(describing: type)) as? T
    }
}
