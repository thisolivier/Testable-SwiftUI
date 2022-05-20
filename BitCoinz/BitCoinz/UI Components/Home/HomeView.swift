//
//  HomeView.swift
//  Coinz_App_iOS
//
//  Created by Burhan Aras on 26.12.2021.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    weak var coordinator: HomeCoordinatorable?

    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                LazyVStack{
                    topBar.padding()
                    ForEach(viewModel.coins) { coin in
                        NavigationLink {
                            coordinator?.showDetails(for: coin)
                        } label: {
                            CoinRow(coin: coin)
                                .padding(4)
                        }
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
            Spacer()
            Menu {
                ForEach(SortType.allCases, id: \.self) { sortType in
                    Button {
                        viewModel.sortData(with: sortType)
                    } label: {
                        Text(sortType.rawValue)
                    }
                }
            } label: {
                Text(viewModel.sortText)
            }

        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(
            viewModel: HomeViewModel(
                networkLayer: NetworkLayer(),
                coinStore: CoinStore()
            ),
            coordinator: nil
        )
    }
}
