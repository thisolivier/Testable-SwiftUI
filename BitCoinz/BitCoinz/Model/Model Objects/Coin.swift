//
//  Coin.swift
//  Coinz_App_iOS
//
//  Created by Burhan Aras on 26.12.2021.
//

import Foundation

struct Coin: Codable, Identifiable, Equatable {
    let id: String
    let symbol: String
    let name: String
    let iconUrl: URL?
    let price: Double
    let marketCap: String
    let change: String
    let listedAt: Double

    var formattedPrice: String {
        "$\(String(format:"%.2f", price))"
    }
}
