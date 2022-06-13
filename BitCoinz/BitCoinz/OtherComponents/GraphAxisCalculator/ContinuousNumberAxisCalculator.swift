//
//  ContinuousNumberAxisCalculator.swift
//  BitCoinz
//
//  Created by Olivier Butler on 07/06/2022.
//

import Foundation

// Feature description
// - Take a continuous range of values and calculate a discrete array of formatted values to display on the axis of a graph.
// - One can specify the number of intervals the range should be divided into. Note that this calsulator will force the intervals to be rounded whole numbers (easy to read on an axis), so the first and last label may not fit within the initial range.
    // - E.g. the range is 2...98 and we want 5 intervals will result in 20,40,60,80 since 0 and 100 fall outside the given range.
// - The calculator will force at least 2 labels to be returned (otherwise it is impossible to see scale from the axis). This may require the range to be extended, so the calculator will also return a range.


struct ContinuousNumberAxisCalculator: GraphAxisCalculable {
    let range: ClosedRange<Double>
    let units: Unit

    private struct AxisIntervalConfiguration {
        let intervalSize: Double
        let startingPosition: Double
    }

    func axis(targetNumberIntervals: Int) -> AxisConfiguration<Double> {
        print("=======================")
        print("Range: \(range)")
        let intervalConfiguration = calculateIntervalSize(targetNumberIntervals)
        print("= Starting axis loop at \(intervalConfiguration.startingPosition) =")
        var outputPoints: [Double] = []
        var head = intervalConfiguration.startingPosition
        repeat {
            if range.contains(head) {
                outputPoints.append(head)
                print("= Appending new axis point \(head) =")
            }
            head += intervalConfiguration.intervalSize
        } while range.contains(head)
        print("= Loop Ended at \(head) =")
        print("= End of loop values \(outputPoints) =")

        var lowerBound = range.lowerBound
        var upperBound = range.upperBound
        if outputPoints.count < 2 {
            // TODO: Improve this block.
            // Spec: Ensure axis has at least 2 data points
            // Should add 1 point (the closest to a data point) if only 1 item in array.
                // Prioritise the end point (head) if the two are equally close.
            // Should add two points (start end end) if there are no points in the array.

            // Steps:
            // 1. Add helper logic to see how far outside of a range a value is
            // 2. If we need to add 2, add start and end
            // 3. If we need to add 1, use helper logic, get smaller, add to array.
            print("Bulking...")
            if outputPoints.first ?? .nan != intervalConfiguration.startingPosition {
                outputPoints.insert(intervalConfiguration.startingPosition, at: 0)
                lowerBound = intervalConfiguration.startingPosition
                print("Added start")
            }
            if outputPoints.last ?? .nan != head {
                outputPoints.append(head)
                upperBound = head
                print("Added head")
            }
        }

        // Here we normalize the return positions to be between 0 and 1, and transform their value to a printable string. #PresentationLogic
        let varianceInValues = upperBound - lowerBound
        return AxisConfiguration(
            points: outputPoints.map { position in
                AxisPoint(
                    position: (position - lowerBound) / varianceInValues,
                    value: units.string(from: position)
                )
            },
            axisRange: lowerBound...upperBound
        )
    }

    /*
     Will use the calculator's range and a target number of intervals to return a rounded interval size suitable for display on an axis. A starting point is provided, which will be some number of intervals away from 0.
     Intervals are designed to have a low number of significant figures and cover the given range, this may result in the start and/or end value being outside the given range.
     */
    private func calculateIntervalSize(
        _ targetNumberIntervals: Int
    ) -> AxisIntervalConfiguration {
        let basicChunks = (range.upperBound - range.lowerBound)/Double(targetNumberIntervals)
        let power = floor(log10(basicChunks))
        let chunkDivisor = pow(10, Int(power))
        let singleUnitChunk = (basicChunks/(chunkDivisor as NSNumber).doubleValue).rounded()
        let finalChunk = singleUnitChunk * (chunkDivisor as NSNumber).doubleValue
        let start = floor(range.lowerBound/finalChunk) * finalChunk

        print("Basic Chunk: \(basicChunks), Final Chunk: \(finalChunk)")
        print("Basic Chunk power: \(power)")
        print("Basic Chunk divisor: \(chunkDivisor)")
        print("Single unit chunk: \(singleUnitChunk)")


        return AxisIntervalConfiguration(
            intervalSize: finalChunk,
            startingPosition: start
        )
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
        let formattedValue = makeLargeNumberASmallString(value)
        switch position {
        case .prefix:
            return "\(unit)\(formattedValue)"
        case .suffix:
            return "\(formattedValue)\(unit)"
        }
    }

    private func makeLargeNumberASmallString(_ number: Double) -> String {
        if number < 1000 {
            return round(number, suffix: "")
        } else if number >= 1000 && number < 1000000{
            return round(number/1000, suffix: "k")
        } else if number >= 1000000 && number < 1000000000 {
            return round(number/1000000, suffix: "M")
        } else {
            return round(number/1000000000, suffix: "B")
        }
    }

    private func round(_ number: Double, suffix: String) -> String {
        if(floor(number) == number){
            return("\(Int(number))\(suffix)")
        }
        let rounded = (number * 10).rounded() / 10
        return("\(rounded)\(suffix)")
    }
}
