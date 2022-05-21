//
//  ViewModelable.swift
//  BitCoinz
//
//  Created by Olivier Butler on 21/05/2022.
//

import Foundation

// Inspired by Observing Structs in SwiftUI by Jordan Morgan, https://www.swiftjectivec.com/Observing-Structs-SwiftUI/
class ViewModelHolder<StaticProps, DynamicProps>: ObservableObject {
    @Published var dynamicProperties: DynamicProps
    let staticProperties: StaticProps

    init(
        dynamicProperties: DynamicProps,
        staticProperties: StaticProps
    ) {
        self.dynamicProperties = dynamicProperties
        self.staticProperties = staticProperties
    }
}
