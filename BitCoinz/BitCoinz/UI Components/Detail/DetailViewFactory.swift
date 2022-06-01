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
    ) -> DetailView {
        let viewModel = DetailViewModel(
            dynamicProperties: .init(historyItems: [], graphData: []),
            staticProperties: .empty
        )
        let interactor = DetailInteractor(
            coin: coin,
            coinStore: coinStore,
            viewModel: viewModel
        )
        return DetailView(
            viewModel: viewModel,
            interactor: interactor
        )
    }
}
