//
//  RangeExpression+.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/9/13.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
extension RangeExpression where Bound == String.Index  {
    func nsRange<S: StringProtocol>(in string: S) -> NSRange { .init(self, in: string) }
}
