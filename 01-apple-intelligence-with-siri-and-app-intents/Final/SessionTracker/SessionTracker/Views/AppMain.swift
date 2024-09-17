/// Copyright (c) 2023 Kodeco Inc.
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
import CoreSpotlight

@main
struct AppMain: App {
  private var sessionManager: SessionDataManager
  private let sceneNavigationModel: NavigationModel

  init() {
    let sessionDataManager = SessionDataManager.shared
    sessionManager = sessionDataManager

    let navigationModel = NavigationModel.shared
    sceneNavigationModel = navigationModel

    /**
    Register important objects that are required as dependencies of an `AppIntent` or an `EntityQuery`.
    The system automatically sets the value of properties in the intent or entity query to these values when the property is annotated with
    `@Dependency`. Intents that launch the app in the background won't have associated UI scenes, so the app must register these values
    as soon as possible in code paths that don't assume visible UI, such as the `App` initialization.
    */
    AppDependencyManager.shared.add(dependency: sessionDataManager)
    AppDependencyManager.shared.add(dependency: navigationModel)

    /**
    Call `updateAppShortcutParameters` on `AppShortcutsProvider` so that the system updates the App Shortcut phrases with any changes to the app's intent parameters. The app needs to call this function during its launch, in addition to any time the parameter values for the shortcut phrases change.
    */

    Task {
      try await CSSearchableIndex
        .default()
        .indexAppEntities(sessionDataManager.sessions.map(SessionEntity.init(session:)))
    }
  }

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(sessionManager)
        .environment(sceneNavigationModel)
    }
  }
}
