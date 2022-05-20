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

    func test_coinsListed() {
        // we need to mock the server for this
    }

    func test_tapMenu() {
        let expectedFilterCount = 4
        app.launch()
        app.buttons["coinFiler"].tap()
        let filterButtons = app.buttons["coinFilter"]
    }

    func test_tapCoin() {

    }
}
