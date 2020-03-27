//
//  SeasonsListViewControllerDIContainer.swift
//  TVToday
//
//  Created by Jeans Ruiz on 1/20/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit

final class SeasonsListViewControllerDIContainer {
  
  struct Dependencies {
    let apiDataTransferService: DataTransferService
  }
  
  private let dependencies: Dependencies
  
  // MARK: - Initializers
  
  init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }
  
  public func makeSeasonsListViewController(with tvShowId: Int) -> UIViewController {
    return SeasonsListViewController.create(with: makeSeasonsListViewModel(with: tvShowId),
                                            seasonsListViewControllers: self)
  }
}

// MARK: - Private

extension SeasonsListViewControllerDIContainer {
  
  // MARK: - View Model
  
  private func makeSeasonsListViewModel(with tvShowId: Int) -> SeasonsListViewModel {
    return SeasonsListViewModel(tvShowId: tvShowId,
                                fetchEpisodesUseCase: makeFetchEpisodesShowsUseCase())
  }
  
  // MARK: - Use Cases
  
  private func makeFetchEpisodesShowsUseCase() -> FetchEpisodesUseCase {
    return DefaultFetchEpisodesUseCase(episodesRepository: makeEpisodesRepository())
  }
  
  // MARK: - Repositories
  
  private func makeEpisodesRepository() -> TVEpisodesRepository {
    return DefaultTVEpisodesRepository(dataTransferService: dependencies.apiDataTransferService)
  }
}

// MARK: - DefaultSeasonViewControllersFactory

extension SeasonsListViewControllerDIContainer: SeasonsListViewControllersFactory {
  
}

