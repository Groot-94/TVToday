//
//  TVShowsRepository.swift
//  TVToday
//
//  Created by Jeans on 1/14/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Combine
import NetworkingInterface

public protocol TVShowsRepository {
  func fetchAiringTodayShows(page: Int) -> AnyPublisher<TVShowResult, DataTransferError>

  func fetchPopularShows(page: Int) -> AnyPublisher<TVShowResult, DataTransferError>

  func fetchShowsByGenre(genreId: Int, page: Int) -> AnyPublisher<TVShowResult, DataTransferError>

  func searchShowsFor(query: String, page: Int) -> AnyPublisher<TVShowResult, DataTransferError>

  func fetchTVShowDetails(with showId: Int) -> AnyPublisher<TVShowDetailResult, DataTransferError>
}
