//
//  DetailViewModelTests.swift
//  Unit Tests
//
//  Created by Olivier Butler on 19/05/2022.
//

import XCTest
import Combine
@testable import Coinz_App_iOS

class DetailViewModelTests: XCTestCase {
    private var sut: DetailViewModel!
    private var mockCoin: Coin!
    private var mockCoinStore: MockCoinStore!

    override func setUp() {
        mockCoin = Coin(
            id: UUID().uuidString,
            symbol: UUID().uuidString,
            name: UUID().uuidString,
            iconUrl: URL(string: "google.com")!,
            price: UUID().uuidString,
            marketCap: UUID().uuidString,
            change: UUID().uuidString,
            listedAt: Double.random(in: 0..<300)
        )
        mockCoinStore = MockCoinStore()
        sut = DetailViewModel(
            coin: mockCoin,
            coinStore: mockCoinStore
        )
    }

    func test_init_storesCorrectDetailsFromCoin() {
        XCTAssertEqual(sut.price, mockCoin.price)
        XCTAssertEqual(sut.symbol, mockCoin.symbol)
        XCTAssertEqual(sut.name, mockCoin.name)
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
        XCTAssertEqual(sut.historyItems, testData)
    }
}

private class MockCoinStore: CoinStorable {
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
