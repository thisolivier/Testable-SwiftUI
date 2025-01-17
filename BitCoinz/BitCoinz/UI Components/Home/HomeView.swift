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
    var interactor: HomeInteractable?
    @ObservedObject var viewModel: ViewModelHolder<HomeStaticViewModel, HomeDynamicViewModel>
    weak var flowDelegate: HomeFlowDelegate?

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [.gradientStart, .gradientEnd],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ).edgesIgnoringSafeArea(.all)
                HStack {
                    ScrollView(.vertical) {
                        LazyVStack(alignment: .leading){
                            filterMenu
                                .padding(.leading, 15)
                            ForEach(viewModel.dynamicProperties.coins) { coin in
                                NavigationLink {
                                    flowDelegate?.showDetails(for: coin)
                                } label: {
                                    CoinRow(
                                        coin: coin,
                                        fallbackImageName: viewModel.staticProperties.fallbackImageName
                                    )
                                    .padding(.horizontal, 5)
                                    .padding(.vertical, 3)
                                }.accessibilityIdentifier("coinRow")
                            }
                        }
                    }
                }
                .navigationTitle(viewModel.staticProperties.title)
                .navigationBarTitleDisplayMode(.large)
            }
        }.task {
            interactor?.loadData()
        }
    }

    var filterMenu: some View {
        HStack(spacing: 2) {
            Text("Sorted by")
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
                    .padding(.vertical, 3)
                    .padding(.horizontal, 5)
                    .foregroundColor(.black)
            }
            .background { Color.elementBackground }
            .cornerRadius(5)
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
                staticProperties: .init(title: "App Title", fallbackImageName: "UnknownCoin")
            )
        )
    }
}
