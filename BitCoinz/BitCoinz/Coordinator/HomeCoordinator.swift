//
//  Coordinator.swift
//  Coinz_App_iOS
//
//  Created by Burhan Aras on 26.12.2021.
//

import SwiftUI

// Note, this pattern is imperfect. I don't know how we could get a coordinator to handle complex routing.
// E.g. If a scene has a window in it which displays different view depending on what we do outside the view.
// E.g. Or where interactions in the subview should cause updates to the parent (ok this is fine, we share dependencies), and pass information to the next subview we present (again fine, we share dependencies which hold the state).
// In these cases, we want more than to generate a new view from our coordinator, we want to change the subviews based on a routing action within one subview.
// How would we do this declaritively? The coordinator would have some defintion of the possible states the scene can have, and map them to the subviews which are being presented.
// What about transitions? In theory, this is view level information. A presenter should figure out what transition to display in VIP land. But let's say the coordinator is handling it, it knows what transition style to display. So we should store the view, and its transition information.
// For this to work, the coordinator would need to expose observable views. Not sure how possible this is.
// But, crutially, does this make sense? I'm suddently not so sure that coordination is very separate from

// Should coordinator's even be declarative?
// A user's journey through an app is, to me, a process. They go on a journey. The state of the app is procedurally changed.
// Coordinator's can function as procedural tools in a delarative system. Just mak the coordinators themselves views. If a coordinator has a view, like a navigation controller it would normally have, it knows how to present stuff. In fact, it works even better than UIKit.
// A coordinator is a view, with an Interactor. It could communicate via view model, but that seems like overkill. IN which case, it's just a ViewModel.

final class HomeCoordinator: Coordinatorable {

    private let coinPriceStore: CoinPriceStorable = CoinPriceStore()

    func start() -> AnyView {
        return HomeViewFactory.makeHomeView(
            flowDelegate: self,
            coinPriceStore: coinPriceStore
        ).asAnyView()
    }
}

extension HomeCoordinator: HomeFlowDelegate {
    func showDetails(for coin: Coin) -> AnyView {
        return DetailViewFactory.makeDetailView(
            coin: coin,
            coinStore: coinPriceStore
        ).asAnyView()
    }
}
