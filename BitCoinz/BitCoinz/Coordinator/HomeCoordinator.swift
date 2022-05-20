//
//  Coordinator.swift
//  Coinz_App_iOS
//
//  Created by Burhan Aras on 26.12.2021.
//

import SwiftUI

protocol HomeCoordinatorable: Coordinatorable {
    func showDetails(for: Coin) -> AnyView
}

final class HomeCoordinator: HomeCoordinatorable {

    private let coinStore: CoinStorable = CoinStore()

    func start() -> AnyView {
        return HomeView(
            viewModel: HomeViewModel(
                networkLayer: NetworkLayer(),
                coinStore: coinStore
            ),
            coordinator: self
        ).asAnyView()
    }

    func showDetails(for coin: Coin) -> AnyView {
        return DetailView(
            viewModel: DetailViewModel(
                coin: coin,
                coinStore: coinStore
            )
        ).asAnyView()
    }
}
