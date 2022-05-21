//
//  Environment.swift
//  BitCoinz
//
//  Created by Olivier Butler on 21/05/2022.
//

import Foundation

struct Environment {
    static var shared: Environment = Environment()

    var coinsApiHost: String = "psp-merchantpanel-service-sandbox.ozanodeme.com.tr"
    var coinsApiSchema: String = "https"
}
