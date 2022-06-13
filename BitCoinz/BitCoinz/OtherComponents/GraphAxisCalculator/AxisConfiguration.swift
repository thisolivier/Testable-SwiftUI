//
//  AxisConfiguration.swift
//  BitCoinz
//
//  Created by Olivier Butler on 07/06/2022.
//

import Foundation
import SwiftUI

struct AxisConfiguration<Bound> where Bound: Comparable {
    var points: [AxisPoint]
    var axisRange: ClosedRange<Bound>
}

extension AxisConfiguration {
    func largestWidthOfLabel(using font: UIFont) -> CGFloat {
        let widths = points.map { $0
            .value
            .widthOfString(usingFont: font)
        }
        print("WIDTHS")
        print(widths)
        print(widths.max())
        return (widths.max() ?? 0)
    }
}

struct AxisPoint: Hashable {
    /* Position indicates the proportional location along the axis and will always be from 0-1 from 0 to 1. */
    var position: Double
    var value: String
}
