//
//  HomeFactory.swift
//  BitCoinz
//
//  Created by Olivier Butler on 21/05/2022.
//

import SwiftUI

enum HomeViewFactory {
    static func makeHomeView(
        flowDelegate: HomeFlowDelegate?,
        coinProvider: CoinProvidable = CoinProvider(),
        coinPriceStore: CoinPriceStorable = CoinPriceStore()
    ) -> HomeView {
        let viewModel = HomeViewModel(
            dynamicProperties: .empty,
            staticProperties: .init(title: "")
        )
        let interactor = HomeInteractor(
            coinProvider: coinProvider,
            coinPriceStore: coinPriceStore,
            homeViewModel: viewModel
        )
        return HomeView(
            interactor: interactor,
            viewModel: viewModel,
            flowDelegate: flowDelegate
        )
    }
}
