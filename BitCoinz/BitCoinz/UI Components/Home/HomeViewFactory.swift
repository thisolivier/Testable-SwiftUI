//
//  HomeFactory.swift
//  BitCoinz
//
//  Created by Olivier Butler on 21/05/2022.
//

import SwiftUI

enum HomeViewFactory {
    static func makeHomeView(
        flowDelegate: HomeFlowDelegate,
        coinProvider: CoinProvidable = CoinProvider(),
        coinPriceStore: CoinPriceStorable = CoinPriceStore()
    ) -> AnyView {
        let viewModel = HomeViewModel(
            dynamicProperties: .empty,
            staticProperties: .init(title: "")
        )
        let presenter = HomePresenter(
            coinProvider: coinProvider,
            coinPriceStore: coinPriceStore,
            homeViewModel: viewModel
        )
        presenter.start()
        return HomeView(
            presenter: presenter,
            viewModel: viewModel,
            flowDelegate: flowDelegate
        ).asAnyView()
    }
}
