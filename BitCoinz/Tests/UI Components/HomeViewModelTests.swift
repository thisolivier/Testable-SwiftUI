//
//  Unit_Tests.swift
//  Unit Tests
//
//  Created by Burhan Aras on 26.12.2021.
//

import XCTest
import Combine
@testable import BitCoinz

class HomeViewModelTests: XCTestCase {

    // The network layer is mocked per case so we don't handle it at the class level
    // TODO: Move network layer to class level
    private var coinStore: MockCoinStore!

    override func setUp() {
        coinStore = MockCoinStore()
    }

    func test_loadData_success_correctDataAcessible() {
        // GIVEN: that we have test network layer that returns some coins
        let sut = makeSutForSuccess(coinCount: 12)
        
        // WHEN: HomeViewModel's loadData() is called
        sut.loadData()
        
        // THEN: HomeViewModel's coins should be same as returned data
        XCTAssertEqual(12, sut.coins.count)
    }

    func test_loadData_success_writtenToStore() throws {
        // GIVEN: that we have test network layer that returns some coins
        let sut = makeSutForSuccess(coinCount: 12)

        // WHEN: HomeViewModel's loadData() is called
        sut.loadData()

        // THEN: HomeViewModel's coins should be same as returned data
        let savedCoins = try XCTUnwrap(coinStore.coinsSaved)
        XCTAssertEqual(sut.coins, savedCoins)
    }
    
    func test_loadData_showErrorWhenNetworkFails() {
        // GIVEN: that we have test network layer that returns some coins
        let mockCoinProvider: CoinProvidable = TestCoinProvider(response: .failure(NetworkError.apiError))
        let sut = HomeViewModel(
            coinProvider: mockCoinProvider,
            coinPriceStore: coinStore
        )
        
        // WHEN: HomeViewModel's loadData() is called
        sut.loadData()
        
        // THEN: HomeViewModel's coins should be same as returned data
        XCTAssertEqual(NetworkError.apiError.localizedDescription, sut.errorMessage)
    }

    // MARK: - Helper Functions

    func makeSutForSuccess(coinCount: Int) -> HomeViewModel {
        let coinsResponse = CoinsResponse(
            status: "success",
            data: CoinsDataDTO(coins: dummyData(count: coinCount))
        )
        let mockCoinProvider: CoinProvidable = TestCoinProvider(response: .success(coinsResponse))
        return HomeViewModel(
            coinProvider: mockCoinProvider,
            coinPriceStore: coinStore
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
