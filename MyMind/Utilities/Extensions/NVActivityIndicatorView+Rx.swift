//
//  NVActivityIndicatorView+Rx.swift
//  MyMind
//
//  Created by Barry Chen on 2021/3/26.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import RxSwift
import NVActivityIndicatorView

extension Reactive where Base: NVActivityIndicatorView {
    public var isAnimating: Binder<Bool> {
        return Binder.init(self.base, scheduler: MainScheduler.instance) { (indicator, isAnimating) in
            switch isAnimating {
            case true: indicator.startAnimating()
            case false: indicator.stopAnimating()
            }
        }
    }
}
