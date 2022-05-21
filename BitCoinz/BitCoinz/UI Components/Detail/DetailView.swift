//
//  DetailView.swift
//  Coinz_App_iOS
//
//  Created by Burhan Aras on 26.12.2021.
//

import SwiftUI

struct DetailView: View {
    @ObservedObject var viewModel: DetailViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Coin: \(viewModel.staticProperties.symbol) - \(viewModel.staticProperties.name)")
                    .font(.title)
                Text("Price: \(viewModel.staticProperties.price)")
                Text("History:")
                    .font(.title)
                    .padding(.vertical)
                ForEach(viewModel.dynamicProperties.historyItems, id: \.self){ price in
                    HStack{
                        Text(price)
                    }
                    Divider()
                }
                Spacer()
                HStack{ Spacer()}
            }
            .padding()
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(
            viewModel: DetailViewModel(
                dynamicProperties: .init(historyItems: [
                    "Line One",
                    "A very long line with lots and lots of text that won't fit on one line.",
                    "111111122222223"
                ]),
                staticProperties: .init(symbol: "$$$", name: "Trident Coin", price: "123.45"))
        )
    }
}

let dummyCoin = Coin(
    id: "1",
    symbol: "1",
    name: "1",
    iconUrl: URL(string: "https://cdn.coinranking.com/yvUG4Qex5/solana.svg")!,
    price: "1",
    marketCap: "1",
    change: "1",
    listedAt: 1
)
