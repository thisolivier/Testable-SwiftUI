//
//  HomeViewFactory.swift
//  BitCoinz
//
//  Created by Olivier Butler on 21/05/2022.
//

import Foundation
import SwiftUI

enum DetailViewFactory {
    static func makeDetailView(
        coin: Coin,
        coinStore: CoinPriceStorable = CoinPriceStore()
    ) -> AnyView {
        let viewModel = DetailViewModel(
            dynamicProperties: .init(historyItems: []),
            staticProperties: .empty
        )
        _ = DetailPresenter(
            coin: coin,
            coinStore: coinStore,
            viewModel: viewModel
        )
        return DetailView(viewModel: viewModel).asAnyView()
    }
}
