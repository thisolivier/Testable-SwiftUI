//
//  CoinTests.swift
//  Unit Tests
//
//  Created by Olivier Butler on 19/05/2022.
//

import XCTest
import Combine
@testable import BitCoinz

class CoinTests: XCTestCase {
    func test_fromDTO_correctProperties(){
        // GIVEN: that we have a CoinDTO
        let dto = CoinDTO(
            uuid: "uuid",
            symbol: "symbol",
            name: "name",
            iconUrl: "url",
            price: "12.50",
            marketCap: "marketCap",
            change: "change",
            listedAt: 1.0
        )

        // WHEN: DTO is mapped to Coin
        let sut = Coin.fromDTO(dto: dto)

        // THEN: fields should be correct
        XCTAssertEqual(sut.id, dto.uuid)
        XCTAssertEqual(sut.symbol, dto.symbol)
        XCTAssertEqual(sut.name, dto.name)
        XCTAssertEqual(sut.formattedPrice, "$\(dto.price)")
    }
}
