//
//  DetailInteractorTests.swift
//  Unit Tests
//
//  Created by Olivier Butler on 19/05/2022.
//

import XCTest
import Combine
@testable import BitCoinz

class DetailInteractorTests: XCTestCase {
    private var sut: DetailInteractor!
    private var mockCoin: Coin!
    private var mockCoinStore: MockCoinStore!
    private var mockViewModel: DetailViewModel!

    override func setUp() {
        mockCoin = Coin.mockCoin
        mockCoinStore = MockCoinStore()
        mockViewModel = DetailViewModel(
            dynamicProperties: .init(historyItems: [], graphData: []),
            staticProperties: .empty
        )
        sut = DetailInteractor(
            coin: mockCoin,
            coinStore: mockCoinStore,
            viewModel: mockViewModel
        )
    }

    func test_init_storesCorrectDetailsFromCoin() {
        XCTAssertEqual(mockViewModel.staticProperties.price, mockCoin.formattedPrice)
        XCTAssertEqual(mockViewModel.staticProperties.symbol, mockCoin.symbol)
        XCTAssertEqual(mockViewModel.staticProperties.name, mockCoin.name)
    }

    func test_init_requestsCorrectData() {
        XCTAssertEqual(mockCoinStore.receivedUUID, mockCoin.id)
    }

    func test_loadData_savesLoadedData() {
        // TODO: make more combine-ee (subscribe to the changes, assert things when we get change)
        // Prepare data
        let testData: [PersistentCoinData] = (0..<10).map { _ in PersistentCoinData(
            date: Date(),
            coin: Coin.mockCoin
        ) }
        mockCoinStore.dataToReturn = testData

        // Execute data load
        sut.loadData()

        // Check we got our test data back
        let testCoinPrices = testData.map { $0.coin.formattedPrice }
        let outputCoinProces = mockViewModel.dynamicProperties.historyItems.map { $0.0 }
        XCTAssertEqual(outputCoinProces, testCoinPrices)
    }
}

private class MockCoinStore: CoinPriceStorable {

    var dataToReturn: [PersistentCoinData] = []
    var receivedUUID: String?

    func save(data: [Coin]) {
        return // Not used in this test case
    }

    func retrieve(for uuid: String, completion: @escaping ([PersistentCoinData]) -> Void) {
        receivedUUID = uuid
        completion(dataToReturn)
    }
}
