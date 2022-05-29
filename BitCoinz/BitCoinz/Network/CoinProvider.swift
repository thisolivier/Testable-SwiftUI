//
//  NetworkLayer.swift
//  Coinz_App_iOS
//
//  Created by Burhan Aras on 26.12.2021.
//

import Foundation
import Combine

protocol CoinProvidable {
    func getCoins() -> AnyPublisher<[Coin], Error>
}

class CoinProvider: CoinProvidable {
    private var networkExecutor: NetworkExecutable.Type
    private var environment: Environment

    init(
        networkExecutor: NetworkExecutable.Type = NetworkExecutor.self,
        environment: Environment = Environment.shared
    ) {
        self.networkExecutor = networkExecutor
        self.environment = environment
    }
    
    func getCoins() -> AnyPublisher<[Coin], Error> {
        guard let url = getComponentsForCoinsRequest().url else {
            return Fail<[Coin], Error>(error: NetworkError.invalidEndpoint)
                .eraseToAnyPublisher()
        }
        
        return networkExecutor
            .fetch(url: url, decoder: nil)
            .map { (response: CoinsResponse) in
                return response.data.coins.map { Coin.fromDTO(dto: $0) }
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }

    private func getComponentsForCoinsRequest() -> URLComponents{
        var components = URLComponents()
        components.scheme = environment.coinsApiSchema
        components.host = environment.coinsApiHost
        components.path = "/api/v1/dummy/coins"
        return components
    }
}
