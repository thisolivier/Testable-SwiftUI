//
//  ViewModelable.swift
//  BitCoinz
//
//  Created by Olivier Butler on 21/05/2022.
//

import Foundation

// Inspired by Observing Structs in SwiftUI by Jordan Morgan, https://www.swiftjectivec.com/Observing-Structs-SwiftUI/
// A ViewModelHolder should have its static properties set exactly once, and its dynamic properties can be updated at will
class ViewModelHolder<StaticProps, DynamicProps>: ObservableObject {
    @Published var dynamicProperties: DynamicProps
    var staticProperties: StaticProps

    init(
        dynamicProperties: DynamicProps,
        staticProperties: StaticProps
    ) {
        self.dynamicProperties = dynamicProperties
        self.staticProperties = staticProperties
    }
}
