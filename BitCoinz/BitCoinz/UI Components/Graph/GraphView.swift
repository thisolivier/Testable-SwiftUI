//
//  GraphView.swift
//  BitCoinz
//
//  Created by Olivier Butler on 29/05/2022.
//

import SwiftUI

/*
 This view has two assumptions about the data it is passed:
 1) The data is ordered by date
 2) There are at least 2 data points
 */
struct GraphView: View {
    let calendar = Calendar.current
    let data: [(Double, Date)] = GraphView_Previews.mockData
    var scaleRange: ClosedRange<Double> {
        let doubles = data
            .map { $0.0 }
        return (doubles.min() ?? 0) ... (doubles.max() ?? 1)
    }
    var dateRange: DateInterval {
        let dates = data.map { $0.1 }
        return DateInterval(
            start: dates.first ?? Date.distantPast,
            end: dates.last ?? Date()
        )
    }
    var totalInterval: Double {
        dateRange.start.timeIntervalSinceReferenceDate - dateRange.end.timeIntervalSinceReferenceDate
    }

    var body: some View {
        GeometryReader { geometry in
            let outerWidth = Double(geometry.size.width)
            let outerHeight = Double(geometry.size.height)
            let numberOfXAxisPoints: Int = {
                if outerWidth > 300 {
                    return 6
                } else if outerWidth > 250 {
                    return 5
                } else if outerWidth > 200 {
                    return 4
                } else {
                    return 2
                }
            }()
            VStack(spacing:0) {
                HStack(spacing:0) {
                    VStack {
                        Text("$85K").frame(maxHeight: .infinity)
                        Text("$80K").frame(maxHeight: .infinity)
                        Text("$75K").frame(maxHeight: .infinity)
                        Text("$70K").frame(maxHeight: .infinity)
                        Text("$65K").frame(maxHeight: .infinity)
                    }
                    Rectangle()
                        .frame(width: 2)
                    GeometryReader { geometry in
                        let width = Double(geometry.size.width)
                        let height = Double(geometry.size.height)
                        Path { path in
                            path.move(to: CGPoint(
                                x: 0,
                                y: relativeYPosition(for: data.first?.0 ?? 0))
                            )
                            for datum in data {
                                let interval =  datum.1.timeIntervalSinceReferenceDate - dateRange.start.timeIntervalSinceReferenceDate
                                let x = 1 - Double(interval/totalInterval) * width
                                let y = relativeYPosition(for: datum.0) * height
                                print(x, y)
                                path.addLine(to: CGPoint(
                                    x: x,
                                    y: y
                                ))
                            }
                        }
                        .stroke(
                            Color.black,
                            style: StrokeStyle(
                                lineWidth: 2,
                                lineCap: .round,
                                lineJoin: .round
                            )
                        )
                    }
                }
                Rectangle()
                    .foregroundColor(.red)
                    .frame(height: 10)
            }


        }

    }

    private func relativeYPosition(
        for value: Double
    ) -> Double {
        return 1 - ((value - scaleRange.lowerBound) / scaleRange.upperBound)
    }
}

struct GraphView_Previews: PreviewProvider {
    static let mockData: [(Double, Date)] = {
        let strings = [
            "20-01-2022 00:45",
            "20-01-2022 09:16",
            "21-01-2022 00:06",
            "21-01-2022 12:24",
            "21-01-2022 12:25",
            "21-01-2022 12:26",
            "22-01-2022 10:00",
            "25-01-2022 10:00",
            "26-01-2022 10:00",
            "27-01-2022 10:00",
            "30-01-2022 10:00",
            "01-02-2022 22:59"
        ]
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        let dates = strings.map {
            formatter.date(from: $0)!
        }
        return dates.map { date in
            (Double.random(in: 10...10000), date)
        }
    }()

    static var previews: some View {
        return GraphView()
    }
}
