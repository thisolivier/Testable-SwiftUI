//
//  DateInterval+Extensions.swift
//  BitCoinz
//
//  Created by Olivier Butler on 07/06/2022.
//

import Foundation

extension DateInterval {
    var dateRange: ClosedRange<Date> {
        return self.start ... self.end
    }

    static func from(closedRange: ClosedRange<Date>) -> DateInterval {
        return DateInterval(start: closedRange.lowerBound, end: closedRange.upperBound)
    }
}
