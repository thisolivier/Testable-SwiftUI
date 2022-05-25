//
//  HomeViewFactoryTests.swift
//  Unit Tests
//
//  Created by Olivier Butler on 22/05/2022.
//

import XCTest
@testable import BitCoinz
import SwiftUI

class HomeViewFactoryTests: XCTestCase {
    func test_factoryMakesView_generatesDependencies() {
        let view = HomeViewFactory.makeHomeView(flowDelegate: nil)
        XCTAssertNotNil(view.viewModel)
        XCTAssertNotNil(view.presenter)
    }

    func test_factoryMakesView_assignsFlowDelegate() {
        let flowDelegate = MockFlowDelegate()
        let view = HomeViewFactory.makeHomeView(flowDelegate: flowDelegate)
        XCTAssertTrue(view.flowDelegate is MockFlowDelegate)
    }
}

private class MockFlowDelegate: HomeFlowDelegate {
    func showDetails(for: Coin) -> AnyView {
        return Text("").asAnyView()
    }
}
