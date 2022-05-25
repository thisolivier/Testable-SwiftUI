//
//  Coin+Extensions.swift
//  Unit Tests
//
//  Created by Olivier Butler on 25/05/2022.
//

import Foundation
@testable import BitCoinz

extension Coin {
    static var randomCoin: Coin {
        Coin(
            id: UUID().uuidString,
            symbol: UUID().uuidString,
            name: UUID().uuidString,
            iconUrl: URL(string: "google.com")!,
            price: UUID().uuidString,
            marketCap: UUID().uuidString,
            change: UUID().uuidString,
            listedAt: Double.random(in: 0..<300)
        )
    }
}
