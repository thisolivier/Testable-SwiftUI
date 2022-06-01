//
//  ContinuousNumberAxisCalculatorTests.swift
//  BitCoinz
//
//  Created by Olivier Butler on 01/06/2022.
//

import XCTest
@testable import BitCoinz

class ContinuousNumberAxisCalculatorTests: XCTestCase {
    func test_outputRange() {
        let unit = Unit.dollar
        let range = 20.0...998.0
        let sut = ContinuousNumberAxisCalculator(range: range, units: unit)
        let result300 = sut.axisFitting(in: 300) // Added one too many, extended range properly
        let result200 = sut.axisFitting(in: 200) // Two data points, proper range
        let result100 = sut.axisFitting(in: 100)
        for item in [result100, result200, result300] {
            XCTAssertGreaterThan(item.points.count, 1)
        }
        print("Done")
    }
}
