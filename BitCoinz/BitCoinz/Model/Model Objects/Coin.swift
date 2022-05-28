//
//  Coin.swift
//  Coinz_App_iOS
//
//  Created by Burhan Aras on 26.12.2021.
//

import Foundation

struct Coin: Identifiable, Equatable {
    let id: String
    let symbol: String
    let name: String
    let iconUrl: URL?
    let price: String
    let marketCap: String
    let change: String
    let listedAt: Double
}
