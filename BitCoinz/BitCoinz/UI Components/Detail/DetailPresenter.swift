//
//  DetailPresenter.swift
//  BitCoinz
//
//  Created by Olivier Butler on 21/05/2022.
//

import Foundation

class DetailPresenter {
    private let coinId: String
    private let viewModel: DetailViewModel
    private let coinStore: CoinPriceStorable

    init(coin: Coin, coinStore: CoinPriceStorable, viewModel: DetailViewModel){
        self.coinStore = coinStore
        self.coinId = coin.id
        self.viewModel = viewModel
        viewModel.staticProperties = .init(symbol: coin.symbol, name: coin.name, price: coin.price)
        loadData()
    }

    func loadData() {
        coinStore.retrieve(for: coinId) { data in
            self.viewModel.dynamicProperties.historyItems = data
        }
    }
}
