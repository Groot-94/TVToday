//
//  EpisodesListViewModelTests.swift
//  EpisodesListViewModelTests-Unit-Tests
//
//  Created by Jeans Ruiz on 7/28/20.
//

import Combine
import XCTest
@testable import ShowDetails
@testable import Shared

class EpisodesListViewModelTests: XCTestCase {

  let detailResult = TVShowDetailResult.stub()

  let episodes: [Episode] = {
    return [
      Episode.stub(id: 1, episodeNumber: 1, name: "Chapter #1"),
      Episode.stub(id: 2, episodeNumber: 2, name: "Chapter #2"),
      Episode.stub(id: 3, episodeNumber: 3, name: "Chapter #3")
    ]
  }()

  var fetchTVShowDetailsUseCaseMock: FetchTVShowDetailsUseCaseMock!
  var fetchEpisodesUseCaseMock: FetchEpisodesUseCaseMock!
  private var disposeBag: Set<AnyCancellable>!

  override func setUp() {
    super.setUp()
    fetchTVShowDetailsUseCaseMock = FetchTVShowDetailsUseCaseMock()
    fetchEpisodesUseCaseMock = FetchEpisodesUseCaseMock()
    disposeBag = []
  }

  func test_when_useCase_Is_Not_Responds_Yet_ViewModel_Should_contains_Loading_State() {
    // given
    let sut: EpisodesListViewModelProtocol =
    EpisodesListViewModel(tvShowId: 1,
                          fetchDetailShowUseCase: fetchTVShowDetailsUseCaseMock,
                          fetchEpisodesUseCase: fetchEpisodesUseCaseMock)

    let expected = [EpisodesListViewModel.ViewState.loading]
    var received = [EpisodesListViewModel.ViewState]()

    sut.viewState
      .removeDuplicates()
      .sink(receiveValue: { value in
        received.append(value)
      })
      .store(in: &disposeBag)

    // when
    sut.viewDidLoad()

    // then
    _ = XCTWaiter.wait(for: [XCTestExpectation()], timeout: 0.1)
    XCTAssertEqual(expected, received, "Should contains Loading State")
  }

  func test_when_ShowDetails_useCase_And_Seasons_useCase_return_OK_ViewModel_Should_Contains_Populated_State() {
    // given
    let seasonResult = SeasonResult(id: "1", episodes: self.episodes, seasonNumber: 1)

    fetchTVShowDetailsUseCaseMock.result = self.detailResult
    fetchEpisodesUseCaseMock.result = seasonResult

    let sut: EpisodesListViewModelProtocol =
    EpisodesListViewModel(tvShowId: 1,
                          fetchDetailShowUseCase: fetchTVShowDetailsUseCaseMock,
                          fetchEpisodesUseCase: fetchEpisodesUseCaseMock)

    let expected = [
      EpisodesListViewModel.ViewState.loading,
      EpisodesListViewModel.ViewState.populated
    ]
    var received = [EpisodesListViewModel.ViewState]()

    sut.viewState
      .removeDuplicates()
      .sink(receiveValue: { value in
        received.append(value)
      })
      .store(in: &disposeBag)

    // when
    sut.viewDidLoad()

    // then
    _ = XCTWaiter.wait(for: [XCTestExpectation()], timeout: 0.1)
    XCTAssertEqual(expected, received, "Should contains Populated State")
  }
}

//      context("When Uses Cases Retrieve Show Details and Seasons") {
//        it("Should ViewModel contains List of Episodes") {
//
//          // given
//          let headerViewModel = SeasonHeaderViewModel(showDetail: self.detailResult)
//          let numberOfSeasons = 9
//          let episodesSection = self.episodes.map { EpisodeSectionModelType(episode: $0)}
//            .map { SeasonsSectionItem.episodes(items: $0) }
//          let dataExpected: [SeasonsSectionModel] = [
//            .headerShow(header: "Header", items: [.headerShow(viewModel: headerViewModel)]),
//            .seasons(header: "Seasons", items: [.seasons(number: numberOfSeasons)]),
//            .episodes(header: "Episodes", items: episodesSection)
//          ]
//
//          let seasonResult = SeasonResult(id: "1", episodes: self.episodes, seasonNumber: 1)
//
//          fetchTVShowDetailsUseCaseMock.result = self.detailResult
//          fetchEpisodesUseCaseMock.result = seasonResult
//
//          let viewModel: EpisodesListViewModelProtocol =
//            EpisodesListViewModel(tvShowId: 1,
//                                  fetchDetailShowUseCase: fetchTVShowDetailsUseCaseMock,
//                                  fetchEpisodesUseCase: fetchEpisodesUseCaseMock)
//          // when
//          viewModel.viewDidLoad()
//
//          // when
//          let dataObservable = try? viewModel.data.toBlocking(timeout: 1).first()
//          guard let episodes = dataObservable else {
//            fail("It should emit episodes")
//            return
//          }
//
//          expect(episodes).toEventually(equal(dataExpected))
//        }
//      }
//
//      context("When Uses Cases Retrieves Error") {
//        it("Should ViewModel contains Error State") {
//
//          // given
//          fetchTVShowDetailsUseCaseMock.error = CustomError.genericError
//          fetchEpisodesUseCaseMock.error = CustomError.genericError
//
//          let viewModel: EpisodesListViewModelProtocol =
//            EpisodesListViewModel(tvShowId: 1,
//                                  fetchDetailShowUseCase: fetchTVShowDetailsUseCaseMock,
//                                  fetchEpisodesUseCase: fetchEpisodesUseCaseMock)
//          // when
//          viewModel.viewDidLoad()
//
//          // when
//          let viewState = try? viewModel.viewState.toBlocking(timeout: 1).first()
//          guard let currentViewState = viewState else {
//            fail("It should emit a View State")
//            return
//          }
//          let expected = EpisodesListViewModel.ViewState.error(CustomError.genericError.localizedDescription)
//
//          expect(currentViewState).toEventually(equal(expected))
//        }
//      }
//
//      context("When Use Case returns empty Episodes") {
//        it("Should ViewModel contains Empty State") {
//          // given
//          let seasonResult = SeasonResult(id: "1", episodes: [], seasonNumber: 1)
//
//          fetchTVShowDetailsUseCaseMock.result = self.detailResult
//          fetchEpisodesUseCaseMock.result = seasonResult
//
//          let viewModel: EpisodesListViewModelProtocol =
//            EpisodesListViewModel(tvShowId: 1,
//                                  fetchDetailShowUseCase: fetchTVShowDetailsUseCaseMock,
//                                  fetchEpisodesUseCase: fetchEpisodesUseCaseMock)
//          // when
//          viewModel.viewDidLoad()
//
//          // when
//          let viewState = try? viewModel.viewState.toBlocking(timeout: 1).first()
//          guard let currentViewState = viewState else {
//            fail("It should emit a View State")
//            return
//          }
//          let expected = EpisodesListViewModel.ViewState.empty
//
//          expect(currentViewState).toEventually(equal(expected))
//        }
//      }
//
//      context("When Ask for Diferent Season and Use Case dont respond yet") {
//        it("Should ViewModel contains Loading Season State") {
//
//          // given
//          let statesObserver = scheduler.createObserver(EpisodesListViewModel.ViewState.self)
//
//          let seasonResult = SeasonResult(id: "1", episodes: self.episodes, seasonNumber: 1)
//
//          fetchTVShowDetailsUseCaseMock.result = self.detailResult
//          fetchEpisodesUseCaseMock.result = seasonResult
//
//          let viewModel: EpisodesListViewModelProtocol =
//            EpisodesListViewModel(tvShowId: 1,
//                                  fetchDetailShowUseCase: fetchTVShowDetailsUseCaseMock,
//                                  fetchEpisodesUseCase: fetchEpisodesUseCaseMock)
//
//          viewModel.viewState
//            .distinctUntilChanged()
//            .subscribe { event in
//              statesObserver.on(event)
//            }
//            .disposed(by: disposeBag)
//
//          let seasonViewModel = SeasonListViewModelMock()
//
//          // when
//          viewModel.viewDidLoad()
//
//          // not response yet
//          fetchEpisodesUseCaseMock.result = nil
//          fetchEpisodesUseCaseMock.error = nil
//
//          viewModel.seasonListViewModel(seasonViewModel, didSelectSeason: 2)
//
//          // when
//          let expected: [Recorded<Event<EpisodesListViewModel.ViewState>>] = [
//            .next(0, .loading) ,
//            .next(0, .populated) ,
//            .next(0, .loadingSeason)
//          ]
//
//          expect(statesObserver.events).toEventually(equal(expected))
//        }
//      }
//
//      context("When Ask for Diferent Season And Use Case Returns Error") {
//        it("Should ViewModel contains Error Season State") {
//          // given
//          let statesObserver = scheduler.createObserver(EpisodesListViewModel.ViewState.self)
//
//          let seasonResult = SeasonResult(id: "1", episodes: self.episodes, seasonNumber: 1)
//
//          fetchTVShowDetailsUseCaseMock.result = self.detailResult
//          fetchEpisodesUseCaseMock.result = seasonResult
//
//          let viewModel: EpisodesListViewModelProtocol =
//            EpisodesListViewModel(tvShowId: 1,
//                                  fetchDetailShowUseCase: fetchTVShowDetailsUseCaseMock,
//                                  fetchEpisodesUseCase: fetchEpisodesUseCaseMock)
//
//          viewModel.viewState
//            .distinctUntilChanged()
//            .subscribe { event in
//              statesObserver.on(event)
//            }
//            .disposed(by: disposeBag)
//
//          let seasonViewModel = SeasonListViewModelMock()
//
//          // when
//          viewModel.viewDidLoad()
//
//          // not response yet
//          fetchEpisodesUseCaseMock.error = CustomError.genericError
//
//          // select next Season
//          viewModel.seasonListViewModel(seasonViewModel, didSelectSeason: 2)
//
//          // when
//          let expected: [Recorded<Event<EpisodesListViewModel.ViewState>>] = [
//            .next(0, .loading),
//            .next(0, .populated),
//            .next(0, .loadingSeason),
//            .next(0, .errorSeason(CustomError.genericError.localizedDescription))
//          ]
//
//          expect(statesObserver.events).toEventually(equal(expected))
//        }
//      }
//
//      context("When Ask for Diferent Season And UseCase returns Episodes") {
//        it("Should ViewModel contains Populated tate") {
//          // given
//          let statesObserver = scheduler.createObserver(EpisodesListViewModel.ViewState.self)
//
//          let seasonResult = SeasonResult(id: "1", episodes: self.episodes, seasonNumber: 1)
//
//          fetchTVShowDetailsUseCaseMock.result = self.detailResult
//          fetchEpisodesUseCaseMock.result = seasonResult
//
//          let viewModel: EpisodesListViewModelProtocol =
//            EpisodesListViewModel(tvShowId: 1,
//                                  fetchDetailShowUseCase: fetchTVShowDetailsUseCaseMock,
//                                  fetchEpisodesUseCase: fetchEpisodesUseCaseMock)
//
//          viewModel.viewState
//            .distinctUntilChanged()
//            .subscribe { event in
//              statesObserver.on(event)
//            }
//            .disposed(by: disposeBag)
//
//          let seasonViewModel = SeasonListViewModelMock()
//
//          // when
//          viewModel.viewDidLoad()
//
//          let secondSeason = SeasonResult(id: "2", episodes: self.episodes, seasonNumber: 2)
//          fetchEpisodesUseCaseMock.result = secondSeason
//          fetchEpisodesUseCaseMock.error = nil
//
//          // select next Season
//          viewModel.seasonListViewModel(seasonViewModel, didSelectSeason: 2)
//
//          // when
//          let expected: [Recorded<Event<EpisodesListViewModel.ViewState>>] = [
//            .next(0, .loading),
//            .next(0, .populated),
//            .next(0, .loadingSeason),
//            .next(0, .populated)
//          ]
//
//          expect(statesObserver.events).toEventually(equal(expected))
//        }
//      }
//
//      context("When Ask for Diferent Season And UseCase returns Episodes") {
//        it("Should ViewModel contains List of Episodes") {
//
//          // given
//          let episodesObserver = scheduler.createObserver([SeasonsSectionModel].self)
//
//          let numberOfSeasons = 9
//
//          let firstEpisodes = self.episodes.map { EpisodeSectionModelType(episode: $0)}
//            .map { SeasonsSectionItem.episodes(items: $0) }
//          let headerViewModel = SeasonHeaderViewModel(showDetail: self.detailResult)
//
//          let firstSeason: [SeasonsSectionModel] = [
//            .headerShow(header: "Header", items: [.headerShow(viewModel: headerViewModel)]),
//            .seasons(header: "Seasons", items: [.seasons(number: numberOfSeasons)]),
//            .episodes(header: "Episodes", items: firstEpisodes)
//          ]
//
//          let loadingSection: [SeasonsSectionModel] = [
//            .headerShow(header: "Header", items: [.headerShow(viewModel: headerViewModel)]),
//            .seasons(header: "Seasons", items: [.seasons(number: numberOfSeasons)]),
//            .episodes(header: "Episodes", items: [])
//          ]
//
//          let secondEpisodes = self.episodes.map { EpisodeSectionModelType(episode: $0)}
//            .map { SeasonsSectionItem.episodes(items: $0) }
//          let secondSeason: [SeasonsSectionModel] = [
//            .headerShow(header: "Header", items: [.headerShow(viewModel: headerViewModel)]),
//            .seasons(header: "Seasons", items: [.seasons(number: numberOfSeasons)]),
//            .episodes(header: "Episodes", items: secondEpisodes)
//          ]
//
//          let seasonResult = SeasonResult(id: "1", episodes: self.episodes, seasonNumber: 1)
//
//          fetchTVShowDetailsUseCaseMock.result = self.detailResult
//          fetchEpisodesUseCaseMock.result = seasonResult
//
//          let viewModel: EpisodesListViewModelProtocol =
//            EpisodesListViewModel(tvShowId: 1,
//                                  fetchDetailShowUseCase: fetchTVShowDetailsUseCaseMock,
//                                  fetchEpisodesUseCase: fetchEpisodesUseCaseMock)
//
//          viewModel.data
//            .distinctUntilChanged()
//            .subscribe { event in
//              episodesObserver.on(event)
//            }
//            .disposed(by: disposeBag)
//
//          let seasonViewModel = SeasonListViewModelMock()
//
//          // when
//          viewModel.viewDidLoad()
//
//          let secondSeasonResult = SeasonResult(id: "2", episodes: self.episodes, seasonNumber: 2)
//          fetchEpisodesUseCaseMock.result = secondSeasonResult
//          fetchEpisodesUseCaseMock.error = nil
//
//          // select next Season
//          viewModel.seasonListViewModel(seasonViewModel, didSelectSeason: 2)
//
//          // when
//          let expected: [Recorded<Event<[SeasonsSectionModel]>>] = [
//            .next(0, []),
//            .next(0, firstSeason),
//            .next(0, loadingSection),
//            .next(0, secondSeason)
//          ]
//
//          expect(episodesObserver.events).toEventually(equal(expected))
//        }
//      }
