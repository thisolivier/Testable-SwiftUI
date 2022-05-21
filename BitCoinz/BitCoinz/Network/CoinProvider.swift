//
//  NetworkLayer.swift
//  Coinz_App_iOS
//
//  Created by Burhan Aras on 26.12.2021.
//

import Foundation
import Combine

protocol CoinProvidable {
    func getCoins() -> AnyPublisher<CoinsResponse, NetworkError>
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
    
    func getCoins() -> AnyPublisher<CoinsResponse, NetworkError> {
        guard let url = getComponentsForCoinsRequest().url else {
            return Fail<CoinsResponse, NetworkError>(error: .invalidEndpoint)
                .eraseToAnyPublisher()
        }
        
        let publisher: AnyPublisher<CoinsResponse, NetworkError> = networkExecutor.fetch(
            url: url,
            decoder: nil
        )
        return publisher.eraseToAnyPublisher()
    }

    private func getComponentsForCoinsRequest() -> URLComponents{
        var components = URLComponents()
        components.scheme = environment.coinsApiSchema
        components.host = environment.coinsApiHost
        components.path = "/api/v1/dummy/coins"
        return components
    }
}
