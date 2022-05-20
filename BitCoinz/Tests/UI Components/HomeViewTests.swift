//
//  HomeViewTests.swift
//  Unit Tests
//
//  Created by Olivier Butler on 20/05/2022.
//

import XCTest
import Combine
import SwiftUI
@testable import BitCoinz

class HomeViewTests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        Environment.rootCoodinator = MockCoordinator()
        app = XCUIApplication()
    }

    override class func tearDown() {
        Environment.reset()
    }

    func test_showsTitleAndPrice() {
        app.launch()
    }
}

private class MockCoordinator: HomeCoordinatorable {

    var mockViewModel = HomeViewModel(
        networkLayer: MockNetworkLayer(),
        coinStore: MockCoinStore()
    )

    var mockDetailsView: some View { Text("Details View") }

    func start() -> AnyView {
        return HomeView(
            viewModel: mockViewModel,
            coordinator: self
        ).asAnyView()
    }

    func showDetails(for: Coin) -> AnyView {
        return mockDetailsView.asAnyView()
    }
}

// TODO: Should have a repository layer ontop of these two objects
private class MockNetworkLayer: INetworkLayer {
    static var mockCoinsResponse = CoinsResponse(
        status: "",
        data: CoinsDataDTO(
            coins: (0..<Int.random(in: 1..<100)).map { _ in CoinDTO(
                uuid: UUID().uuidString,
                symbol: UUID().uuidString,
                name: UUID().uuidString,
                iconUrl: "google.com",
                price: UUID().uuidString,
                marketCap: UUID().uuidString,
                change: UUID().uuidString,
                listedAt: Double.random(in: 0..<200)
            )}
        )
    )

    func getCoins() -> AnyPublisher<CoinsResponse, RequestError> {
        return Result<CoinsResponse, RequestError>
            .Publisher(.success(Self.mockCoinsResponse))
            .eraseToAnyPublisher()
    }
}

// We don't actually want to use this in this test. Need mockable VM
private class MockCoinStore: CoinStorable {
    func save(data: [Coin]) { return }
    func retrieve(for uuid: String, completion: @escaping ([String]) -> Void) { return }
}
