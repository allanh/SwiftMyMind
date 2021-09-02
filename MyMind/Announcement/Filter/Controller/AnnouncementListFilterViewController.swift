//
//  AnnouncementFilterViewController.swift
//  MyMind
//
//  Created by Chijung Chan on 2021/8/20.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
import PromiseKit
import RxSwift
import RxRelay
// MARK: - QueryType
enum AnnouncementQueryType: String, CustomStringConvertible, CaseIterable {
    case title, type, startedAt
    var description: String {
        switch self {
        case .title: return "公告標題"
        case .type: return "類別"
        case .startedAt: return "發布時間"
        }
    }
}

class AnnouncementListFilterViewController: NiblessViewController {
    // MARK: RootView
    private let scrollView: UIScrollView = UIScrollView {
        $0.backgroundColor = .white
        // 右側滑動指標
        $0.showsHorizontalScrollIndicator = false
    }
    
    private let contentView: UIView = UIView {
        $0.backgroundColor = .white
    }
    
    private let bottomView: FilterBottomView = FilterBottomView {
        $0.backgroundColor = .white
    }
    
    let viewModel: AnnouncementFilterViewModel
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.title
        view.backgroundColor = .white
        addTapToResignKeyboardGesture()
        constructViewHierarchy()
        avtivateConstraints()
        configNavigationBar()
        
        addChildViewControllers()
        configViewForChildViewControllers()
        configBottomView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeObservers()
    }
    // MARK:  - Method
    init(viewModel: AnnouncementFilterViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    private func configViewForChildViewControllers() {
        var lastChildView: UIView?
        for index in 0..<children.count {
            guard let childView = children[index].view else { return }
            childView.translatesAutoresizingMaskIntoConstraints = false
            childView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
            childView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
            
            if index == 0 {
                childView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
            }
            if let lastView = lastChildView {
                childView.topAnchor.constraint(equalTo: lastView.bottomAnchor).isActive = true
            }
            lastChildView = childView
        }
    }
    
    private func addChildViewControllers() {
        let allCases = AnnouncementQueryType.allCases
        allCases.forEach {
            switch $0 {
            case .title:
                addAutoSearchViewControllerAsChild(with: viewModel.announcementTitleViewModel)
                
            case .type:
                let viewController =
                    AnnouncementTypeSelectionViewController(viewModel: viewModel.announcementTypeViewModel)
                addViewControllerAsChild(viewController)
            case .startedAt:
                let viewController = AnnouncementQueryDateSelectionViewController(viewModel: viewModel.startedAtViewModel)
                addViewControllerAsChild(viewController)
            }
        }
    }
    
    private func addViewControllerAsChild(_ viewControler: UIViewController) {
        contentView.addSubview(viewControler.view)
        addChild(viewControler)
        viewControler.didMove(toParent: self)
    }
    
    private func addAutoSearchViewControllerAsChild(with viewModel: AutoCompleteSearchViewModel){
        let viewController = AutoCompleteSearchViewController(viewModel: viewModel)
        addViewControllerAsChild(viewController)
    }
    
    private func constructViewHierarchy() {
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
        view.addSubview(bottomView)
    }
    
    private func avtivateConstraints() {
        activateConstraintsBottomView()
        activateConstraintsScrollView()
        activateConstraontsContentView()
    }
    
    private func configNavigationBar() {
        navigationItem.title = "篩選條件"
        let closeButton = UIButton()
        closeButton.setImage(UIImage(named: "close"), for: .normal)
        closeButton.tintColor = .white
        closeButton.addTarget(self, action: #selector(closeButtonDidTapped(_:)), for: .touchUpInside)
        let leftBarItem = UIBarButtonItem(customView: closeButton)
        navigationItem.setLeftBarButton(leftBarItem, animated: true)
        
        let cleanButton = UIButton()
        cleanButton.setTitle("清除", for: .normal)
        cleanButton.setTitleColor(.white, for: .normal)
        cleanButton.addTarget(self, action: #selector(cleanButtonDidTapped(_:)), for: .touchUpInside)
        let rightBarItem = UIBarButtonItem(customView: cleanButton)
        navigationItem.setRightBarButton(rightBarItem, animated: true)
    }
    
    private func configBottomView() {
        bottomView.confirmButton.addTarget(self, action: #selector(confirmButtonDidTapped(_:)), for: .touchUpInside)
//        bottomView.cancelButton.addTarget(self, action: #selector(cleanButtonDidTapped(_:)), for: .touchUpInside)
    }
    
    @objc
    private func confirmButtonDidTapped(_ sender: UIButton) {
        viewModel.didUpdateQueryInfo(viewModel.queryInfo)
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func cleanButtonDidTapped(_ sender: UIButton) {
        viewModel.cleanQueryInfo()
    }
    
    @objc
    private func closeButtonDidTapped (_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
//MARK: - Layouts
extension AnnouncementListFilterViewController {
    private func activateConstraintsBottomView() {
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        let leading = bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let bottom = bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        let trailing = bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let height = bottomView.heightAnchor.constraint(equalToConstant: 50)
        
        NSLayoutConstraint.activate([
            leading, bottom, trailing, height
        ])
    }
    
    private func activateConstraintsScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        let top = scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        let leading = scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let trailing = scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let bottom = scrollView.bottomAnchor.constraint(equalTo: bottomView.topAnchor)
        
        NSLayoutConstraint.activate([
            top, leading, trailing, bottom
        ])
    }
    
    private func activateConstraontsContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        let top = contentView.topAnchor.constraint(equalTo: scrollView.topAnchor)
        let leading = contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor)
        let trailing = contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
        let bottom = contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        let width = contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        NSLayoutConstraint.activate([
            top, leading, trailing, bottom, width
        ])
    }
    
}
// MARK: - Keyboard handle
extension AnnouncementListFilterViewController {
    func addKeyboardObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(handleContentUnderKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(handleContentUnderKeyboard(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func removeObservers() {
        let notification = NotificationCenter.default
        notification.removeObserver(self)
    }
    
    @objc func handleContentUnderKeyboard(notification: Notification) {
        if let userInfo = notification.userInfo,
           let keyboardEndFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as?
            NSValue {
            let convertedKeyboardEndFrame =
                view.convert(keyboardEndFrame.cgRectValue
                             , from: view.window)
            if notification.name ==
                UIResponder.keyboardWillHideNotification {
                scrollView.contentInset.bottom = .zero
            } else {
                var insets = scrollView.contentInset
                insets.bottom = convertedKeyboardEndFrame.height + 150
                scrollView.contentInset = insets
            }
        }
    }
}
