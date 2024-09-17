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
import CoreTransferable
import UIKit

/**
Through its conformance to `AppEntity`, `SessionEntity` represents `Session` instances in an intent, such as a parameter.

This sample implements a separate structure for `AppEntity` rather than adding conformance to the `Session` structure. When deciding whether to
conform an existing structure in an app to `AppEntity`, or to create a separate structure instead, consider the data that the intent uses, and
tailor the structure to contain the minimum data required. For example, `Session` declares a separate `recentImages` property that none of the
intents need. Because this property may be sizable or expensive to retrieve, the system omits this property from the definition of `SessionEntity`.
*/
@AssistantEntity(schema: .browser.tab)
struct SessionEntity: AppEntity, IndexedEntity {
  /**
  A localized name representing this entity as a concept people are familiar with in the app, including
  localized variations based on the plural rules defined in the app's `.stringsdict` file (referenced
  through the `table` parameter). The app may show this value to people when they configure an intent.
  */
  static var typeDisplayRepresentation: TypeDisplayRepresentation {
    TypeDisplayRepresentation(
      name: LocalizedStringResource("Session", table: "AppIntents"),
      numericFormat: LocalizedStringResource("\(placeholder: .int) sessions", table: "AppIntents")
    )
  }

  /**
  Provide the system with the interface required to query `SessionEntity` structures.
  - Tag: default_query
  */
  static var defaultQuery = SessionEntityQuery()

  /// The `AppEntity` identifier must be unique and persistant, as people may save it in a shortcut.
  var id: Session.ID

  /**
  The sessions's name. The `EntityProperty` property wrapper makes this property's data available to the system as part of the intent,
  such as when an intent returns a session in a shortcut.
  - Tag: entity_property
  */
  @Property var name: String

  /**
  The name of the featured image. Since people can't query for the image name in this app's intents, it isn't declared as an `EntityProperty` with
  `@Property`. `displayRepresentation` uses the value of this property.
  */
  var imageName: String

  /// A description of the session
  @Property(title: "Session Description")
  var sessionDescription: String?

  /// A description of the session
  @Property(title: "Session Length")
  var sessionLength: String?

  var url: URL?

  var isPrivate: Bool

  /**
  Information on how to display the entity to people — for example, a string like the session name. Include the optional subtitle
  and image for a visually rich display.
  */

  var displayRepresentation: DisplayRepresentation {
    return DisplayRepresentation(
      title: "\(name)",
      subtitle: "\(sessionDescription ?? "No description")",
      image: DisplayRepresentation.Image(named: imageName))
  }

  init(session: Session) {
    self.id = session.id
    self.imageName = session.featuredImage
    self.name = session.name
    self.sessionDescription = session.sessionDescription
    self.sessionLength = session.sessionLength
    self.url = session.url
  }
}

extension SessionEntity: Transferable {
  func toString() -> String {
    return "\(self.name) (\(self.sessionLength ?? "No Length"): \(self.sessionDescription ?? "No Description"))"
  }

  func sessionAsJSON() async -> Data? {
    var json: [String: String] = [:]
    json["id"] = "\(self.id)"
    json["name"] = self.name
    json["imageName"] = self.imageName
    json["sessionDescription"] = self.sessionDescription
    json["sessionLength"] = self.sessionLength
    json["url"] = self.url?.absoluteString
    do {
      return try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
    } catch let myJSONError {
      print(myJSONError)
    }
    return nil
  }

  func sessionAsJPEG() async -> SentTransferredFile? {
    var transferredFile: SentTransferredFile?
    let size = CGSize(width: 300, height: 500)
    let frame = CGRect(origin: .zero, size: size)
    let image = UIGraphicsImageRenderer(size: size).image { rendererContext in
      UIColor.systemGray.setFill()
      rendererContext.fill(CGRect(origin: .zero, size: size))
      toString().draw(in: frame)
    }

    if let data = image.jpegData(compressionQuality: 0.4) {
      let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
      let file = path.appendingPathComponent("session.jpg")
      try? data.write(to: file)
      transferredFile = SentTransferredFile(file)
    }
    return transferredFile
  }

  static var transferRepresentation: some TransferRepresentation {
    DataRepresentation(exportedContentType: .json) { sessionEntity in
      guard let sessionData = await sessionEntity.sessionAsJSON() else { throw TransferrableError.invalidJSON
      }
      return sessionData
    }

    FileRepresentation(exportedContentType: .jpeg) { sessionEntity in
      guard let sessionJPEG = await sessionEntity.sessionAsJPEG() else { throw TransferrableError.noFileFound
      }
      return sessionJPEG
    }
  }
}

enum TransferrableError: Error {
  case noFileFound
  case invalidJSON
}
