//
//  DatabaseLayer.swift
//  Coinz_App_iOS
//
//  Created by Burhan Aras on 26.12.2021.
//

import Foundation

protocol CoinPriceStorable {
    /** Will store to disk the date queried, and coin price when queried, for all coins passed in. Appends to existing data. **/
    func save(data: [Coin])
    /** Retreives from disk an array of all previously saved date & price info for a given coin id  **/
    func retrieve(for uuid: String, completion: @escaping ([String]) -> Void)
}

// Could be made generic: Any object with a UUID (identifiable) and a .description/string value could be stored & retreived.
class CoinPriceStore: CoinPriceStorable {
    func save(data: [Coin]) {
        DispatchQueue.main.async {
            let defaults = UserDefaults.standard
            let date = Date()
            for coin in data {
                var savedArray = defaults.object(forKey: coin.id) as? [String] ?? [String]()
                savedArray.append(("\(date) - \( coin.price)"))
                defaults.set(savedArray, forKey: coin.id)
            }
        }
    }
    
    func retrieve(for id: String, completion: @escaping ([String]) -> Void) {
        let defaults = UserDefaults.standard
        let savedArray = defaults.object(forKey: id) as? [String] ?? [String]()
        completion(savedArray)
    }
}
