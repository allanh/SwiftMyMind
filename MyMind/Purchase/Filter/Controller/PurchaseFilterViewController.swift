//
//  PurchaseFilterViewController.swift
//  MyMind
//
//  Created by Barry Chen on 2021/5/6.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
import PromiseKit
import RxSwift
import RxRelay

protocol PurchaseFilterViewControllerDelegate: AnyObject {
    func purchaseFilterViewController(_ purchaseFilterViewController: PurchaseFilterViewController, didConfirm queryInfo: PurchaseListQueryInfo)
    func purchaseFilterViewController(_ purchaseFilterViewController: PurchaseFilterViewController, didUpdate autoCompleteSource: [PurchaseQueryType: [AutoCompleteInfo]])
}

protocol PurchaseFilterChildViewController: UIViewController {
    func reloadData()
}

enum PurchaseQueryType: String, CustomStringConvertible, CaseIterable {
    case purchaseNumber, vendorID, purchaseStatus, applicant, productNumbers, expectPutInStoragePeriod, createdPeriod
    var description: String {
        switch self {
        case .purchaseNumber: return "採購單編號"
        case .vendorID: return "供應商"
        case .purchaseStatus: return "採購單狀態"
        case .applicant: return "申請人"
        case .productNumbers: return "商品編號"
        case .expectPutInStoragePeriod: return "預計入庫日"
        case .createdPeriod: return "填單日期"
        }
    }
}
struct PickPurchaseStatusViewModel {
    let title: String = "採購單狀態"
    let allStatus: [PurchaseStatus] = PurchaseStatus.allCases
    let pickedStatus: BehaviorRelay<PurchaseStatus?> = .init(value: nil)

    func cleanPickedStatus() {
        pickedStatus.accept(nil)
    }
}

struct PickDatesViewModel {
    let title: String
    let startDate: BehaviorRelay<Date?> = .init(value: nil)
    let endDate: BehaviorRelay<Date?> = .init(value: nil)

    func cleanPickedDates() {
        startDate.accept(nil)
        endDate.accept(nil)
    }
}

class PurchaseFilterViewModel {
    let title: String = "篩選條件"
    var queryInfo: PurchaseListQueryInfo
    let didUpdateQueryInfo: (PurchaseListQueryInfo) -> Void
    let service: AutoCompleteAPIService

    lazy var purchaseNumberViewModel: AutoCompleteSearchViewModel = {
        makeViewModelForPurchaseNumber()
    }()

    lazy var vendorViewModel: AutoCompleteSearchViewModel = {
        makeViewModelForVendor()
    }()

    lazy var applicantViewModel: AutoCompleteSearchViewModel = {
        makeViewModelForApplicant()
    }()

    lazy var productNumberViewModel: AutoCompleteSearchViewModel = {
        makeViewModelForProductNumber()
    }()

    let purchaseStatusViewModel: PickPurchaseStatusViewModel = PickPurchaseStatusViewModel()

    let expectPutInStoragePeriodViewModel: PickDatesViewModel = PickDatesViewModel(title: "預計入庫日")

    let creatPeriodViewModel: PickDatesViewModel = PickDatesViewModel(title: "填單日期")

    let bag: DisposeBag = DisposeBag()

    init(service: AutoCompleteAPIService,
         queryInfo: PurchaseListQueryInfo,
         didUpdateQueryInfo: @escaping (PurchaseListQueryInfo) -> Void) {
        self.service = service
        self.queryInfo = queryInfo
        self.queryInfo.pageNumber = 1
        self.didUpdateQueryInfo = didUpdateQueryInfo

        updateWithCurrentQuery()
        subscribeChildViewModels()
    }

    private func subscribeChildViewModels() {
        purchaseNumberViewModel.pickedItemViewModels
            .subscribe(onNext: { [unowned self] items in
                self.queryInfo.purchaseNumbers = items.map({ item in
                    AutoCompleteInfo(id: nil, number: item.identifier, name: nil)
                })
            })
            .disposed(by: bag)

        vendorViewModel.pickedItemViewModels
            .subscribe(onNext: { [unowned self] items in
                self.queryInfo.vendorIDs = items.map({ item in
                    AutoCompleteInfo(id: item.identifier, number: nil, name: item.representTitle)
                })
            })
            .disposed(by: bag)

        applicantViewModel.pickedItemViewModels
            .subscribe(onNext: { [unowned self] items in
                self.queryInfo.applicants = items.map({ item in
                    AutoCompleteInfo(id: item.identifier, number: nil, name: item.representTitle)
                })
            })
            .disposed(by: bag)

        productNumberViewModel.pickedItemViewModels
            .subscribe(onNext: { [unowned self] items in
                self.queryInfo.productNumbers = items.map({ item in
                    AutoCompleteInfo(id: nil, number: item.identifier, name: item.identifier)
                })
            })
            .disposed(by: bag)

        purchaseStatusViewModel.pickedStatus
            .subscribe(onNext: { [unowned self] status in
                self.queryInfo.status = status
            })
            .disposed(by: bag)

        expectPutInStoragePeriodViewModel.startDate
            .subscribe(onNext: { [unowned self] date in
                self.queryInfo.expectStorageStartDate = date
            })
            .disposed(by: bag)

        expectPutInStoragePeriodViewModel.endDate
            .subscribe(onNext: { [unowned self] date in
                self.queryInfo.expectStorageEndDate = date
            })
            .disposed(by: bag)

        creatPeriodViewModel.startDate
            .subscribe(onNext: { [unowned self] date in
                self.queryInfo.createDateStart = date
            })
            .disposed(by: bag)

        creatPeriodViewModel.endDate
            .subscribe(onNext: { [unowned self] date in
                self.queryInfo.createDateEnd = date
            })
            .disposed(by: bag)
    }

    private func updateWithCurrentQuery() {
        purchaseStatusViewModel.pickedStatus.accept(queryInfo.status)
        updateCurrentQueryForPurchaseNumber()
        updateCurrentQueryForVendor()
        updateCurrentQueryForApplicant()
        updateCurrentQueryForProductNumber()
        updateCurrentQueryForStoragePeriod()
        updateCurrentQueryForCreatPeriod()
    }

    private func updateCurrentQueryForPurchaseNumber() {
        let items = queryInfo.purchaseNumbers.map { AutoCompleteItemViewModel(representTitle: $0.number ?? "", identifier: $0.number ?? "")}
        purchaseNumberViewModel.pickedItemViewModels.accept(items)
    }

    private func updateCurrentQueryForVendor() {
        let items = queryInfo.vendorIDs.map { AutoCompleteItemViewModel(representTitle: $0.name ?? "", identifier: $0.id ?? "")}
        vendorViewModel.pickedItemViewModels.accept(items)
    }

    private func updateCurrentQueryForApplicant() {
        let items = queryInfo.applicants.map { AutoCompleteItemViewModel(representTitle: $0.name ?? "", identifier: $0.id ?? "")}
        applicantViewModel.pickedItemViewModels.accept(items)
    }

    private func updateCurrentQueryForProductNumber() {
        let items = queryInfo.productNumbers.map { AutoCompleteItemViewModel(representTitle: $0.number ?? "", identifier: $0.number ?? "")}
        productNumberViewModel.pickedItemViewModels.accept(items)
    }

    private func updateCurrentQueryForStoragePeriod() {
        expectPutInStoragePeriodViewModel.startDate.accept(queryInfo.expectStorageStartDate)
        expectPutInStoragePeriodViewModel.endDate.accept(queryInfo.expectStorageEndDate)
    }

    private func updateCurrentQueryForCreatPeriod() {
        creatPeriodViewModel.startDate.accept(queryInfo.createDateStart)
        creatPeriodViewModel.endDate.accept(queryInfo.createDateEnd)
    }

    func cleanQueryInfo() {
        queryInfo = .defaultQuery()

        purchaseNumberViewModel.cleanPickedItemViewModel()
        vendorViewModel.cleanPickedItemViewModel()
        productNumberViewModel.cleanPickedItemViewModel()
        applicantViewModel.cleanPickedItemViewModel()
        purchaseStatusViewModel.cleanPickedStatus()
        expectPutInStoragePeriodViewModel.cleanPickedDates()
        creatPeriodViewModel.cleanPickedDates()
    }

    func makeViewModelForPurchaseNumber() -> AutoCompleteSearchViewModel {
        let adapter = RxPurchaseNumberAutoCompleteItemViewModelAdapter(service: service)
        let viewModel = AutoCompleteSearchViewModel(title: "採購單編號", service: adapter)
        return viewModel
    }

    func makeViewModelForVendor() -> AutoCompleteSearchViewModel {
        let adapter = RxVendorAutoCompleteItemViewModelAdapter(service: service)
        let viewModel = AutoCompleteSearchViewModel.init(title: "供應商", service: adapter)
        return viewModel
    }

    func makeViewModelForApplicant() -> AutoCompleteSearchViewModel {
        let adapter = RxApplicantAutoCompleteItemViewModelAdapter(service: service)
        let viewModel = AutoCompleteSearchViewModel.init(title: "申請人", service: adapter)
        return viewModel
    }

    func makeViewModelForProductNumber() -> AutoCompleteSearchViewModel {
        let adapter = RxProductNumberAutoCompleteItemViewModelAdapter(service: service)
        let viewModel = AutoCompleteSearchViewModel.init(title: "SKU編號", service: adapter)
        return viewModel
    }
}

class PurchaseFilterViewController: NiblessViewController {
    private let scrollView: UIScrollView = UIScrollView {
        $0.backgroundColor = .white
        $0.showsHorizontalScrollIndicator = false
    }

    private let contentView: UIView = UIView {
        $0.backgroundColor = .white
    }

    private let bottomView: FilterSideMenuBottomView = FilterSideMenuBottomView {
        $0.backgroundColor = .white
    }

    weak var delegate: PurchaseFilterViewControllerDelegate?

    let viewModel: PurchaseFilterViewModel

    init(viewModel: PurchaseFilterViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.title
        view.backgroundColor = .white
        addTapToResignKeyboardGesture()
        constructViewHierarchy()
        activateConstraints()
        configNavigtaionBar()

        addChildViewControllers()
        configViewForChildViewControllers()
        configBottomView()
    }

    private func configViewForChildViewControllers() {
        var lastChildView: UIView?
        for index in 0..<children.count {
            guard let childView = children[index].view else { return }
            childView.translatesAutoresizingMaskIntoConstraints = false
            childView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
            childView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
            if index == 0 {
                childView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
            }
            if let lastView = lastChildView {
                childView.topAnchor.constraint(equalTo: lastView.bottomAnchor).isActive = true
            }
            if index == children.count - 1 {
               childView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
            }
            lastChildView = childView
        }
    }

    private func addChildViewControllers() {
        let allCases = PurchaseQueryType.allCases
        allCases.forEach {
            switch $0 {
            case .purchaseNumber:
                addAutoSearchViewCotrollerAsChild(with: viewModel.purchaseNumberViewModel)
            case .vendorID:
                addAutoSearchViewCotrollerAsChild(with: viewModel.vendorViewModel)
            case .applicant:
                addAutoSearchViewCotrollerAsChild(with: viewModel.applicantViewModel)
            case .productNumbers:
                addAutoSearchViewCotrollerAsChild(with: viewModel.productNumberViewModel)
            case .purchaseStatus:
                let viewController = PurchaseStatusSelectionViewController(viewModel: viewModel.purchaseStatusViewModel)
                addViewControllerAsChild(viewController)
            case .createdPeriod:
                let viewController = PurchaseQueryDateSelectionViewController(viewModel: viewModel.expectPutInStoragePeriodViewModel)
                addViewControllerAsChild(viewController)
            case .expectPutInStoragePeriod:
                let viewController = PurchaseQueryDateSelectionViewController(viewModel: viewModel.creatPeriodViewModel)
                addViewControllerAsChild(viewController)
            }
        }
    }

    private func addViewControllerAsChild(_ viewController: UIViewController) {
        contentView.addSubview(viewController.view)
        addChild(viewController)
        viewController.didMove(toParent: self)
    }

    private func addAutoSearchViewCotrollerAsChild(with viewModel: AutoCompleteSearchViewModel) {
        let viewController = AutoCompleteSearchViewController(viewModel: viewModel)
        addViewControllerAsChild(viewController)
    }

    private func constructViewHierarchy() {
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
        view.addSubview(bottomView)
    }

    private func activateConstraints() {
        activateConstraintsBottomView()
        activateConstraintsScrollView()
        activateConstraintsContentView()
    }

    private func configNavigtaionBar() {
        navigationItem.title = "篩選條件"
        let closeButton = UIButton()
        closeButton.setImage(UIImage(named: "close"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonDidTapped(_:)), for: .touchUpInside)
        let barItem = UIBarButtonItem(customView: closeButton)
        navigationItem.setRightBarButton(barItem, animated: true)
    }

    private func configBottomView() {
        bottomView.confirmButton.addTarget(self, action: #selector(confirmButtonDidTapped(_:)), for: .touchUpInside)
        bottomView.cancelButton.addTarget(self, action: #selector(cleanButtonDidTapped(_:)), for: .touchUpInside)
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
    private func closeButtonDidTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
// MARK: - Layouts
extension PurchaseFilterViewController {
    private func activateConstraintsBottomView() {
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        let leading = bottomView.leadingAnchor
            .constraint(equalTo: view.leadingAnchor)
        let bottom = bottomView.bottomAnchor
            .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        let trailing = bottomView.trailingAnchor
            .constraint(equalTo: view.trailingAnchor)
        let height = bottomView.heightAnchor
            .constraint(equalToConstant: 50)

        NSLayoutConstraint.activate([
            leading, bottom, trailing, height
        ])
    }

    private func activateConstraintsScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        let top = scrollView.topAnchor
            .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        let leading = scrollView.leadingAnchor
            .constraint(equalTo: view.leadingAnchor)
        let trailing = scrollView.trailingAnchor
            .constraint(equalTo: view.trailingAnchor)
        let bottom = scrollView.bottomAnchor
            .constraint(equalTo: bottomView.topAnchor)

        NSLayoutConstraint.activate([
            top, leading, trailing, bottom
        ])
    }

    private func activateConstraintsContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        let top = contentView.topAnchor
            .constraint(equalTo: scrollView.topAnchor)
        let leading = contentView.leadingAnchor
            .constraint(equalTo: scrollView.leadingAnchor)
        let bottom = contentView.bottomAnchor
            .constraint(equalTo: scrollView.bottomAnchor)
        let trailing = contentView.trailingAnchor
            .constraint(equalTo: scrollView.trailingAnchor)
        let width = contentView.widthAnchor
            .constraint(equalTo: scrollView.widthAnchor)

        NSLayoutConstraint.activate([
            top, leading, bottom, trailing, width
        ])
    }
}
