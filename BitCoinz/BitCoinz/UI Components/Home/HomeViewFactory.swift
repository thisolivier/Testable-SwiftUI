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
        return HomeView(
            viewModel: HomeViewModel(
                coinProvider: coinProvider,
                coinPriceStore: coinPriceStore
            ),
            flowDelegate: flowDelegate
        ).asAnyView()
    }
}
