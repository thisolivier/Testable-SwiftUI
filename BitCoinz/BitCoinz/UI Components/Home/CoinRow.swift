//
//  CoinRow.swift
//  Coinz_App_iOS
//
//  Created by Olivier Butler on 19/05/2022.
//

import SwiftUI

struct CoinRow: View {
    let coin: Coin
    let fallbackImageName: String

    var body: some View {
        HStack {
            coinImage
            VStack(alignment: .leading ,spacing: 4) {
                HStack {
                    Text(coin.name)
                        .font(.title2)
                        .foregroundColor(.black)
                    Text(coin.symbol)
                        .foregroundColor(.black)
                }
                HStack{
                    Text(coin.price)
                        .foregroundColor(.black)
                    Spacer()
                    Text(coin.change)
                        .foregroundColor(.black)
                }
            }
            Image(systemName: "chevron.right")
                .padding([.leading, .trailing], 10)
                .foregroundColor(.black)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
        .background(Color("ElementBackground").opacity(0.75))
        .cornerRadius(30)
        .shadow(radius: 16)
    }

    var coinImage: some View {
        AsyncImage(url: coin.iconUrl) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFit()
            } else if phase.error != nil {
                Image(fallbackImageName)
                    .resizable()
                    .scaledToFit()
            } else {
                ProgressView()
            }
        }
        .frame(width: 30, height: 30)
        .cornerRadius(5)
        .padding([.leading, .trailing], 10)
    }
}

