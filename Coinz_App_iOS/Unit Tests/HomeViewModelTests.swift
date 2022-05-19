//
//  Unit_Tests.swift
//  Unit Tests
//
//  Created by Burhan Aras on 26.12.2021.
//

import XCTest
import Combine
@testable import Coinz_App_iOS

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
        let networkLayer: INetworkLayer = TestFailingNetworkLayer(
            response: RequestError.apiError
        )
        let sut = HomeViewModel(
            networkLayer: networkLayer,
            coinStore: coinStore
        )
        
        // WHEN: HomeViewModel's loadData() is called
        sut.loadData()
        
        // THEN: HomeViewModel's coins should be same as returned data
        XCTAssertEqual(RequestError.apiError.localizedDescription, sut.errorMessage)
    }

    // MARK: - Helper Functions

    func makeSutForSuccess(coinCount: Int) -> HomeViewModel {
        let coinsResponse = CoinsResponse(
            status: "success",
            data: CoinsDataDTO(coins: dummyData(count: coinCount))
        )
        let networkLayer: INetworkLayer = TestNetworkLayer(response: coinsResponse)
        return HomeViewModel(
            networkLayer: networkLayer,
            coinStore: coinStore
        )
    }
}

// MARK: - A mock coin store
private class MockCoinStore: CoinStorable {
    var coinsSaved: [Coin]?

    func save(data: [Coin]) {
        coinsSaved = data
    }

    func retrieve(for uuid: String, completion: @escaping ([String]) -> Void) {
        return // Not used in this test suite
    }
}

// MARK: - Network layer that returns data
private class TestNetworkLayer: INetworkLayer {
    let response: CoinsResponse
    
    init(response: CoinsResponse){
        self.response = response
    }
    
    func getCoins() -> AnyPublisher<CoinsResponse, RequestError> {
        return Result<CoinsResponse, RequestError>
            .Publisher(.success(response))
            .eraseToAnyPublisher()
    }
}

// MARK: - Network layer that fails.
private class TestFailingNetworkLayer: INetworkLayer {
    let response: RequestError
    
    init(response: RequestError){
        self.response = response
    }
    
    func getCoins() -> AnyPublisher<CoinsResponse, RequestError> {
        return Result<CoinsResponse, RequestError>
            .Publisher(.failure(response))
            .eraseToAnyPublisher()
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
