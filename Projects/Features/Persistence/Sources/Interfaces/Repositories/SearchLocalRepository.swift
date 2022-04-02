//
//  SearchLocalRepository.swift
//  TVToday
//
//  Created by Jeans Ruiz on 7/2/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Combine
import Shared

public protocol SearchLocalRepository {
  func saveSearch(query: String, userId: Int) -> AnyPublisher<Void, CustomError>
  func fetchSearchs(userId: Int) -> AnyPublisher<[Search], CustomError>
}
