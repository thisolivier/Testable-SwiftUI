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
        let range = 180000.0...34000000.0
        let sut = ContinuousNumberAxisCalculator(range: range, units: unit)
        let result10 = sut.axis(targetNumberIntervals: 10)
        let result5 = sut.axis(targetNumberIntervals: 5)
        let result3 = sut.axis(targetNumberIntervals: 3)
        let result2 = sut.axis(targetNumberIntervals: 2)
        for item in [result10, result5, result3, result2] {
            XCTAssertGreaterThan(item.points.count, 1)
        }
        print("Done")
    }
}
