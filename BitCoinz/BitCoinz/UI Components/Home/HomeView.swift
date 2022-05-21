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
    @ObservedObject var viewModel: HomeViewModel
    weak var flowDelegate: HomeFlowDelegate?

    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                LazyVStack{
                    topBar.padding()
                    ForEach(viewModel.coins) { coin in
                        NavigationLink {
                            flowDelegate?.showDetails(for: coin)
                        } label: {
                            CoinRow(coin: coin)
                                .padding(4)
                        }.accessibilityIdentifier("coinRow")
                    }
                }
            }.task {
                viewModel.loadData()
            }
            .navigationBarHidden(true)
        }
    }

    var topBar: some View {
        HStack {
            Text(viewModel.title)
                .font(.title)
                .accessibilityIdentifier("appTitle")
            Spacer()
            Menu {
                ForEach(CoinSortType.allCases, id: \.self) { sortType in
                    Button {
                        viewModel.sortData(with: sortType)
                    } label: {
                        Text(sortType.rawValue)
                    }.accessibilityIdentifier("coinFilterOption")
                }
            } label: {
                Text(viewModel.sortText)
            }
            .accessibilityIdentifier("coinFilterMenu")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(
            viewModel: HomeViewModel(
                coinProvider: CoinProvider(),
                coinPriceStore: CoinPriceStore()
            )
        )
    }
}
