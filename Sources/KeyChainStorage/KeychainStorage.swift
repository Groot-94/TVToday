//
//  KeychainStorage.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/21/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

public protocol KeychainStorage {

  // MARK: - Request Token
  func saveRequestToken(_ token: String)

  func fetchRequestToken() -> String?

  // MARK: - Access Token
  func saveAccessToken(_ token: String)

  func fetchAccessToken() -> String?

  // MARK: - Currently User
  func saveLoguedUser(_ accountId: Int, _ sessionId: String)

  func fetchLoguedUser() -> AccountKStorage?

  func deleteLoguedUser()
}
