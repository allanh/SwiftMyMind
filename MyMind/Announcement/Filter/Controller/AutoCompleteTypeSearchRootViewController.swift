//
//  AutoCompleteSearchTypeRootView.swift
//  MyMind
//
//  Created by Chijung Chan on 2021/9/3.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
import RxSwift

class AutoCompleteTypeSearchRootViewController: NiblessViewController {
    // MARK: - View
    let titleLable: UILabel = UILabel {
        $0.font = .pingFangTCRegular(ofSize: 18)
        $0.textColor = .veryDarkGray
    }
    
    let contentview: UIView = UIView {
        $0.backgroundColor = .white
    }
    
    let systemButton: UIButton = UIButton {
        $0.isSelected = false
        $0.setTitle("系統", for: .normal)
        $0.setTitleColor(.brownGrey, for: .normal)
        $0.setTitleColor(.white, for: .selected)
        $0.backgroundColor = .veryLightPink
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 4
    }
    
    let featureButton: UIButton = UIButton {
        $0.isSelected = false
        $0.setTitle("功能", for: .normal)
        $0.setTitleColor(.brownGrey, for: .normal)
        $0.setTitleColor(.white, for: .selected)
        $0.backgroundColor = .veryLightPink
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 4
    }
    
    let optimizationButton: UIButton = UIButton {
        $0.isSelected = false
        $0.setTitle("優化", for: .normal)
        $0.setTitleColor(.brownGrey, for: .normal)
        $0.setTitleColor(.white, for: .selected)
        $0.backgroundColor = .veryLightPink
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 4
    }
    
    let platformNewsButton: UIButton = UIButton {
        $0.isSelected = false
        $0.setTitle("平台消息", for: .normal)
        $0.setTitleColor(.brownGrey, for: .normal)
        $0.setTitleColor(.white, for: .selected)
        $0.backgroundColor = .veryLightPink
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 4
    }
    
    let policyButton: UIButton = UIButton {
        $0.isSelected = false
        $0.setTitle("政策", for: .normal)
        $0.setTitleColor(.brownGrey, for: .normal)
        $0.setTitleColor(.white, for: .selected)
        $0.backgroundColor = .veryLightPink
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 4
    }

    private let seperatorView: UIView = UIView {
        $0.backgroundColor = UIColor.separator
    }
    
    let viewModel: PickAnnouncementTypeViewModel
    let bag: DisposeBag = DisposeBag()
    
    init(viewModel: PickAnnouncementTypeViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLable.text = viewModel.title
        constructViewHierarchy()
        activateConstraints()
        addButtonActions()
    }
    
    //MARK: Methods
    private func constructViewHierarchy() {
        view.addSubview(contentview)
        contentview.addSubview(titleLable)
        contentview.addSubview(seperatorView)
        contentview.addSubview(systemButton)
        contentview.addSubview(featureButton)
        contentview.addSubview(optimizationButton)
        contentview.addSubview(platformNewsButton)
        contentview.addSubview(policyButton)
    }
    
    private func activateConstraints() {
        activateConstraintsTitleLabel()
        activateConstraintsStackView()
        activateConstraintsSeperatorView()
        activateConstraintsSystemButton()
        activateConstraintsFeatureButton()
        activateConstraintsOptimizationButton()
        activateConstraintsPlatformButton()
        activateConstraintsPolicyButton()
    }
    
    private func bindToViewModel() {
        
    }
    
    private func subscribeViewModel() {
        
    }
    
    private func configButton(item: AnnouncementType) {
        
    }
    
    private func selectItem(item: AnnouncementType) {
        viewModel.pickedType.accept(item)
    }
    
    private func addButtonActions() {
        systemButton.addTarget(self,
        action: #selector(buttonsDidTapped(_:)), for: .touchUpInside)
        featureButton.addTarget(self,
        action: #selector(buttonsDidTapped(_:)), for: .touchUpInside)
        optimizationButton.addTarget(self,
        action: #selector(buttonsDidTapped(_:)), for: .touchUpInside)
        platformNewsButton.addTarget(self,
        action: #selector(buttonsDidTapped(_:)), for: .touchUpInside)
        policyButton.addTarget(self,
        action:#selector(buttonsDidTapped(_:)), for: .touchUpInside)
    }
    
    @objc
    private func buttonsDidTapped(_ sender: UIButton){
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true {
            sender.backgroundColor = .prussianBlue
        } else {
            sender.backgroundColor = .veryLightPink
        }
    }
}
// MARK: - Layouts
extension AutoCompleteTypeSearchRootViewController{
    private func activateConstraintsTitleLabel() {
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        let top = titleLable.topAnchor
            .constraint(equalTo: contentview.topAnchor)
        let leading = titleLable.leadingAnchor
            .constraint(equalTo: contentview.leadingAnchor, constant: 20)
        
        NSLayoutConstraint.activate([
            top, leading
        ])
    }
    
    private func activateConstraintsStackView() {
        contentview.translatesAutoresizingMaskIntoConstraints = false
        let top = contentview.topAnchor
            .constraint(equalTo: view.bottomAnchor, constant: 15)
        let leading = contentview.leadingAnchor
            .constraint(equalTo: view.leadingAnchor, constant: 20)
        let trailing = contentview.trailingAnchor
            .constraint(equalTo: view.trailingAnchor, constant: -20)
        let height = contentview.heightAnchor
            .constraint(equalToConstant: 110)
        
        NSLayoutConstraint.activate([
            top, leading, trailing, height
        ])
    }
    private func activateConstraintsSystemButton() {
        systemButton.translatesAutoresizingMaskIntoConstraints = false
        let top = systemButton.topAnchor
            .constraint(equalTo: contentview.topAnchor)
        let leading = systemButton.leadingAnchor
            .constraint(equalTo: contentview.leadingAnchor)
        let height = systemButton.heightAnchor
            .constraint(equalToConstant: 32)
        
        NSLayoutConstraint.activate([
            top, leading, height
        ])
    }
    
    private func activateConstraintsFeatureButton() {
        featureButton.translatesAutoresizingMaskIntoConstraints = false
        let top = featureButton.topAnchor
            .constraint(equalTo: systemButton.topAnchor)
        let leading = featureButton.leadingAnchor
            .constraint(equalTo: systemButton.trailingAnchor,constant: 8)
        let height = featureButton.heightAnchor
            .constraint(equalTo: systemButton.heightAnchor)
        
        NSLayoutConstraint.activate([
            top, leading, height
        ])
    }
    
    private func activateConstraintsOptimizationButton() {
        optimizationButton.translatesAutoresizingMaskIntoConstraints = false
        let top = optimizationButton.topAnchor
            .constraint(equalTo: systemButton.topAnchor)
        let leading = optimizationButton.leadingAnchor
            .constraint(equalTo: optimizationButton.trailingAnchor)
        let height = optimizationButton.heightAnchor
            .constraint(equalTo: optimizationButton.heightAnchor)
        
        NSLayoutConstraint.activate([
            top, leading, height
        ])
    }
    
    private func activateConstraintsPlatformButton() {
        platformNewsButton.translatesAutoresizingMaskIntoConstraints = false
        let top = platformNewsButton.topAnchor
            .constraint(equalTo: systemButton.topAnchor)
        let leading = platformNewsButton.leadingAnchor
            .constraint(equalTo: optimizationButton.trailingAnchor, constant: 8)
        let height = platformNewsButton.heightAnchor
            .constraint(equalTo: systemButton.heightAnchor)
        
        NSLayoutConstraint.activate([
            top, leading, height
        ])
    }
    
    private func activateConstraintsPolicyButton() {
        policyButton.translatesAutoresizingMaskIntoConstraints = false
        let top = policyButton.topAnchor
            .constraint(equalTo: systemButton.bottomAnchor, constant: 8)
        let leading = policyButton.leadingAnchor
            .constraint(equalTo: systemButton.leadingAnchor)
        let height = policyButton.heightAnchor
            .constraint(equalTo: systemButton.heightAnchor)
        
        NSLayoutConstraint.activate([
            top, leading, height
        ])
    }
    
    private func activateConstraintsSeperatorView() {
        seperatorView.translatesAutoresizingMaskIntoConstraints = false
        let height = seperatorView.heightAnchor
            .constraint(equalToConstant: 1)
        let leading = seperatorView.leadingAnchor
            .constraint(equalTo: view.leadingAnchor,constant: 16)
        let trailing = seperatorView.trailingAnchor
            .constraint(equalTo: view.trailingAnchor, constant: -16)
        let bottom = seperatorView.bottomAnchor
            .constraint(equalTo: view.bottomAnchor)
        
        NSLayoutConstraint.activate([
            height, leading, trailing, bottom
        ])
        
    }
    
}
