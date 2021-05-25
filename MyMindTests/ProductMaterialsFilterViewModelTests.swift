//
//  ProductMaterialsFilterViewModelTests.swift
//  MyMindTests
//
//  Created by Barry Chen on 2021/5/25.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import XCTest
@testable import MyMind
import RxSwift
import RxRelay
import PromiseKit

struct AutoCompleteItemViewModel: Equatable {
    let representTitle: String
    let identifier: String
}

protocol RxAutoCompleteItemViewModelService {
    func getAutoCompleteItemViewModel(searchTerm: String) -> Single<[AutoCompleteItemViewModel]>
}

struct SearchMaterialNameViewModel {
    let title: String = "SKU名稱"
    let searchTerm: BehaviorRelay<String> = .init(value: "")
    let addedSearchTerms: BehaviorRelay<[String]> = .init(value: [])

    func addSearchTerm() {
        let searchTerm = searchTerm.value
        var tempAdded = addedSearchTerms.value
        tempAdded.append(searchTerm)
        addedSearchTerms.accept(tempAdded)
    }
}

struct AutoCompleteSearchViewModel {
    let title: String
    let searchTerm: BehaviorRelay<String> = .init(value: "")
    let service: RxAutoCompleteItemViewModelService
    let autoCompleteItemViewModels: BehaviorRelay<[AutoCompleteItemViewModel]> = .init(value: [])
    let pickedItemViewModels: BehaviorRelay<[AutoCompleteItemViewModel]> = .init(value: [])
    let bag: DisposeBag = DisposeBag()

    init(title: String,
         service: RxAutoCompleteItemViewModelService) {
        self.title = title
        self.service = service
        bindSearchTerm()
    }

    func bindSearchTerm() {
        searchTerm
            .flatMap(service.getAutoCompleteItemViewModel(searchTerm:))
            .bind(to: autoCompleteItemViewModels)
            .disposed(by: bag)
    }

    func pickItemViewModel(itemViewModel: AutoCompleteItemViewModel) {
        var tempPickedItemViewModels = pickedItemViewModels.value
        if let index = tempPickedItemViewModels.firstIndex(of: itemViewModel) {
            tempPickedItemViewModels.remove(at: index)
        } else {
            tempPickedItemViewModels.append(itemViewModel)
        }
        pickedItemViewModels.accept(tempPickedItemViewModels)
    }

    func cleanPickedItemViewModel() {
        pickedItemViewModels.accept([])
    }
}
struct RxVendorAutoCompleteItemViewModelAdapter: RxAutoCompleteItemViewModelService {
    let service: PurchaseAutoCompleteAPIService

    func getAutoCompleteItemViewModel(searchTerm: String) -> Single<[AutoCompleteItemViewModel]> {
        return Single<[AutoCompleteItemViewModel]>.create { single in
            service.vendorNameAutoComplete(searchTerm: searchTerm)
                .done { list in
                    let viewModels = list.item.map { AutoCompleteItemViewModel(representTitle: $0.name ?? "", identifier: $0.number ?? "")}
                    single(.success(viewModels))
                }.catch { error in
                    single(.failure(error))
                }
            return Disposables.create()
        }
    }
}

struct RxBrandNameAutoCompleteItemViewModelAdapter: RxAutoCompleteItemViewModelService {
    let service: PurchaseAutoCompleteAPIService

    func getAutoCompleteItemViewModel(searchTerm: String) -> Single<[AutoCompleteItemViewModel]> {
        return Single<[AutoCompleteItemViewModel]>.create { single in
            service.productMaterialBrandNameAutoComplete(searchTerm: searchTerm)
                .done { list in
                    let viewModels = list.item.map { AutoCompleteItemViewModel(representTitle: $0.name ?? "", identifier: $0.name ?? "")}
                    single(.success(viewModels))
                }.catch { error in
                    single(.failure(error))
                }
            return Disposables.create()
        }
    }
}

struct RxProductNumberAutoCompleteItemViewModelAdapter: RxAutoCompleteItemViewModelService {
    let service: PurchaseAutoCompleteAPIService

    func getAutoCompleteItemViewModel(searchTerm: String) -> Single<[AutoCompleteItemViewModel]> {
        return Single<[AutoCompleteItemViewModel]>.create { single in
            service.productNumberAutoComplete(searchTerm: searchTerm)
                .done { list in
                    let viewModels = list.item.map { AutoCompleteItemViewModel(representTitle: $0.number ?? "", identifier: $0.number ?? "")}
                    single(.success(viewModels))
                }.catch { error in
                    single(.failure(error))
                }
            return Disposables.create()
        }
    }
}

struct RxProductNumberSetAutoCompleteItemViewModelAdapter: RxAutoCompleteItemViewModelService {
    let service: PurchaseAutoCompleteAPIService

    func getAutoCompleteItemViewModel(searchTerm: String) -> Single<[AutoCompleteItemViewModel]> {
        return Single<[AutoCompleteItemViewModel]>.create { single in
            service.productNumberSetAutoComplete(searchTerm: searchTerm)
                .done { list in
                    let viewModels = list.item.map { AutoCompleteItemViewModel(representTitle: $0.number ?? "", identifier: $0.number ?? "")}
                    single(.success(viewModels))
                }.catch { error in
                    single(.failure(error))
                }
            return Disposables.create()
        }
    }
}

struct RxOriginalNumberAutoCompleteItemViewModelAdapter: RxAutoCompleteItemViewModelService {
    let service: PurchaseAutoCompleteAPIService

    func getAutoCompleteItemViewModel(searchTerm: String) -> Single<[AutoCompleteItemViewModel]> {
        return Single<[AutoCompleteItemViewModel]>.create { single in
            service.productMaterailOriginalNumberAutoComplete(searchTerm: searchTerm)
                .done { list in
                    let viewModels = list.item.map { AutoCompleteItemViewModel(representTitle: $0.number ?? "", identifier: $0.number ?? "")}
                    single(.success(viewModels))
                }.catch { error in
                    single(.failure(error))
                }
            return Disposables.create()
        }
    }
}
class ProductMaterialsFilterViewModel {
    let title: String = "篩選條件"
    var queryInfo: ProductMaterialQueryInfo = .defaultQuery()
    let didUpdateQueryInfo: (ProductMaterialQueryInfo) -> Void
    let service: PurchaseAutoCompleteAPIService

    lazy var vendorViewModel: AutoCompleteSearchViewModel = {
        makeViewModelForVendor()
    }()

    lazy var brandNameViewModel: AutoCompleteSearchViewModel = {
        makeViewModelForBrandName()
    }()

    lazy var productNumberViewModel: AutoCompleteSearchViewModel = {
        makeViewModelForProductNumber()
    }()

    lazy var productNumberSetViewModel: AutoCompleteSearchViewModel = {
        makeViewModelForProductNumberSet()
    }()

    lazy var originalNumberSetViewModel: AutoCompleteSearchViewModel = {
        makeViewModelForOriginalNumber()
    }()

    let searchMaterialNameViewModel: SearchMaterialNameViewModel = SearchMaterialNameViewModel()

    let bag: DisposeBag = DisposeBag()

    init(service: PurchaseAutoCompleteAPIService,
         didUpdateQueryInfo: @escaping (ProductMaterialQueryInfo) -> Void) {
        self.service = service
        self.didUpdateQueryInfo = didUpdateQueryInfo
        observerChildViewModels()
    }

    func observerChildViewModels() {
        vendorViewModel.pickedItemViewModels
            .subscribe(onNext: { [unowned self] viewModels in
                self.queryInfo.vendorIDs = viewModels.map { $0.identifier }
            })
            .disposed(by: bag)

        brandNameViewModel.pickedItemViewModels
            .subscribe(onNext: { [unowned self] viewModels in
                self.queryInfo.brandNames = viewModels.map { $0.identifier }
            })
            .disposed(by: bag)

        productNumberViewModel.pickedItemViewModels
            .subscribe(onNext: { [unowned self] viewModels in
                self.queryInfo.materialNumbers = viewModels.map { $0.identifier }
            })
            .disposed(by: bag)

        productNumberSetViewModel.pickedItemViewModels
            .subscribe(onNext: { [unowned self] viewModels in
                self.queryInfo.materailSetNumbers = viewModels.map { $0.identifier }
            })
            .disposed(by: bag)

        originalNumberSetViewModel.pickedItemViewModels
            .subscribe(onNext: { [unowned self] viewModels in
                self.queryInfo.originalMaterialNumbers = viewModels.map { $0.identifier }
            })
            .disposed(by: bag)

        searchMaterialNameViewModel.addedSearchTerms
            .subscribe(onNext: { [unowned self] names in
                self.queryInfo.materailNames = names
            })
            .disposed(by: bag)
    }


    func confirmSearch() {
        didUpdateQueryInfo(queryInfo)
    }

    func cleanToDefaultStatus() {
        vendorViewModel.pickedItemViewModels.accept([])
        brandNameViewModel.pickedItemViewModels.accept([])
        productNumberViewModel.pickedItemViewModels.accept([])
        productNumberSetViewModel.pickedItemViewModels.accept([])
        originalNumberSetViewModel.pickedItemViewModels.accept([])
    }

    func makeViewModelForVendor() -> AutoCompleteSearchViewModel {
        let adapter = RxVendorAutoCompleteItemViewModelAdapter(service: service)
        let viewModel = AutoCompleteSearchViewModel.init(title: "供應商", service: adapter)
        return viewModel
    }

    func makeViewModelForBrandName() -> AutoCompleteSearchViewModel {
        let adapter = RxBrandNameAutoCompleteItemViewModelAdapter(service: service)
        let viewModel = AutoCompleteSearchViewModel.init(title: "品牌名稱", service: adapter)
        return viewModel
    }

    func makeViewModelForProductNumber() -> AutoCompleteSearchViewModel {
        let adapter = RxProductNumberAutoCompleteItemViewModelAdapter(service: service)
        let viewModel = AutoCompleteSearchViewModel.init(title: "SKU編號", service: adapter)
        return viewModel
    }

    func makeViewModelForProductNumberSet() -> AutoCompleteSearchViewModel {
        let adapter = RxProductNumberSetAutoCompleteItemViewModelAdapter(service: service)
        let viewModel = AutoCompleteSearchViewModel.init(title: "組合編號", service: adapter)
        return viewModel
    }

    func makeViewModelForOriginalNumber() -> AutoCompleteSearchViewModel {
        let adapter = RxOriginalNumberAutoCompleteItemViewModelAdapter(service: service)
        let viewModel = AutoCompleteSearchViewModel.init(title: "原廠料號", service: adapter)
        return viewModel
    }
}

class ProductMaterialsFilterViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
