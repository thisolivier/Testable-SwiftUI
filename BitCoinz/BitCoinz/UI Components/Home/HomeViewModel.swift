//
//  HomeViewModel.swift
//  Coinz_App_iOS
//
//  Created by Burhan Aras on 26.12.2021.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {

    private var cancellables: Set<AnyCancellable> = []
    private var networkLayer: INetworkLayer
    private var coinStore: CoinStorable
    private var allCoins = [Coin]()
    private var sortType: SortType
    let title: String = "₿ Coinz App"
    @Published var coins = [Coin]()
    @Published var sortText: String
    @Published var errorMessage: String = ""
    
    init(
        networkLayer: INetworkLayer,
        coinStore: CoinStorable
    ){
        self.networkLayer = networkLayer
        self.coinStore = coinStore
        sortType = .price
        sortText = SortType.price.rawValue
    }
    
    //MARK: - Helper functions
    func loadData() {
        networkLayer.getCoins()
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
                coinStore.save(data: allCoins)
            }
            .store(in: &cancellables)
    }
    
    func sortData(with sortType: SortType) {
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

enum SortType: String, CaseIterable {
    case price = "Price"
    case marketCap = "Market Cap"
    case change = "Change"
    case listedAt = "Listed At"
}

extension String {
    func toDouble() -> Double {
        return Double(self) ?? 0.00 // TODO: Decode to a double in the Coin model object
    }
}
