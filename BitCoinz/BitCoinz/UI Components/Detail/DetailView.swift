//
//  DetailView.swift
//  Coinz_App_iOS
//
//  Created by Burhan Aras on 26.12.2021.
//

import SwiftUI

struct DetailView: View {
    @ObservedObject var viewModel: DetailViewModel
    var interactor: DetailInteractable?

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.gradientStart, .gradientEnd],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ).edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Price: \(viewModel.staticProperties.price)")
                    Text("History")
                        .font(.title)
                        .padding(.vertical)
                    ForEach(viewModel.dynamicProperties.historyItems, id: \.self.0){ dateAndPrice in
                        HStack{
                            Text(dateAndPrice.0)
                            Spacer()
                            Text(dateAndPrice.1)
                        }
                        Divider()
                    }
                    Spacer()
                }
                .padding()
            }
        }
        .navigationTitle("\(viewModel.staticProperties.symbol) - \(viewModel.staticProperties.name)")
        .task {
            interactor?.loadData()
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(
            viewModel: DetailViewModel(
                dynamicProperties: .init(historyItems: [
                    ("11-11-2002", "$123456.54"),
                    ("11-11-2003", "$12356.54"),
                    ("11-11-2004", "$99912356.20"),
                    ("11-11-2005", "$56.40")
                ]),
                staticProperties: .init(symbol: "$$$", name: "Trident Coin", price: "123.45")
            ),
            interactor: nil
        )
    }
}
