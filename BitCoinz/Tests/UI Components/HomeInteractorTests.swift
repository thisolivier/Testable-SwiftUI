//
//  HomeInteractorTests.swift
//  HomeInteractorTests
//
//  Created by Olvier Butler on 21.05.2022.
//

import XCTest
import Combine
@testable import BitCoinz

class HomeInteractorTests: XCTestCase {

    // The network layer is mocked per case so we don't handle it at the class level
    // TODO: Move network layer to class level
    private var coinStore: MockCoinStore!
    private var viewModel: HomeViewModel!

    override func setUp() {
        coinStore = MockCoinStore()
        viewModel = HomeViewModel(dynamicProperties: .empty, staticProperties: .init(title: "Title", fallbackImageName: ""))
    }

    func test_loadData_success_correctDataAcessible() {
        // Expectation: We will have 12 coins
        let expectedCoinCount = 12
        
        // Action
        let sut = makeSutForSuccess(coinCount: 12)
        sut.loadData()
        
        // Assertion: The view model has been updated with the correct coins
        XCTAssertEqual(expectedCoinCount, viewModel.dynamicProperties.coins.count)
    }

    func test_loadData_success_writtenToStore() throws {
        // Expectation: We will have 12 coins
        let expectedCoinCount = 12


        // Action: We start the interactor
        let sut = makeSutForSuccess(coinCount: 12)
        sut.loadData()

        // THEN: HomeViewModel's coins should be same as returned data
        let savedCoins = try XCTUnwrap(coinStore.coinsSaved)
        XCTAssertEqual(expectedCoinCount, savedCoins.count)
        XCTAssertEqual(viewModel.dynamicProperties.coins, savedCoins)
    }
    
    func test_loadData_showErrorWhenNetworkFails() {
        // Expectation: We show the following error
        let expectedResponse = NetworkError.apiError("Fake Error") as Error

        // Setup
        let mockCoinProvider: CoinProvidable = TestCoinProvider(response: .failure(expectedResponse))
        let sut = HomeInteractor(
            coinProvider: mockCoinProvider,
            coinPriceStore: coinStore,
            homeViewModel: viewModel
        )
        sut.loadData()
        
        // Assertion
        XCTAssertEqual(expectedResponse.localizedDescription, viewModel.dynamicProperties.errorMessage)
    }

    // MARK: - Helper Functions

    func makeSutForSuccess(coinCount: Int) -> HomeInteractor {
        let coinsResponse = (0..<coinCount).map { _ in Coin.mockCoin }
        let mockCoinProvider: CoinProvidable = TestCoinProvider(response: .success(coinsResponse))
        return HomeInteractor(
            coinProvider: mockCoinProvider,
            coinPriceStore: coinStore,
            homeViewModel: viewModel
        )
    }
}

// MARK: - A mock coin store
private class MockCoinStore: CoinPriceStorable {

    var coinsSaved: [Coin]?

    func save(data: [Coin]) {
        coinsSaved = data
    }

    func retrieve(for uuid: String, completion: @escaping ([PersistentCoinData]) -> Void) {
        return // Not used in this test suite
    }
}

// MARK: - Network layer that returns data
private class TestCoinProvider: CoinProvidable {
    let response: Result<[Coin], Error>
    
    init(response: Result<[Coin], Error>){
        self.response = response
    }
    
    func getCoins() -> AnyPublisher<[Coin], Error> {
        switch response {
        case .success(let response):
            return Result<[Coin], Error>
                .Publisher(.success(response))
                .eraseToAnyPublisher()
        case .failure(let error):
            return Result<[Coin], Error>
                .Publisher(.failure(error))
                .eraseToAnyPublisher()
        }
    }
}
