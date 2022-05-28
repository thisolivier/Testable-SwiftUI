//
//  Coin+Extensions.swift
//  BitCoinz
//
//  Created by Olivier Butler on 28/05/2022.
//

import Foundation

extension Coin {
    static func fromDTO(dto: CoinDTO) -> Coin {
        let priceAsDouble = Double(dto.price) ?? 0.0
        let price = "$ \(String(format:"%.2f", priceAsDouble))"

        return Coin(
            id: dto.uuid,
            symbol: dto.symbol,
            name: dto.name,
            iconUrl: URL(string: dto.iconUrl),
            price: price,
            marketCap: dto.marketCap,
            change: dto.change,
            listedAt: dto.listedAt
        )
    }

    static var mockCoin: Coin {
        return Coin(
            id: UUID().uuidString,
            symbol: ["MPQ", "DDF", "LOL", "CVD", "WET", "OM", "TTFQ", "ZPPE"].randomElement()!,
            name: ["Dagger", "TetheringXL", "Flute", "Universal", "WinkCoin", "Muscy"].randomElement()!,
            iconUrl: nil,
            price: "$ \(String(format:"%.2f", Double.random(in: 100...10000)))",
            marketCap: String(format:"%.2f", Double.random(in: 100...10000)),
            change: String(format:"%.3f", Double.random(in: -10...10)),
            listedAt: Double.random(in: -10...10)
        )
    }
}
