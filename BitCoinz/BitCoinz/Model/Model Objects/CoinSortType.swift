//
//  CoinSortType.swift
//  BitCoinz
//
//  Created by Olivier Butler on 20/05/2022.
//

import Foundation

enum CoinSortType: String, CaseIterable {
    case price = "Price"
    case marketCap = "Market Cap"
    case change = "Change"
    case listedAt = "Listed At"
}
