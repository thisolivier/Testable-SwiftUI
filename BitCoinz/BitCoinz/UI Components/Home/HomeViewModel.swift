//
//  HomeViewModels.swift
//  BitCoinz
//
//  Created by Olivier Butler on 21/05/2022.
//

import Foundation

typealias HomeViewModel = ViewModelHolder<HomeStaticViewModel, HomeDynamicViewModel>

struct HomeStaticViewModel {
    let title: String
}

struct HomeDynamicViewModel {
    static let empty = Self.init(coins: [], sortText: "", errorMessage: "")

    var coins: [Coin]
    var sortText: String
    var errorMessage: String
}
