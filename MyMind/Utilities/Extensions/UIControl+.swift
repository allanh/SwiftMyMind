//
//  UIControl+.swift
//  MyMind
//
//  Created by Barry Chen on 2021/3/26.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

@objc class ClosureSleeve: NSObject {
    let closure: ()->()

    init (_ closure: @escaping ()->()) {
        self.closure = closure
    }

    @objc func invoke () {
        closure()
    }
}

private var associateKey: Void?

extension UIControl {
    func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping () -> Void) {
        let sleeve = ClosureSleeve(closure)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
        objc_setAssociatedObject(self, &associateKey, sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }

    func removeAction() {
        objc_removeAssociatedObjects(self)
    }
}

extension UITapGestureRecognizer {
    func addAction(_ closure: @escaping ()->()) {
        let sleeve = ClosureSleeve(closure)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke))
        objc_setAssociatedObject(self, &associateKey, sleeve, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    func removeAction() {
        objc_removeAssociatedObjects(self)
    }
}
