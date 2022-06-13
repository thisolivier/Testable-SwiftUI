//
//  GraphAxisCalculable.swift
//  BitCoinz
//
//  Created by Olivier Butler on 07/06/2022.
//

import Foundation

protocol GraphAxisCalculable {
    associatedtype AxisUnits: Comparable

    func axis(targetNumberIntervals: Int) -> AxisConfiguration<AxisUnits>
}
