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

import SwiftUI
import AppIntents

struct SessionList : View {
  
  @Environment(SessionDataManager.self) private var sessionManager
  @Environment(NavigationModel.self) private var navigationModel
  
  /// A binding to a user preference indicating whether they hid the Siri tip.
  @AppStorage("displaySiriTip") private var displaySiriTip: Bool = true
  
  @MainActor
  private var filteredSessions: [Session] {
      let searchText = navigationModel.searchText
      guard !searchText.isEmpty else {
        return sessionManager.sessions
      }

      return sessionManager.sessions.filter {
          $0.name.lowercased().contains(searchText.lowercased())
      }
  }
  
  /// - Tag: siri_tip
  var body: some View {
      ZStack {
          if let sessionCollection = navigationModel.selectedCollection {
              @Bindable var navigationModel = navigationModel
              List(selection: $navigationModel.selectedSession) {
              #if os(iOS) || os(visionOS)
                  if sessionCollection.collectionType == .favorites {
                      /**
                       `SiriTipView` pairs with an intent the system uses as an App Shortcut. It provides a small view with the phrase from the
                       App Shortcut so that people learn they can view their favorite trails quickly by speaking the phrase to Siri with no
                       additional setup. The `isVisible` parameter is optional but recommended, to enable people to hide the view if they wish.
                       */
                      SiriTipView(intent: OpenFavorites(), isVisible: $displaySiriTip)
                  }
              #endif
                  
                  ForEach(sessionManager.sessions(with: sessionCollection.members)) { session in
                      NavigationLink(session.name, value: session)
                  }
              }
              .navigationTitle(sessionCollection.displayName)
              .searchable(text: $navigationModel.searchText)
          } else {
              ContentUnavailableView("Select a Session Collection",
                                     systemImage: "shoeprints.fill",
                                     description: Text("Pick something from the list."))
          }
      }
  }
  
}
