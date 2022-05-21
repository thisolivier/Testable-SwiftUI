//
//  Environment.swift
//  BitCoinz
//
//  Created by Olivier Butler on 21/05/2022.
//

import Foundation

struct Environment {
    // If you wanted to pass in launch arguments via the ProcessInfo.processInfo.environment dictionary, look them up here
    static var shared: Environment = Environment()

//    static func overrideEnvironment(with overrides: EnvironmentOverrides) {
//        shared = Environment(
//            coinsApiHost: overrides.coinsApiHost ?? shared.coinsApiHost,
//            coinsApiSchema: overrides.coinsApiSchema ?? shared.coinsApiSchema
//        )
//    }
//
//    static func resetEnvironment() {
//        shared = Environment()
//    }

    var coinsApiHost: String = "psp-merchantpanel-service-sandbox.ozanodeme.com.tr"
    var coinsApiSchema: String = "https"
}

//struct EnvironmentOverrides {
//    var coinsApiHost: String?
//    var coinsApiSchema: String?
//}
