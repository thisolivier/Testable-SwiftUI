//
//  HomePresenterTests.swift
//  HomePresenterTests
//
//  Created by Olvier Butler on 21.05.2022.
//

import XCTest
import Combine
@testable import BitCoinz

class HomePresenterTests: XCTestCase {

    // The network layer is mocked per case so we don't handle it at the class level
    // TODO: Move network layer to class level
    private var coinStore: MockCoinStore!
    private var viewModel: HomeViewModel!

    override func setUp() {
        coinStore = MockCoinStore()
        viewModel = HomeViewModel(dynamicProperties: .empty, staticProperties: .init(title: "Title"))
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


        // Action: We start the presenter
        let sut = makeSutForSuccess(coinCount: 12)
        sut.loadData()

        // THEN: HomeViewModel's coins should be same as returned data
        let savedCoins = try XCTUnwrap(coinStore.coinsSaved)
        XCTAssertEqual(expectedCoinCount, savedCoins.count)
        XCTAssertEqual(viewModel.dynamicProperties.coins, savedCoins)
    }
    
    func test_loadData_showErrorWhenNetworkFails() {
        // Expectation: We show the following error
        let expectedResponse = NetworkError.apiError

        // Setup
        let mockCoinProvider: CoinProvidable = TestCoinProvider(response: .failure(expectedResponse))
        let sut = HomePresenter(
            coinProvider: mockCoinProvider,
            coinPriceStore: coinStore,
            homeViewModel: viewModel
        )
        sut.loadData()
        
        // Assertion
        XCTAssertEqual(expectedResponse.localizedDescription, viewModel.dynamicProperties.errorMessage)
    }

    // MARK: - Helper Functions

    func makeSutForSuccess(coinCount: Int) -> HomePresenter {
        let coinsResponse = CoinsResponse(
            status: "success",
            data: CoinsDataDTO(coins: dummyData(count: coinCount))
        )
        let mockCoinProvider: CoinProvidable = TestCoinProvider(response: .success(coinsResponse))
        return HomePresenter(
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

    func retrieve(for uuid: String, completion: @escaping ([String]) -> Void) {
        return // Not used in this test suite
    }
}

// MARK: - Network layer that returns data
private class TestCoinProvider: CoinProvidable {
    let response: Result<CoinsResponse, NetworkError>
    
    init(response: Result<CoinsResponse, NetworkError>){
        self.response = response
    }
    
    func getCoins() -> AnyPublisher<CoinsResponse, NetworkError> {
        switch response {
        case .success(let response):
            return Result<CoinsResponse, NetworkError>
                .Publisher(.success(response))
                .eraseToAnyPublisher()
        case .failure(let error):
            return Result<CoinsResponse, NetworkError>
                .Publisher(.failure(error))
                .eraseToAnyPublisher()
        }
    }
}

// MARK: - Dummy data
func dummyData(count: Int) -> [CoinDTO] {
    var data = [CoinDTO]()
    for index in 0..<count {
        let coin = CoinDTO(uuid: "\(index)", symbol: "symbol", name: "name", iconUrl: "url", price: "12.5", marketCap: "marketCap", change: "change", listedAt: 1.0)
        data.append(coin)
    }
    return data
}
