//
//  DetailViewModel.swift
//  Coinz_App_iOS
//
//  Created by Burhan Aras on 26.12.2021.
//

import Foundation

class DetailViewModel: ObservableObject {
    @Published var historyItems: [String] = []
    var symbol: String
    var name: String
    var price: String

    private let coinStore: CoinStorable
    
    init(coin: Coin, coinStore: CoinStorable){
        self.coinStore = coinStore
        symbol = coin.symbol
        name = coin.name
        price = coin.price
        loadData(for: coin.id)
    }
    
    func loadData(for coinId: String) {
        coinStore.retrieve(for: coinId) {[unowned self] data in
            self.historyItems = data
            print(data.count)
        }
    }
}
