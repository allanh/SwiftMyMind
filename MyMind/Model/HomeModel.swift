//
//  HomeModel.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/11.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import PromiseKit
struct HomeModel {
    var toDoList: ToDoList?
    var typeSaleReportList: SaleReportList?
    var dateSaleReportList: SaleReportList?
    var skuRankReportList: SKURankingReportList?
    var amountRankingReportList: SaleRankingReportList?
    var grossProfitRankingReportList: SaleRankingReportList?
//    init(toDoList: ToDoList? = nil, typeSaleReportList: SaleReportList? = nil, dateSaleReportList: SaleReportList? = nil, skuRankReportList: SKURankingReportList? = nil, storeRankingReportList: StoreRankingReportList? = nil, channelRankingReportList: ChannelRankingReportList? = nil) {
//        self.toDoList = toDoList
//        self.typeSaleReportList = typeSaleReportList
//        self.dateSaleReportList = dateSaleReportList
//        self.skuRankReportList = skuRankReportList
//        self.storeRankingReportList = storeRankingReportList
//        self.channelRankingReportList = channelRankingReportList
//    }
}

class HomeModelLoader {
    let loader: MyMindDashboardAPIService
    let authorization: Authorization
    init(loader: MyMindDashboardAPIService,
         authorization: Authorization) {
        self.loader = loader
        self.authorization = authorization
    }
    func loadData() -> Promise<HomeModel> {
        return Promise<HomeModel> { seal in
            loader.todo(with: authorization.navigations.description)
                .done { toDoList in
                    self.loader.orderSaleReport(start: Date(), end: Date(), type: .byType)
                        .done { typeSaleReportList in
                            self.loader.orderSaleReport(start: Date(), end: Date(), type: .byDate)
                                .done { dateSaleReportList in
                                    self.loader.skuRankingReport(start: Date(), end: Date(), isSet: false, order: "TOTAL_SALE_QUANTITY", count: 10)
                                        .done { skuRankingList in
                                            seal.fulfill(HomeModel(toDoList: toDoList, typeSaleReportList: typeSaleReportList, dateSaleReportList: dateSaleReportList, skuRankReportList: skuRankingList))
                                                 }
                                        .catch { _ in
                                            seal.fulfill(HomeModel(toDoList: toDoList, typeSaleReportList: typeSaleReportList, dateSaleReportList: dateSaleReportList))
                                        }
                                }
                                .catch { _ in
                                    seal.fulfill(HomeModel(toDoList: toDoList, typeSaleReportList: typeSaleReportList))
                                }
                        }
                        .catch { _ in
                            seal.fulfill(HomeModel(toDoList: toDoList))
                        }
                }
                .catch { error in
                    seal.reject(error)
                }
        }

//        loader.todo(with: authorization.navigations.description)
//            .done { toDoList in
//                self.loader.orderSaleReport(start: Date(), end: Date(), type: .byType)
//                    .done { typeSaleReport in
//                        Promise.value(HomeModel(toDoList: toDoList, typeSaleReportList: typeSaleReport, dateSaleReportList: nil, skuRankReportList: nil, channelRankingReportList: nil, vendorRankingReportList: nil))
//                    }
//            }
//            .catch { error in
//                print(error)
//            }
//        return Promise.value(HomeModel())
    }
}
//*排序欄位("TOTAL_SALE_QUANTITY:銷售總數","TOTAL_SALE_AMOUNT:銷售總額")
