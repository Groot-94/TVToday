//
//  DIContainer.swift
//  PopularShows
//
//  Created by Jeans Ruiz on 7/20/20.
//

import UIKit
import NetworkingInterface
import Shared
import ShowDetailsFeatureInterface

final class DIContainer {

  private let dependencies: ModuleDependencies

  // MARK: - Repositories
  private lazy var showsRepository: TVShowsRepository = {
    return DefaultTVShowsRepository(
      dataTransferService: dependencies.apiDataTransferService,
      basePath: dependencies.imagesBaseURL)
  }()

  // MARK: - Initializer
  init(dependencies: ModuleDependencies) {
    self.dependencies = dependencies
  }

  // MARK: - Module Coordinator
  func buildPopularCoordinator(navigationController: UINavigationController) -> Coordinator {
    let coordinator = PopularCoordinator(navigationController: navigationController, dependencies: self)
    return coordinator
  }

  // MARK: - Uses Cases
  private func makeFetchPopularShowsUseCase() -> FetchTVShowsUseCase {
    let showsPageRepository = DefaultTVShowsPageRepository(
      showsPageRemoteDataSource: DefaultTVShowsRemoteDataSource(dataTransferService: dependencies.apiDataTransferService),
      mapper: DefaultTVShowPageMapper(),
      imageBasePath: dependencies.imagesBaseURL
    )
    return DefaultFetchPopularTVShowsUseCase(tvShowsPageRepository: showsPageRepository, tvShowsRepository: showsRepository)
  }
}

extension DIContainer: PopularCoordinatorDependencies {
  func buildPopularViewController(coordinator: PopularCoordinatorProtocol?) -> UIViewController {
    let viewModel = PopularViewModel(fetchTVShowsUseCase: makeFetchPopularShowsUseCase(),
                                     coordinator: coordinator)
    let popularVC = PopularsViewController(viewModel: viewModel)
    return popularVC
  }

  func buildTVShowDetailCoordinator(navigationController: UINavigationController,
                                    delegate: TVShowDetailCoordinatorDelegate?) -> TVShowDetailCoordinatorProtocol {
    return dependencies.showDetailsBuilder.buildModuleCoordinator(in: navigationController, delegate: delegate)
  }
}
