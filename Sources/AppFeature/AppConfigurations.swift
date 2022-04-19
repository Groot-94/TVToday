//
//  AppConfigurations.swift
//  AppFeature
//
//  Created by Jeans Ruiz on 1/14/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

final class AppConfigurations {

  lazy var apiKey: String = {
    guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else {
      fatalError("ApiKey must not be empty in plist")
    }
    return apiKey
  }()

  lazy var apiBaseURL: URL = {
    guard let apiBaseString = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String else {
      fatalError("ApiBaseURL must not be empty in plist")
    }

    guard let apiBaseURL = URL(string: apiBaseString) else {
      fatalError("Could not convert \(apiBaseString) into a URL")
    }

    return apiBaseURL
  }()

  lazy var imagesBaseURL: String = {
    guard let imageBaseURL = Bundle.main.object(forInfoDictionaryKey: "IMAGE_BASE_URL") as? String else {
      fatalError("ApiBaseURL must not be empty in plist")
    }
    return imageBaseURL
  }()
}
