//
//  Coinz_App_iOSApp.swift
//  Coinz_App_iOS
//
//  Created by Burhan Aras on 26.12.2021.
//

import SwiftUI

@main
struct BitCoinzApp: App {
    let rootCoordinator: Coordinatorable = HomeCoordinator()

    var body: some Scene {
        WindowGroup {
            rootCoordinator.start()
        }
    }
}
