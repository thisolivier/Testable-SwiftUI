//
//  AppCoordinator.swift
//  BitCoinz
//
//  Created by Olivier Butler on 20/05/2022.
//

// ==========================================
// Feature Description: Environment
// ==========================================
// Allows us to replace whichever view or feature will be displayed first
// Very useful for UI testing

import SwiftUI

enum Environment {
    static var rootCoodinator: Coordinatorable = HomeCoordinator()

    static func reset() {
        rootCoodinator = HomeCoordinator()
    }
}
