//
//  HomeView.swift
//  Coinz_App_iOS
//
//  Created by Burhan Aras on 26.12.2021.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                LazyVStack{
                    topBar.padding()
                    ForEach(viewModel.coins) { coin in
                        NavigationLink {
                            Coordinator.shared.getDetailView(for: coin)
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
            Text("₿ Coinz App").font(.title)
            Spacer()
            Menu {
                Button {
                    viewModel.sortData(with: SortType.price)
                } label: {
                    Text("Price")
                }
                
                Button {
                    viewModel.sortData(with: SortType.marketCap)
                } label: {
                    Text("Market Cap")
                }
                
                Button {
                    viewModel.sortData(with: SortType.change)
                } label: {
                    Text("Change")
                }

                Button {
                    viewModel.sortData(with: SortType.listedAt)
                } label: {
                    Text("Listed At")
                }
                
            } label: {
                Text(viewModel.sortText)
            }

        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel(
            networkLayer: NetworkLayer(),
            databaseLayer: DatabaseLayer()
        ))
    }
}
