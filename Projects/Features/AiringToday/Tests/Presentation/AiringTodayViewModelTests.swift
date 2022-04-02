//
//  AiringTodayViewModelTests.swift
//  AiringToday-Unit-Tests
//
//  Created by Jeans Ruiz on 7/28/20.
//

// swiftlint:disable all

@testable import AiringToday
@testable import Shared
import XCTest
import Combine

class AiringTodayViewModelTests: XCTestCase {

  // TODO, use free function and update snapshot tests
  let firstShow = TVShow.stub(id: 1, name: "title1 🐶", posterPath: "/1",
                              backDropPath: "/back1", overview: "overview")
  let secondShow = TVShow.stub(id: 2, name: "title2 🔫", posterPath: "/2",
                               backDropPath: "/back2", overview: "overview2")
  let thirdShow = TVShow.stub(id: 3, name: "title3 🚨", posterPath: "/3",
                              backDropPath: "/back3", overview: "overview3")

  lazy var firstPage = TVShowResult.stub(page: 1,
                                         results: [firstShow, secondShow],
                                         totalResults: 3,
                                         totalPages: 2)

  lazy var secondPage = TVShowResult.stub(page: 2,
                                          results: [thirdShow],
                                          totalResults: 3,
                                          totalPages: 2)

  let emptyPage = TVShowResult.stub(page: 1, results: [], totalResults: 0, totalPages: 1)

  var fetchUseCaseMock: FetchShowsUseCaseMock!
  var disposeBag: Set<AnyCancellable>!

  override func setUp() {
    super.setUp()
    fetchUseCaseMock = FetchShowsUseCaseMock()
    disposeBag = []
  }

  func test_When_UseCase_Doesnot_Responds_Yet_ViewModel_Should_Contains_Loading_State() {
    // given
    let sut: AiringTodayViewModelProtocol
    sut = AiringTodayViewModel(fetchTVShowsUseCase: self.fetchUseCaseMock, coordinator: nil)

    // when
    sut.viewDidLoad()

    let expected = SimpleViewState<AiringTodayCollectionViewModel>.loading

    var countValuesReceived = 0
    sut.viewStateObservableSubject
      .removeDuplicates()
      .sink(receiveValue: { value in

        // then
        countValuesReceived += 1
        XCTAssertEqual(expected, value, "AiringTodayViewModel should contains loading State")
      })
      .store(in: &disposeBag)

    // then
    XCTAssertEqual(1, countValuesReceived, "Should only receives one Value")
  }

  func test_when_useCase_respons_with_FirstPage_ViewModel_Should_contains_Populated_State() {
    // given
    fetchUseCaseMock.result = self.firstPage
    let firstPageCells = self.firstPage.results!.map { AiringTodayCollectionViewModel(show: $0) }

    let sut: AiringTodayViewModelProtocol = AiringTodayViewModel(fetchTVShowsUseCase: fetchUseCaseMock, coordinator: nil)

    let expected = [
      SimpleViewState<AiringTodayCollectionViewModel>.loading,
      SimpleViewState<AiringTodayCollectionViewModel>.paging(firstPageCells, next: 2)
    ]

    var received = [SimpleViewState<AiringTodayCollectionViewModel>]()

    sut.viewStateObservableSubject
      .removeDuplicates()
      .sink(receiveValue: { value in
        received.append(value)
      })
      .store(in: &disposeBag)

    // when
    sut.viewDidLoad()

    // then
    _ = XCTWaiter.wait(for: [XCTestExpectation()], timeout: 0.1)
    XCTAssertEqual(expected, received, "Should contains 2 values")
  }

  func test_When_ask_for_second_page_ViewModel_Should_contains_Populated_State_with_Second_Page() {
    // given
    let sut: AiringTodayViewModelProtocol = AiringTodayViewModel(fetchTVShowsUseCase: fetchUseCaseMock, coordinator: nil)
    let firstPage = self.firstPage.results!.map { AiringTodayCollectionViewModel(show: $0) }
    let secondPage = (self.firstPage.results + self.secondPage.results).map { AiringTodayCollectionViewModel(show: $0) }

    let expected = [
      SimpleViewState<AiringTodayCollectionViewModel>.loading,
      SimpleViewState<AiringTodayCollectionViewModel>.paging(firstPage, next: 2),
      SimpleViewState<AiringTodayCollectionViewModel>.populated(secondPage)
    ]

    var received = [SimpleViewState<AiringTodayCollectionViewModel>]()

    sut.viewStateObservableSubject
      .removeDuplicates()
      .print()
      .sink(receiveCompletion: { _ in } , receiveValue: { value in
        received.append(value)
      })
      .store(in: &disposeBag)

    // when
    fetchUseCaseMock.result = self.firstPage
    sut.viewDidLoad()

    _ = XCTWaiter.wait(for: [XCTestExpectation()], timeout: 0.1)

    // and when
    fetchUseCaseMock.result = self.secondPage
    sut.didLoadNextPage()

    // then
    _ = XCTWaiter.wait(for: [XCTestExpectation()], timeout: 0.1)
    XCTAssertEqual(expected, received, "Should contains 3 values")
  }

  func test_When_UseCase_Responds_Error_ViewModel_Should_Contains_Error_State() {
    // given
    fetchUseCaseMock.error = .noResponse
    let sut: AiringTodayViewModelProtocol
    sut = AiringTodayViewModel(fetchTVShowsUseCase: self.fetchUseCaseMock, coordinator: nil)

    let expected = [
      SimpleViewState<AiringTodayCollectionViewModel>.loading,
      SimpleViewState<AiringTodayCollectionViewModel>.error("")
    ]
    var received = [SimpleViewState<AiringTodayCollectionViewModel>]()

    sut.viewStateObservableSubject
      .removeDuplicates()
      .sink(receiveValue: { value in
        received.append(value)
      })
      .store(in: &disposeBag)

    // when
    sut.viewDidLoad()
    _ = XCTWaiter.wait(for: [XCTestExpectation()], timeout: 0.1)

    // then
    XCTAssertEqual(2, received.count, "Should only receives one Value")
    XCTAssertEqual(expected, received, "AiringTodayViewModel should contains Error State")
  }

  func test_When_UseCase_Responds_With_Zero_Elements_ViewModel_Should_Contains_Empty_State() {
    // given
    fetchUseCaseMock.result = self.emptyPage
    let sut: AiringTodayViewModelProtocol
    sut = AiringTodayViewModel(fetchTVShowsUseCase: self.fetchUseCaseMock, coordinator: nil)

    let expected = [
      SimpleViewState<AiringTodayCollectionViewModel>.loading,
      SimpleViewState<AiringTodayCollectionViewModel>.empty
    ]
    var received = [SimpleViewState<AiringTodayCollectionViewModel>]()

    sut.viewStateObservableSubject
      .removeDuplicates()
      .sink(receiveValue: { value in
        received.append(value)
      })
      .store(in: &disposeBag)

    // when
    sut.viewDidLoad()
    _ = XCTWaiter.wait(for: [XCTestExpectation()], timeout: 0.1)

    // then
    XCTAssertEqual(2, received.count, "Should only receives one Value")
    XCTAssertEqual(expected, received, "AiringTodayViewModel should contains Empty State")
  }
}
