//
//  HomeView.swift
//  Coinz_App_iOS
//
//  Created by Burhan Aras on 26.12.2021.
//

import SwiftUI

protocol HomeFlowDelegate: AnyObject {
    func showDetails(for: Coin) -> AnyView
}

struct HomeView: View {
    var interactor: HomePresentable?
    @ObservedObject var viewModel: ViewModelHolder<HomeStaticViewModel, HomeDynamicViewModel>
    weak var flowDelegate: HomeFlowDelegate?

    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                LazyVStack{
                    topBar.padding()
                    ForEach(viewModel.dynamicProperties.coins) { coin in
                        NavigationLink {
                            flowDelegate?.showDetails(for: coin)
                        } label: {
                            CoinRow(coin: coin)
                                .padding(4)
                        }.accessibilityIdentifier("coinRow")
                    }
                }
            }
            .navigationBarHidden(true)
        }.task {
            interactor?.loadData()
        }
    }

    var topBar: some View {
        HStack {
            Text(viewModel.staticProperties.title)
                .font(.title)
                .accessibilityIdentifier("appTitle")
            Spacer()
            Menu {
                ForEach(CoinSortType.allCases, id: \.self) { sortType in
                    Button {
                        interactor?.sortData(with: sortType)
                    } label: {
                        Text(sortType.rawValue)
                    }.accessibilityIdentifier("coinFilterOption")
                }
            } label: {
                Text(viewModel.dynamicProperties.sortText)
            }
            .accessibilityIdentifier("coinFilterMenu")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(
            interactor: nil,
            viewModel: .init(
                dynamicProperties: .init(coins: [], sortText: "Sort", errorMessage: "Error"),
                staticProperties: .init(title: "App Title")
            )
        )
    }
}
