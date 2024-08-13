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

import AppIntents //LESSON 2
import Foundation

/// Represents a group of trails, such as Favorites, or those located in the same geographic region.
struct SessionCollection: Identifiable, Sendable {
  enum CollectionType: Int, Hashable, Codable, Sendable {
    case favorites = 0
    case browseSessions = 1
    case featured = 2
  }

  /// The collection's stable identifier.
  let id: Int

  /// What the collection represents, for UI purposes.
  let collectionType: CollectionType

  /// The name of the collection to display in the UI.
  @Property(title: "Name") //LESSON 2
  var displayName: String

  /// A symbol to use with the collection in the UI.
  let symbolName: String

  /// The trail IDs that belong to this collection.
  let members: [Session.ID]

  init(id: Int, collectionType: CollectionType, displayName: String, symbolName: String, members: [Session.ID]) {
    self.id = id
    self.collectionType = collectionType
    self.symbolName = symbolName
    self.members = members
    self.displayName = displayName
  }
}

//LESSON 2
/// This structure conforms to `AppEntity`, so this type is available to people and to the system through App Intents.
extension SessionCollection: AppEntity {
  /// Provide the system with the interface required to query `TrailCollection` structures.
  static var defaultQuery = FeaturedCollectionEntityQuery()

  /**
  A localized name representing this entity as a concept people are familiar with in the app, including
  localized variations based on the plural rules the app defines in `AppIntents.stringsdict`, referenced here
  through the `table` parameter. The system may display this value to people when they configure an intent.
  */
  static var typeDisplayRepresentation: TypeDisplayRepresentation {
    TypeDisplayRepresentation(
      name: LocalizedStringResource("Featured Session Collection", table: "AppIntents"),
      numericFormat: LocalizedStringResource("\(placeholder: .int) featured session collections", table: "AppIntents")
    )
  }

  /// Information on how to display the entity to people.
  var displayRepresentation: DisplayRepresentation {
    DisplayRepresentation(
      title: "\(displayName)",
      image: DisplayRepresentation.Image(systemName: symbolName))
  }
}

extension SessionCollection: Decodable {
  private enum CodingKeys: CodingKey {
    case id
    case collectionType
    case displayName
    case symbolName
    case members
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    id = try values.decode(Int.self, forKey: .id)
    collectionType = try values.decode(CollectionType.self, forKey: .collectionType)
    symbolName = try values.decode(String.self, forKey: .symbolName)
    members = try values.decode([Int].self, forKey: .members)
    displayName = try values.decode(String.self, forKey: .displayName)
  }
}

extension SessionCollection: Hashable {
  static func == (lhs: SessionCollection, rhs: SessionCollection) -> Bool {
    lhs.id == rhs.id
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}
