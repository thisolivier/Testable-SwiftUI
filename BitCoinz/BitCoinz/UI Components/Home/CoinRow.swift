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
            HStack() {
                VStack(spacing: 8) {
                    HStack {
                        Text(coin.symbol)
                            .foregroundColor(.purple)
                        Spacer()
                        Text(coin.price)
                            .foregroundColor(.black)
                    }
                    HStack{
                        Text(coin.name)
                        Spacer()
                        Text(coin.change)
                    }
                }
                Image(systemName: "chevron.right")
                    .padding([.leading, .trailing], 10)
            }

        }
        .padding(4)
        .background(Color("ElementBackground"))
        .cornerRadius(6)
        .shadow(radius: 16)
    }
}

