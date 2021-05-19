//
//  PickProductMaterialsViewController.swift
//  MyMind
//
//  Created by Chen Yi-Wei on 2021/5/19.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class PickProductMaterialsViewController: NiblessViewController {

    let viewModel: PickProductMaterialsViewModel

    init(viewModel: PickProductMaterialsViewModel) {
        self.viewModel = viewModel
        super.init()
    }
}
