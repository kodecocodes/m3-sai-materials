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
 Represents the fixed properties from `TrailData`, such as the trail name and length, but also properties that vary based on the individual,
 such as their distance to the trail.
 */
struct Session: Identifiable, Hashable, Sendable {
  /// The trail's stable identifier.
  let id: Int
  
  /// The session's name.
  let name: String
  
  /// The resource name of an image for the session.
  let featuredImage: String
  
  /// A description of the session
  let sessionDescription: String
  
  /// A description of the session
  let sessionLength: String
  
  var viewed: Bool
  
  init(data: SessionData) {
    id = data.id
    name = data.name
    featuredImage = data.imageName
    sessionDescription = data.sessionDescription
    sessionLength = data.sessionLength
    viewed = data.viewed
    
  }
  
  static func == (lhs: Session, rhs: Session) -> Bool {
    lhs.id == rhs.id
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}

/// A type representing the fixed properties of a trail, such as its name and length, when you load them from one of the sample project files.
struct SessionData: Identifiable, Decodable {
  let id: Int
  let name: String
  let sessionDescription: String
  let sessionLength: String
  let imageName: String
  let viewed: Bool
}

/// A structure containing all of the sample data, to facilitate loading it into the app.
struct DataContainer: Decodable {
  let collections: [SessionCollection]
  let sessions: [SessionData]
}
