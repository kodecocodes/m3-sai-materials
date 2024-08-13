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
import OSLog
//LESSON 2
/**
`FeaturedCollectionEntityQuery` allows people to query the app for trail collections through a Find intent in the Shortcuts app,
automatically providing filtering options based on the entity's properties — without the complexity of an `EntityPropertyQuery.`
In this sample, the featured trail collections is a fixed list, and `TrailCollection` only has a small number of properties, making
it a good choice for this query API. Large data sets, or entity types that require more memory, should use `EntityPropertyQuery`.

`SuggestSessions` takes the output of the Find intent that this query creates, and uses it as an input.
*/
struct FeaturedCollectionEntityQuery: EnumerableEntityQuery {
  /// The text describing what this intent does, which the system displays to people in the Shortcuts app.
  static var findIntentDescription: IntentDescription? {
    IntentDescription(
      "Find a featured session collection.",
      categoryName: "Discover",
      searchKeywords: ["session", "video"],
      resultValueName: "Sessionss")
  }

  @Dependency private var sessionManager: SessionDataManager

  /**
  All entity queries need to locate specific entities through their unique ID. When someone creates a shortcut and populates fields with
  specific values, the system stores and looks up the values through their unique identifiers.
  */
  func entities(for identifiers: [SessionCollection.ID]) async throws -> [SessionCollection] {
    return sessionManager.featuredSessionCollections
      .filter { identifiers.contains($0.id) }
  }

  /// - Returns: The most likely choices relevant to an individual.
  func suggestedEntities() async throws -> [SessionCollection] {
    // This example only returns a small number of suggestions to represent the most relevant choices to the individual.
    var result = sessionManager.featuredSessionCollections
    result.removeFirst(7)
    return result
  }

  /**
  The complete collection of entities this query applies to.

  - Tag: enumerable_query
  */
  func allEntities() async throws -> [SessionCollection] {
    return sessionManager.featuredSessionCollections
  }
}
