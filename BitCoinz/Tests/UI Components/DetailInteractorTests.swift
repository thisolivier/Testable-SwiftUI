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
            dynamicProperties: .init(historyItems: []),
            staticProperties: .empty
        )
        sut = DetailInteractor(
            coin: mockCoin,
            coinStore: mockCoinStore,
            viewModel: mockViewModel
        )
    }

    func test_init_storesCorrectDetailsFromCoin() {
        XCTAssertEqual(mockViewModel.staticProperties.price, mockCoin.price)
        XCTAssertEqual(mockViewModel.staticProperties.symbol, mockCoin.symbol)
        XCTAssertEqual(mockViewModel.staticProperties.name, mockCoin.name)
    }

    func test_init_requestsCorrectData() {
        XCTAssertEqual(mockCoinStore.receivedUUID, mockCoin.id)
    }

    func test_loadData_savesLoadedData() {
        // TODO: make more combine-ee (subscribe to the changes, assert things when we get change)
        // Prepare data
        let testData: [String] = (0..<10).map { _ in UUID().uuidString }
        mockCoinStore.dataToReturn = testData

        // Execute data load
        sut.loadData()

        // Check we got our test data back
        XCTAssertEqual(mockViewModel.dynamicProperties.historyItems, testData)
    }
}

private class MockCoinStore: CoinPriceStorable {
    var dataToReturn: [String] = []
    var receivedUUID: String?

    func save(data: [Coin]) {
        return // Not used in this test case
    }

    func retrieve(for uuid: String, completion: @escaping ([String]) -> Void) {
        receivedUUID = uuid
        completion(dataToReturn)
    }
}
