//
//  FetchTVShowDetails.swift
//  TVToday
//
//  Created by Jeans Ruiz on 1/16/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Combine
import NetworkingInterface
import Shared
import Persistence
import Foundation

public protocol FetchTVShowDetailsUseCase {
  // MARK: - TODO Use another error maybe?
  func execute(requestValue: FetchTVShowDetailsUseCaseRequestValue) -> AnyPublisher<TVShowDetailResult, DataTransferError>
}

public struct FetchTVShowDetailsUseCaseRequestValue {
  let identifier: Int
}

// MARK: - FetchTVShowDetailsUseCase
public final class DefaultFetchTVShowDetailsUseCase: FetchTVShowDetailsUseCase {
  private let tvShowsRepository: TVShowsRepository
  private let tvShowsVisitedRepository: ShowsVisitedLocalRepository
  private let keychainRepository: KeychainRepository

  public init(tvShowsRepository: TVShowsRepository,
              keychainRepository: KeychainRepository,
              tvShowsVisitedRepository: ShowsVisitedLocalRepository) {
    self.tvShowsRepository = tvShowsRepository
    self.keychainRepository = keychainRepository
    self.tvShowsVisitedRepository = tvShowsVisitedRepository
  }

  public func execute(requestValue: FetchTVShowDetailsUseCaseRequestValue) -> AnyPublisher<TVShowDetailResult, DataTransferError> {
    var idLogged = 0
    if let userLogged = keychainRepository.fetchLoguedUser() {
      idLogged = userLogged.id
    }

    return tvShowsRepository
      .fetchTVShowDetails(with: requestValue.identifier)
      .receive(on: DispatchQueue.main) // MARK: - TODO,
      .flatMap { [tvShowsVisitedRepository] details -> AnyPublisher<TVShowDetailResult, DataTransferError> in
        return tvShowsVisitedRepository.saveShow(id: details.id ?? 0,
                                                 pathImage: details.posterPath ?? "",
                                                 userId: idLogged)
          .map { _ -> TVShowDetailResult in details }
          .mapError { _ -> DataTransferError in DataTransferError.noResponse }
          .eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()
  }
}
