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

    private var app: XCUIApplication!

    override func setUp() {
        app = XCUIApplication()
    }

    func test_headerContent() {
        // Expectation
        let expectedAppTitle = "₿ All Coinz"
        let expectedMenuLabel = "Price"

        // Action
        app.launch()

        // Assertion
        XCTAssertEqual(app.navigationBars.firstMatch.identifier, expectedAppTitle)
        XCTAssertEqual(app.buttons["coinFilterMenu"].label, expectedMenuLabel)
    }

    func test_tapMenu() {
        // Expectation
        let expectedFilterCount = 4

        // Action
        app.launch()
        app.buttons["coinFilterMenu"].firstMatch.tap()

        // Assertion
        XCTAssertEqual(app.buttons.matching(identifier: "coinFilterOption").count, expectedFilterCount)
    }

    func test_coinsListed() {
        // we need to mock the server for this
    }

    func test_tapCoin() {
        // need to mock the server for this
    }
}
