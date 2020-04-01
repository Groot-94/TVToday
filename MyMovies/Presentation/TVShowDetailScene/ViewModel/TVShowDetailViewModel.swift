//
//  TVShowDetailViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/16/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

// MARK: - TODO Implement Input Button Favorite movie ❤️

import Foundation
import RxSwift

enum TVShowDetailViewModelRoute {
  case initial
  case showSeasonsList(tvShowId: Int)
}

final class TVShowDetailViewModel {
  
  private let fetchDetailShowUseCase: FetchTVShowDetailsUseCase
  
  private let showId: Int
  
  private var viewStateObservableSubject = BehaviorSubject<ViewState>(value: .loading)
  
  // MARK: - TODO refactor, routing
  private var routeObservableSubject = BehaviorSubject<TVShowDetailViewModelRoute>(value: .initial)
  
  // MARK: - Base ViewModel
  var input: Input
  var output: Output
  
  // MARK: - Initializers
  
  init(_ showId: Int, fetchDetailShowUseCase: FetchTVShowDetailsUseCase) {
    self.fetchDetailShowUseCase = fetchDetailShowUseCase
    self.showId = showId
    
    self.input = Input()
    self.output = Output(
      viewState: viewStateObservableSubject.asObservable(),
      route: routeObservableSubject.asObservable())
  }
  
  //MARK: - Networking
  
  func getShowDetails() {
    
    let request = FetchTVShowDetailsUseCaseRequestValue(identifier: showId)
    
    _ = fetchDetailShowUseCase.execute(requestValue: request) { [weak self] result in
      guard let strongSelf = self else { return }
      switch result {
      case .success(let response):
        strongSelf.processFetched(for: response)
      case .failure(let error):
        strongSelf.viewStateObservableSubject.onNext(.error(error.localizedDescription))
      }
    }
  }
  
  private func processFetched(for response: TVShowDetailResult) {
    let showDetail = setupTVShow(response)
    viewStateObservableSubject.onNext(.populated(showDetail))
  }
  
  private func setupTVShow(_ show: TVShowDetailResult) -> TVShowDetailInfo {
    return TVShowDetailInfo(
      id: show.id,
      backDropPath: show.getbackDropPathURL(),
      nameShow: show.name,
      yearsRelease: show.releaseYears,
      duration: show.episodeDuration,
      genre: show.genreIds?.first?.name,
      numberOfEpisodes: (show.numberOfEpisodes != nil) ? String(show.numberOfEpisodes!) : "",
      posterPath: show.getposterPathURL(),
      overView: show.overview,
      score: (show.voteAverage != nil) ? String(show.voteAverage!) : "",
      countVote: (show.voteCount != nil) ? String(show.voteCount!) : "")
  }
  
  func showSeasonList() {
    routeObservableSubject.onNext(
      .showSeasonsList(tvShowId: showId) )
  }
}

// MARK: - ViewState

extension TVShowDetailViewModel {
  
  enum ViewState {
    
    case loading
    case populated(TVShowDetailInfo)
    case empty
    case error(String)
  }
}

// MARK: - ViewModel Base

extension TVShowDetailViewModel {
  
  public struct TVShowDetailInfo {
    var id: Int
    var backDropPath: URL?
    var nameShow: String?
    var yearsRelease: String?
    var duration: String?
    var genre: String?
    var numberOfEpisodes: String?
    var posterPath: URL?
    var overView: String?
    var score: String?
    var countVote: String?
  }
  
  public struct Input { }
  
  public struct Output {
    let viewState: Observable<ViewState>
    
    // MARK: - TODO, refactor navigation
    let route: Observable<TVShowDetailViewModelRoute>
  }
}
