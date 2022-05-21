//
//  Coordinator.swift
//  Coinz_App_iOS
//
//  Created by Burhan Aras on 26.12.2021.
//

import SwiftUI

final class HomeCoordinator: Coordinatorable {

    private let coinPriceStore: CoinPriceStorable = CoinPriceStore()

    func start() -> AnyView {
        return HomeViewFactory.makeHomeView(
            flowDelegate: self,
            coinPriceStore: coinPriceStore
        )
    }
}

extension HomeCoordinator: HomeFlowDelegate {
    func showDetails(for coin: Coin) -> AnyView {
        return DetailViewFactory.makeDetailView(
            coin: coin,
            coinStore: coinPriceStore
        )
    }
}
