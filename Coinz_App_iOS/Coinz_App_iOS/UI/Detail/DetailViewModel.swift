//
//  DetailViewModel.swift
//  Coinz_App_iOS
//
//  Created by Burhan Aras on 26.12.2021.
//

import Foundation

class DetailViewModel: ObservableObject {
    @Published var data: [String] = []
    private var coin: Coin
    private let coinStore: CoinStorable
    
    init(coin: Coin, coinStore: CoinStorable){
        self.coin = coin
        self.coinStore = coinStore
        loadData()
    }
    
    func loadData() {
        coinStore.retrieve(for: coin.id) {[unowned self] data in
            self.data = data
            print(data.count)
        }
    }
}
