//
//  DatabaseLayer.swift
//  Coinz_App_iOS
//
//  Created by Burhan Aras on 26.12.2021.
//

import Foundation

struct PersistentCoinData: Codable {
    let date: Date
    let coin: Coin
}

protocol CoinPriceStorable {
    /** Will store to disk the date queried, and coin price when queried, for all coins passed in. Appends to existing data. **/
    func save(data: [Coin])
    /** Retreives from disk an array of all previously saved date & price info for a given coin id  **/
    func retrieve(for uuid: String, completion: @escaping ([PersistentCoinData]) -> Void)
}

// Could be made generic: Any object with a UUID (identifiable) and a .description/string value could be stored & retreived.
class CoinPriceStore: CoinPriceStorable {

    private let defaults = UserDefaults.standard

    private func persistentData(for coinId: String) -> [PersistentCoinData] {
        guard
            let savedData = defaults.object(forKey: coinId) as? Data,
            let savedArray = try? PropertyListDecoder().decode(
                [PersistentCoinData].self,
                from: savedData
            )
        else { return [] }
        return savedArray
    }

    func save(data: [Coin]) {
        DispatchQueue.main.async {
            for coin in data {
                var savedArray = self.persistentData(for: coin.id)
                savedArray.append(PersistentCoinData(date: Date(), coin: coin))
                let encoded = try! PropertyListEncoder().encode(savedArray)
                self.defaults.set(encoded, forKey: coin.id)
            }
        }
    }
    
    func retrieve(for id: String, completion: @escaping ([PersistentCoinData]) -> Void) {
        completion(persistentData(for: id))
    }
}
