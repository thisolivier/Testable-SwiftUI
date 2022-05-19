//
//  CoinRow.swift
//  Coinz_App_iOS
//
//  Created by Olivier Butler on 19/05/2022.
//

import SwiftUI

struct CoinRow: View {
    let coin: Coin

    var body: some View {
        HStack {
            AsyncImage(
                url: coin.iconUrl,
                content: { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 32, height: 32, alignment: .center)
                },
                placeholder: {
                    ProgressView()
                }
            )
                .padding()
            VStack(spacing: 8) {
                HStack {
                    Text(coin.symbol)
                    Spacer()
                    Text(coin.price)
                }
                HStack{
                    Text(coin.name)
                    Spacer()
                    Text(coin.change)
                }
            }
        }
        .padding(4)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(6)
        .shadow(radius: 16)
    }
}

