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

    func test_topBarContent() {
        // Expectation
        let expectedAppTitle = "₿ Coinz App"
        let expectedMenuLabel = "Price"

        // Action
        app.launch()

        // Assertion
        XCTAssertEqual(app.staticTexts["appTitle"].label, expectedAppTitle)
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
