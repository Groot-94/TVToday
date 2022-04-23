//
//  DefaultFetchPopularTVShowsUseCase.swift
//  AiringToday
//
//  Created by Jeans Ruiz on 6/28/20.
//

import Combine
import Shared
import NetworkingInterface

final class DefaultFetchPopularTVShowsUseCase: FetchTVShowsUseCase {

  private let tvShowsRepository: TVShowsRepository

  init(tvShowsRepository: TVShowsRepository) {
    self.tvShowsRepository = tvShowsRepository
  }

  func execute(requestValue: FetchTVShowsUseCaseRequestValue) -> AnyPublisher<TVShowResult, DataTransferError> {
    return tvShowsRepository.fetchPopularShows(page: requestValue.page)
  }
}