//
//  Date+Extensions.swift
//  BitCoinz
//
//  Created by Olivier Butler on 07/06/2022.
//

import Foundation

extension Date {

    // By nbasham on GitHub: https://gist.github.com/nbasham/c219d8c8c773d2c146c526dfccb4353b
    static func randomBetween(start: Date, end: Date) -> Date {
        var date1 = start
        var date2 = end
        if date2 < date1 {
            let temp = date1
            date1 = date2
            date2 = temp
        }
        let span = TimeInterval.random(in: date1.timeIntervalSinceNow...date2.timeIntervalSinceNow)
        return Date(timeIntervalSinceNow: span)
    }
}
