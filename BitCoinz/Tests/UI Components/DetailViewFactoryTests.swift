//
//  DetailViewFactoryTests.swift
//  Unit Tests
//
//  Created by Olivier Butler on 23/05/2022.
//

import XCTest
@testable import BitCoinz

class DetailViewFactoryTests: XCTestCase {

    func test_makeDetailView_generatesDependencies() {
        let testCoin = Coin.randomCoin
        let view = DetailViewFactory.makeDetailView(coin: testCoin)
        XCTAssertTrue(view.interactor is DetailInteractor)
        XCTAssertNotNil(view.viewModel)
    }

    func test_makeDetailView_integrationTest_coinDataPassedToViewModel() {
        let testCoin = Coin.randomCoin
        let view = DetailViewFactory.makeDetailView(coin: testCoin)
        XCTAssertEqual(testCoin.name, view.viewModel.staticProperties.name)
        XCTAssertEqual(testCoin.price, view.viewModel.staticProperties.price)
        XCTAssertEqual(testCoin.symbol, view.viewModel.staticProperties.symbol)
    }
}
