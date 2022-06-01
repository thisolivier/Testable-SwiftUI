//
//  GraphAxisCalculator.swift
//  BitCoinz
//
//  Created by Olivier Butler on 01/06/2022.
//

import Foundation
import UIKit

struct ContinuousNumberAxisCalculator {
    let range: ClosedRange<Double>
    let units: Unit

    func axisFitting(in width: Double) -> AxisConfiguration {
        print("=======================")
        print("Debug for width \(width)")
        print("Range: \(range)")

        var outputPoints: [Double] = []

        let basicChunks = (range.upperBound - range.lowerBound)/Double(width.numberOfChunksForAxis)
        let power = log10(basicChunks).rounded()
        let chunkDivisor = pow(1, Int(power))
        let singleUnitChunk = (basicChunks/Double(chunkDivisor as NSNumber)).rounded()
        let finalChunk = singleUnitChunk * power

        print("Basic Chunk: \(basicChunks), Final Chunk: \(finalChunk)")
        print("Basic Chunk power: \(power)")
        print("Basic Chunk divisor: \(chunkDivisor)")
        print("Single unit chunk: \(singleUnitChunk)")

        let start = floor(range.lowerBound/finalChunk) * finalChunk
        print("= Starting axis loop at \(start) =")
        var head = start
        repeat {
            if range.contains(head) {
                outputPoints.append(head)
                print("= Appending new axis point \(head) =")
            }
            head += finalChunk
        } while range.contains(head)
        print("= Loop Ended at \(head) =")
        print("= End of loop values \(outputPoints) =")

        var lowerBound = range.lowerBound
        var upperBound = range.upperBound
        if outputPoints.count < 2 {
            print("Bulking...")
            if outputPoints.first ?? .nan != start {
                outputPoints.insert(start, at: 0)
                lowerBound = start
                print("Added start")
            }
            if outputPoints.last ?? .nan != head {
                outputPoints.append(head)
                upperBound = head
                print("Added head")
            }
        }
        return AxisConfiguration(
            points: outputPoints.map {
                AxisPoint(position: $0, value: units.string(from: $0))
            },
            axisRange: lowerBound...upperBound
        )
    }
}

private extension Double {
    var numberOfChunksForAxis: Int {
        if self > 300 {
            return 6
        } else if self > 250 {
            return 5
        } else if self > 199 {
            return 3
        } else {
            return 2
        }
    }
}

struct Unit {
    enum Position {
        case prefix
        case suffix
    }

    static let dollar = Unit(unit: "$", position: .prefix)

    let unit: String
    let position: Position

    func string(from value: Double) -> String {
        switch position {
        case .prefix:
            return "\(unit)\(value)"
        case .suffix:
            return "\(value)\(unit)"
        }
    }
}


struct AxisConfiguration {
    var points: [AxisPoint]
    var axisRange: ClosedRange<Double>
}

struct AxisPoint {
    var position: Double
    var value: String
}
