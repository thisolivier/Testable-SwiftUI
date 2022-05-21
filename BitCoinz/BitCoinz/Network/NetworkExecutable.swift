//
//  NetworkStoreable.swift
//  BitCoinz
//
//  Created by Olivier Butler on 21/05/2022.
//

import Foundation
import Combine

protocol NetworkExecutable {
    static func fetch<NetworkModel: Codable>(
        url: URL?,
        decoder: JSONDecoder?
    ) -> AnyPublisher<NetworkModel, NetworkError>
}

enum NetworkExecutor: NetworkExecutable {
    private static let defaultDecoder = JSONDecoder()

    static func fetch<NetworkModel: Codable>(
        url: URL?,
        decoder: JSONDecoder?
    ) -> AnyPublisher<NetworkModel, NetworkError> {
        guard let url = url else{
            return Result<NetworkModel, NetworkError>
                .Publisher(.failure(.invalidEndpoint))
                .eraseToAnyPublisher()
        }

        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        print(request)

        return URLSession.shared.dataTaskPublisher(for: request)
            .retry(3)
            .map { $0.data }
            .decode(
                type: NetworkModel.self,
                decoder: decoder ?? defaultDecoder
            )
            .receive(on: RunLoop.main)
            .mapError{_ in return .apiError}
            .eraseToAnyPublisher()
    }
}
