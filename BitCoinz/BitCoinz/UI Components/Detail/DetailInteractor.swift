//
//  DetailInteractor.swift
//  BitCoinz
//
//  Created by Olivier Butler on 21/05/2022.
//

import Foundation

protocol DetailInteractable {
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
        viewModel.staticProperties = .init(
            symbol: coin.symbol,
            name: coin.name,
            price: coin.formattedPrice
        )
        loadData()
    }
}

extension DetailInteractor: DetailInteractable {
    func loadData() {
        coinStore.retrieve(for: coinId) { [weak self] history in
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy HH:mm"
            self?.viewModel.dynamicProperties.historyItems = history.map { historyItem in
                let dateString = formatter.string(from: historyItem.date)
                let valueString = historyItem.coin.formattedPrice
                return (dateString, valueString)
            }
        }
    }
}
