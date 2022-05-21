//
//  HomeViewModel.swift
//  Coinz_App_iOS
//
//  Created by Burhan Aras on 26.12.2021.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {

    let title: String = "₿ Coinz App"
    private let coinProvider: CoinProvidable
    private let coinPriceStore: CoinPriceStorable

    private var cancellables: Set<AnyCancellable> = []
    private var allCoins = [Coin]()
    private var sortType: CoinSortType
    @Published var coins = [Coin]()
    @Published var sortText: String
    @Published var errorMessage: String = ""
    
    init(
        coinProvider: CoinProvidable,
        coinPriceStore: CoinPriceStorable
    ){
        self.coinProvider = coinProvider
        self.coinPriceStore = coinPriceStore
        sortType = .price
        sortText = CoinSortType.price.rawValue
    }
    
    //MARK: - Helper functions
    func loadData() {
        coinProvider.getCoins()
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    print(error.localizedDescription)
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: {[unowned self] coinsResponse in
                print(coinsResponse.data.coins)
                self.allCoins = coinsResponse.data.coins.map{ Coin.fromDTO(dto: $0)}
                sortData(with: sortType)
                coinPriceStore.save(data: allCoins)
            }
            .store(in: &cancellables)
    }
    
    func sortData(with sortType: CoinSortType) {
        self.sortType = sortType
        switch sortType {
        case .price:
            self.sortText = sortType.rawValue
            self.coins = allCoins.sorted(by: { $0.price.toDouble() > $1.price.toDouble() })
        case .marketCap:
            self.sortText = sortType.rawValue
            self.coins = allCoins.sorted(by: { $0.marketCap.toDouble() > $1.marketCap.toDouble() })
        case .change:
            self.sortText = sortType.rawValue
            self.coins = allCoins.sorted(by: { $0.change.toDouble() > $1.change.toDouble() })
        case .listedAt:
            self.sortText = sortType.rawValue
            self.coins = allCoins.sorted(by: { $0.listedAt > $1.listedAt })
        }
    }
}

extension String {
    func toDouble() -> Double {
        return Double(self) ?? 0.00 // TODO: Decode to a double in the Coin model object
    }
}
