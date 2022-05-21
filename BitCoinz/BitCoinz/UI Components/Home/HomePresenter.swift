//
//  HomeViewModel.swift
//  Coinz_App_iOS
//
//  Created by Burhan Aras on 26.12.2021.
//

import Foundation
import Combine

// View has strong reference to the Presenter
// Presenter has strong refrence to the ViewModelHolder
// View has a weak reference to the ViewModelHolder
// Communication flows one way, from View to Presenter to ViewModelHolder

struct HomeStaticViewModel {
    let title: String
}

struct HomeDynamicViewModel {
    var coins: [Coin]
    var sortText: String
    var errorMessage: String
}

class HomePresenter: ObservableObject {

    typealias HomeViewModel = ViewModelHolder<HomeStaticViewModel, HomeDynamicViewModel>
    private static let defaultSortType = CoinSortType.price

    private let coinProvider: CoinProvidable
    private let coinPriceStore: CoinPriceStorable
    private let homeViewModel: HomeViewModel

    private var cancellables: Set<AnyCancellable> = []
    private var allCoins = [Coin]()
    private var sortType: CoinSortType
    
    init(
        coinProvider: CoinProvidable,
        coinPriceStore: CoinPriceStorable
    ){
        self.coinProvider = coinProvider
        self.coinPriceStore = coinPriceStore
        sortType = Self.defaultSortType
        self.homeViewModel = HomeViewModel(
            dynamicProperties: HomeDynamicViewModel(
                coins: [],
                sortText: Self.defaultSortType.rawValue,
                errorMessage: ""
            ),
            staticProperties: HomeStaticViewModel(title: "₿ Coinz App"))
    }

    func start() -> HomeViewModel {
        loadData()
        return homeViewModel
    }

    private func loadData() {
        coinProvider.getCoins()
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    print(error.localizedDescription)
                    self.homeViewModel.dynamicProperties.errorMessage = error.localizedDescription
                }
            } receiveValue: {[unowned self] coinsResponse in
                print(coinsResponse.data.coins)
                self.allCoins = coinsResponse.data.coins.map { Coin.fromDTO(dto: $0) }
                sortData(with: sortType)
                coinPriceStore.save(data: allCoins)
            }
            .store(in: &cancellables)
    }
    
    func sortData(with sortType: CoinSortType) {
        self.sortType = sortType
        switch sortType {
        case .price:
            self.homeViewModel.dynamicProperties.sortText = sortType.rawValue
            self.homeViewModel.dynamicProperties.coins = allCoins.sorted(by: { $0.price.toDouble() > $1.price.toDouble() })
        case .marketCap:
            self.homeViewModel.dynamicProperties.sortText = sortType.rawValue
            self.homeViewModel.dynamicProperties.coins = allCoins.sorted(by: { $0.marketCap.toDouble() > $1.marketCap.toDouble() })
        case .change:
            self.homeViewModel.dynamicProperties.sortText = sortType.rawValue
            self.homeViewModel.dynamicProperties.coins = allCoins.sorted(by: { $0.change.toDouble() > $1.change.toDouble() })
        case .listedAt:
            self.homeViewModel.dynamicProperties.sortText = sortType.rawValue
            self.homeViewModel.dynamicProperties.coins = allCoins.sorted(by: { $0.listedAt > $1.listedAt })
        }
    }
}

extension String {
    func toDouble() -> Double {
        return Double(self) ?? 0.00 // TODO: Decode to a double in the Coin model object
    }
}
