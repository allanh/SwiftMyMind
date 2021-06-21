//
//  PickProductMaterialsViewController.swift
//  MyMind
//
//  Created by Chen Yi-Wei on 2021/5/19.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
import RxSwift

class PickProductMaterialsViewController: NiblessViewController {

    var rootView: PickProductMaterialsRootView {
        view as! PickProductMaterialsRootView
    }

    let viewModel: PickProductMaterialsViewModel
    let bag: DisposeBag = DisposeBag()

    // MARK: - View Life Cycle
    override func loadView() {
        super.loadView()
        view = PickProductMaterialsRootView(viewModel: viewModel)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        subscribeViewModel()
        viewModel.refreshFetchProductMaterials(with: viewModel.currentQueryInfo)
    }
    // MARK: - Methods
    init(viewModel: PickProductMaterialsViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    private func configTableView() {
        rootView.tableView.delegate = self
        rootView.tableView.dataSource = self
        rootView.tableView.registerCell(PickProductMaterialTableViewCell.self)
    }

    private func subscribeViewModel() {
        title = viewModel.title
        
        viewModel.currentProductMaterials
            .subscribe(on: MainScheduler.instance)
            .skip(1)
            .subscribe(onNext: { [unowned self] _ in
                self.rootView.tableView.reloadData()
            })
            .disposed(by: bag)

        viewModel.view
            .subscribe(onNext: { [unowned self] view in
                self.handleNavigation(with: view)
            })
            .disposed(by: bag)

        viewModel.isNetworkProcessing
            .bind(to: rx.isActivityIndicatorAnimating)
            .disposed(by: bag)
    }

    private func handleNavigation(with view: PickMaterialView) {
        switch view {
        case .filter:
            guard let userSession = MyMindUserSessionRepository.shared.readUserssion() else {
                #warning("Handle not sign in")
                return
            }
            let service = MyMindAutoCompleteAPIService(userSession: userSession)
            let viewModel = ProductMaterialsFilterViewModel(
                service: service,
                queryInfo: viewModel.currentQueryInfo) { [unowned self] info in
                self.viewModel.currentQueryInfo = info
                self.viewModel.refreshFetchProductMaterials(with: info)
            }

            let viewController = ProductMaterialsFilterViewController(viewModel: viewModel)
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true, completion: nil)
        case .suggestion:
            var imageDictionary: [String: URL?] = [:]
            viewModel.pickedMaterials.forEach { productMaterail in
                if let urlString = productMaterail.imageInfoList.first?.url, let url = URL(string: urlString) {
                    imageDictionary[productMaterail.number] = url
                }
            }
            let productMaterialListLoader = MyMindPurchaseAPIService(userSession: .testUserSession)
            let adapter = PurchaseServiceToSuggestionProductMaterialViewModelAdapter(loader: productMaterialListLoader, imageDictionary: imageDictionary)
            let pickedOrderedIDs = viewModel.pickedMaterials.map { $0.id }
            let purchaseSuggestionViewModel = PurchaseSuggestionViewModel(pickedProductIDList: pickedOrderedIDs , loader: adapter)
            let viewController = PurchaseSuggestionViewController(viewModel: purchaseSuggestionViewModel)
            show(viewController, sender: nil)
            break
        }
    }

    @objc
    private func didTapCheckBoxButton(_ sender: UIButton) {
        guard
            let pointInTableView = sender.superview?.convert(sender.frame.origin, to: rootView.tableView),
            let indexPath = rootView.tableView.indexPathForRow(at: pointInTableView)
        else {
            return
        }
        rootView.tableView.deselectRow(at: indexPath, animated: true)
        viewModel.selectMaterial(at: indexPath.row)
        sender.isSelected.toggle()
    }
}
// MARK: - Scroll view delegate
extension PickProductMaterialsViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.isDragging else { return }
        let scrolledHeight = scrollView.contentOffset.y + scrollView.frame.height
        let scrolledPercentage = scrolledHeight / scrollView.contentSize.height
        let threshold: CGFloat = 0.7
        if scrolledPercentage > threshold {
            viewModel.fetchMoreProductMaterials(with: &viewModel.currentQueryInfo)
        }
    }
}
// MARK: - Table view data source
extension PickProductMaterialsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.currentProductMaterials.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeReusableCell(PickProductMaterialTableViewCell.self, for: indexPath) as? PickProductMaterialTableViewCell else {
            print("----Wrong cell identifier or not register cell yet---")
            return UITableViewCell()
        }
        let material = viewModel.currentProductMaterials.value[indexPath.row]
        cell.config(with: material)
        let isSelected = viewModel.pickedMaterialIDs.contains(material.id)
        cell.checkBoxButton.isSelected = isSelected
        cell.checkBoxButton.addTarget(self, action: #selector(didTapCheckBoxButton(_:)), for: .touchUpInside)
        return cell
    }
}
// MARK: - Table view delegate
extension PickProductMaterialsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.selectMaterial(at: indexPath.row)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
