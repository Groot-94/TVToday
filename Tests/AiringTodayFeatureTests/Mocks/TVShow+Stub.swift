//
//  TVShow+Stub.swift
//  AiringToday-Unit-Tests
//
//  Created by Jeans Ruiz on 7/28/20.
//

@testable import Shared

extension TVShow {
  static func stub(
    id: Int = 1,
    name: String = "title1",
    voteAverage: Double = 1.0,
    posterPath: String? = "/1",
    backDropPath: String? = "/back1",
    overview: String = "overview1"
  ) -> Self {

    TVShow(id: id,
           name: name,
           voteAverage: voteAverage,
           posterPath: posterPath,
           backDropPath: backDropPath,
           overview: overview)
  }
}
