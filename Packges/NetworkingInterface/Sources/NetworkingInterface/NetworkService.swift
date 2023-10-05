//
//  NetworkService.swift
//  NetworkingInterface
//
//  Created by Jeans Ruiz on 19/03/22.
//

import Foundation
import Combine

@available(macOS 10.15, *)
public protocol NetworkService {
  func request(endpoint: Requestable) -> AnyPublisher<Data, NetworkError>
}

@available(macOS 10.15, *)
public protocol NetworkSessionManager {
  typealias NetworkingOutput = (data: Data, response: URLResponse)
  func request(_ request: URLRequest) -> AnyPublisher<NetworkingOutput, URLError>
}

public protocol NetworkErrorLogger {
  func log(request: URLRequest)
  func log(responseData data: Data?, response: URLResponse?)
  func log(error: Error)
  func log(responseData data: Data, response: URLResponse)
}