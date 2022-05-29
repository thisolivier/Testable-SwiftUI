//
//  HomeViewModel.swift
//  Coinz_App_iOS
//
//  Created by Burhan Aras on 26.12.2021.
//

import Foundation
import Combine

// View has strong reference to the Interactor
// Interactor has strong refrence to the ViewModelHolder
// View has a weak reference to the ViewModelHolder
// Communication flows one way, from View to Interactor to ViewModelHolder

protocol HomeInteractable {
    func sortData(with: CoinSortType)
    func loadData()
}

class HomeInteractor {

    private static let defaultSortType = CoinSortType.price

    private let coinProvider: CoinProvidable
    private let coinPriceStore: CoinPriceStorable
    private let homeViewModel: HomeViewModel

    private var cancellables: Set<AnyCancellable> = []
    private var allCoins = [Coin]()
    private var sortType: CoinSortType
    
    init(
        coinProvider: CoinProvidable,
        coinPriceStore: CoinPriceStorable,
        homeViewModel: HomeViewModel
    ){
        self.coinProvider = coinProvider
        self.coinPriceStore = coinPriceStore
        self.sortType = Self.defaultSortType
        self.homeViewModel = homeViewModel
        setInitialProperties()
    }

    private func setInitialProperties() {
        homeViewModel.staticProperties = .init(title: "₿ All Coinz", fallbackImageName: "UnknownCoin")
        homeViewModel.dynamicProperties.sortText = sortType.rawValue
    }
}

extension HomeInteractor: HomeInteractable {
    func loadData() {
        let mock = false
        if mock {
            self.allCoins = (0..<100).map { _ in Coin.mockCoin }
            sortData(with: sortType)
        } else {
            coinProvider.getCoins()
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case let .failure(error):
                        print(error.localizedDescription)
                        self.homeViewModel.dynamicProperties.errorMessage = error.localizedDescription
                    }
                } receiveValue: {[unowned self] coins in
                    self.allCoins = coins
                    sortData(with: sortType)
                    coinPriceStore.save(data: allCoins)
                }
                .store(in: &cancellables)
        }
    }

    func sortData(with sortType: CoinSortType) {
        self.sortType = sortType
        self.homeViewModel.dynamicProperties.sortText = sortType.rawValue
        switch sortType {
        case .price:
            self.homeViewModel.dynamicProperties.coins = allCoins.sorted(by: { $0.price > $1.price })
        case .marketCap:
            self.homeViewModel.dynamicProperties.coins = allCoins.sorted(by: { $0.marketCap.toDouble() > $1.marketCap.toDouble() })
        case .change:
            self.homeViewModel.dynamicProperties.coins = allCoins.sorted(by: { $0.change.toDouble() > $1.change.toDouble() })
        case .listedAt:
            self.homeViewModel.dynamicProperties.coins = allCoins.sorted(by: { $0.listedAt > $1.listedAt })
        }
    }
}

extension String {
    func toDouble() -> Double {
        return Double(self) ?? 0.00 // TODO: Decode to a double in the Coin model object
    }
}
