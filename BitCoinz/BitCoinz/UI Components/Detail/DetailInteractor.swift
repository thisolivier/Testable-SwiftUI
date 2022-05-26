//
//  DetailInteractor.swift
//  BitCoinz
//
//  Created by Olivier Butler on 21/05/2022.
//

import Foundation

protocol DetailPresentable {
    func loadData() -> ()
}

class DetailInteractor {
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
}

extension DetailInteractor: DetailPresentable {
    func loadData() {
        coinStore.retrieve(for: coinId) { [weak self] data in
            self?.viewModel.dynamicProperties.historyItems = data
        }
    }
}
