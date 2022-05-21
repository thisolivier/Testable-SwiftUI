//
//  DetailViewModel.swift
//  Coinz_App_iOS
//
//  Created by Burhan Aras on 26.12.2021.
//

import Foundation

class DetailViewModel: ObservableObject {
    private var coinId: String
    @Published var historyItems: [String] = []
    var symbol: String
    var name: String
    var price: String

    private let coinStore: CoinPriceStorable
    
    init(coin: Coin, coinStore: CoinPriceStorable){
        self.coinStore = coinStore
        self.coinId = coin.id
        symbol = coin.symbol
        name = coin.name
        price = coin.price
        loadData()
    }
    
    func loadData() {
        coinStore.retrieve(for: coinId) {[unowned self] data in
            self.historyItems = data
        }
    }
}
