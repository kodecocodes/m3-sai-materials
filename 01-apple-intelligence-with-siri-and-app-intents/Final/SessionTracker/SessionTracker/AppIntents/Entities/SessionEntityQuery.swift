/// Copyright (c) 2024 Kodeco Inc.
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import AppIntents
import Foundation

/**
An `EntityQuery` provides the basis for working with the app's custom types through the `AppEntity` protocol, allowing
the system to query the app for entities by identifier and allowing the app to return a list of the most common entities.
*/
struct SessionEntityQuery: EntityQuery {
  @Dependency var sessionManager: SessionDataManager

  /**
  All entity queries need to locate specific entities through their unique ID. When someone creates a shortcut and populates fields with
  specific values, the system stores and looks up the values through their unique identifiers.

  - Tag: query_by_id
  */
  func entities(for identifiers: [SessionEntity.ID]) async throws -> [SessionEntity] {
    return sessionManager.sessions(with: identifiers)
      .map { SessionEntity(session: $0) }
  }
}

/// An `EntityStringQuery` extends the capability of an `EntityQuery` by allowing people to search for an entity with a string.
extension SessionEntityQuery: EntityStringQuery {
  /**
  To see this method, configure the Get Session Details intent in the Shortcuts app. A list displays the suggested entities.
  If you search for an entity not in the suggested entities list, the system passes the search string to this method.

  - Tag: string_query
  */
  func entities(matching string: String) async throws -> [SessionEntity] {
    return sessionManager
      .sessions { session in
        session.name.localizedCaseInsensitiveContains(string)
      }
      .map { SessionEntity(session: $0) }
  }
}
