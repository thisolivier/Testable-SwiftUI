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
                    colors: [Color("GradientStart"), Color("GradientEnd")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ).edgesIgnoringSafeArea(.all)
                HStack {
                    ScrollView(.vertical) {
                        LazyVStack(alignment: .leading){
                            filterMenu
                                .padding(.leading, 15)
                                .foregroundColor(.white)
                            ForEach(viewModel.dynamicProperties.coins) { coin in
                                NavigationLink {
                                    flowDelegate?.showDetails(for: coin)
                                } label: {
                                    CoinRow(coin: coin)
                                        .padding(3)
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
        HStack {
            Menu {
                ForEach(CoinSortType.allCases, id: \.self) { sortType in
                    Button {
                        interactor?.sortData(with: sortType)
                    } label: {
                        Text(sortType.rawValue)
                    }.accessibilityIdentifier("coinFilterOption")
                }
            } label: {
                Text("Sorted by " + viewModel.dynamicProperties.sortText)
            }
        }
        .accessibilityIdentifier("coinFilterMenu")
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
