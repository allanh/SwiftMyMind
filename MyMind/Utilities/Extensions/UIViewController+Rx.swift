//
//  UIViewController+Rx.swift
//  MyMind
//
//  Created by Barry Chen on 2021/3/24.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import RxSwift

extension Reactive where Base: UIViewController {
    public var isActivityIndicatorAnimating: Binder<Bool> {
        return Binder.init(self.base, scheduler: MainScheduler.instance) { (viewController, isAnimating) in
            switch isAnimating {
            case true: viewController.startAnimatingActivityIndicator()
            case false: viewController.stopAnimatinActivityIndicator()
            }
        }
    }
}
