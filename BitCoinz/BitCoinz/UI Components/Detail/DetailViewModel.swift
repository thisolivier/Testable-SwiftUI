//
//  DetailViewModel.swift
//  Coinz_App_iOS
//
//  Created by Olivier Butler on 26.12.2021.
//

import Foundation

typealias DetailViewModel = ViewModelHolder<DetailStaticProperties, DetailDynamicProperties>

struct DetailStaticProperties {
    static let empty = Self.init(symbol: "", name: "", price: "")

    let symbol: String
    let name: String
    let price: String
}

struct DetailDynamicProperties {
    var historyItems: [(String, String)]
}
