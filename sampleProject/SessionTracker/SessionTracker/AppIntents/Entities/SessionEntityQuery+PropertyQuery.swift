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
An `EntityPropertyQuery` queries entities by matching values against one or more of their properties. Conforming an entity query to
`EntityPropertyQuery` automatically adds a Find intent to the list of intents in the Shortcuts app, providing UI to build complex predicates beyond
the capabilities of `EntityStringQuery`.
*/
extension SessionEntityQuery: EntityPropertyQuery {
  /**
  The type of the comparator to use for the property query. This sample uses `Predicate`, but other apps could use `NSPredicate` (for
  Core Data) or an entirely custom comparator that works with an existing data model.
  */
  typealias ComparatorMappingType = Predicate<SessionEntity>

  /**
  Declare the entity properties that are available for queries and in the Find intent, along with the comparator the app uses when querying the
  property.
  */
  static var properties = QueryProperties {
    Property(\SessionEntity.$name) {
      ContainsComparator { searchValue in
        #Predicate<SessionEntity> { $0.name.contains(searchValue) }
      }
      EqualToComparator { searchValue in
        #Predicate<SessionEntity> { $0.name == searchValue }
      }
      NotEqualToComparator { searchValue in
        #Predicate<SessionEntity> { $0.name != searchValue }
      }
    }
  }

  /// Declare the entity properties available as sort criteria in the Find intent.
  static var sortingOptions = SortingOptions {
    SortableBy(\SessionEntity.$name)
  }

  /// The text that people see in the Shortcuts app, describing what this intent does.
  static var findIntentDescription: IntentDescription? {
    IntentDescription(
      "Search for the best sessions matching your interest based on complex criteria.",
      categoryName: "Discover",
      searchKeywords: ["session", "video"],
      resultValueName: "Sessions")
  }

  /// Performs the Find intent using the predicates that the individual enters in the Shortcuts app.
  func entities(
    matching comparators: [Predicate<SessionEntity>],
    mode: ComparatorMode,
    sortedBy: [EntityQuerySort<SessionEntity>],
    limit: Int?) async throws -> [SessionEntity] {
    /// Get the trail entities that meet the criteria of the comparators.
    var matchedSessions = try sessions(matching: comparators, mode: mode)

    /**
    Apply the requested sort. `EntityQuerySort` specifies the value to sort by using a `PartialKeyPath`. This key path builds a
    `KeyPathComparator` to use default sorting implementations for the value that the key path provides. For example, this approach uses
    `SortComparator.localizedStandard` when sorting key paths with a `String` value.
    */
    for sortOperation in sortedBy {
      switch sortOperation.by {
      case \.$name:
        matchedSessions.sort(using: KeyPathComparator(\SessionEntity.name, order: sortOperation.order.sortOrder))
      default:
        break
      }
    }

    /**
    People can optionally customize a limit to the number of results that a query returns.
    If your data model supports query limits, you can also use the limit parameter when querying
    your data model, to allow for faster searches.
    */
    if let limit, matchedSessions.count > limit {
      matchedSessions.removeLast(matchedSessions.count - limit)
    }

    return matchedSessions
  }

  /// - Returns: The trail entities that meet the criteria of `comparators` and `mode`.
  private func sessions(matching comparators: [Predicate<SessionEntity>], mode: ComparatorMode) throws -> [SessionEntity] {
    try sessionManager.sessions.compactMap { session in
      let entity = SessionEntity(session: session)

      /**
      For an AND search (criteria1 AND criteria2 AND ...), this variable starts as `true`.
      If any of the comparators don't match, the app sets it to `false`, allowing the comparator loop to break early because a comparator
      doesn't satisfy the AND requirement.

      For an OR search (criteria1 OR criteria2 OR ...), this variable starts as `false`.
      If any of the comparators match, the app sets it to `true`, allowing the comparator loop to break early because any comparator that
      matches satisfies the OR requirement.
      */
      var includeAsResult = mode == .and ? true : false
      let earlyBreakCondition = includeAsResult
      for comparator in comparators {
        guard includeAsResult == earlyBreakCondition else {
          break
        }

        /// Runs the `Predicate` expression with the specific `TrailEntity` to determine whether the entity matches the conditions.
        includeAsResult = try comparator.evaluate(entity)
      }

      return includeAsResult ? entity : nil
    }
  }
}

extension EntityQuerySort.Ordering {
  /// Convert sort information from `EntityQuerySort` to  Foundation's `SortOrder`.
  var sortOrder: SortOrder {
    switch self {
    case .ascending:
      return SortOrder.forward
    case .descending:
      return SortOrder.reverse
    }
  }
}
