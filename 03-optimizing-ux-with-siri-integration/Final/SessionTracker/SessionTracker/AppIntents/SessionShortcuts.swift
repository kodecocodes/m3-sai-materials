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

import Foundation
import AppIntents

/**
An `AppShortcut` wraps an intent to make it automatically discoverable throughout the system. An `AppShortcutsProvider` manages the shortcuts the app makes available. The app can update the available shortcuts by calling `updateAppShortcutParameters()` as needed.
*/
class SessionShortcuts: AppShortcutsProvider {
  /// The color the system uses to display the App Shortcuts in the Shortcuts app.
  static var shortcutTileColor = ShortcutTileColor.navy

  /**
  This sample app contains several examples of different intents, but only the intents this array describes make sense as App Shortcuts.
  Put the App Shortcut most people will use as the first item in the array. This first shortcut shouldn't bring the app to the foreground.

  Every phrase that people use to invoke an App Shortcut needs to contain the app name, using the `applicationName` placeholder in the provided
  phrase text, as well as any app name synonyms declared in the `INAlternativeAppNames` key of the app's `Info.plist` file. These phrases are localized in a string catalog named `AppShortcuts.xcstrings`.

  - Tag: open_favorites_app_shortcut
  */
  static var appShortcuts: [AppShortcut] {
    /// `GetSessionDetails` allows people to quickly check the details on their favorite sessions.
    AppShortcut(
      intent: GetSessionDetails(),
      phrases: [
        "Get details in \(.applicationName)"// ,
        // NOTE as of the betas, the parameter style phrase does not work yet. The above phrase will ask the user for a session to get details on
//        "Get \(\.$sessionToGet) details in \(.applicationName)",
//        "Get details for session named \(\.$sessionToGet) in \(.applicationName)"
      ],
      shortTitle: "Get Details",
      systemImageName: "cloud.rainbow.half",
      parameterPresentation: ParameterPresentation(
        for: \.$sessionToGet,
        summary: Summary("Get \(\.$sessionToGet) details")) {
          OptionsCollection(SessionEntityQuery(), title: "Favorite Sessions", systemImageName: "cloud.rainbow.half")
      }
    )

    AppShortcut(
      intent: OpenURLInTabIntent(),
      phrases: [
        "Open \(\.$session) details with \(.applicationName) in a browser",
        "Get details for \(\.$session) with \(.applicationName) in a browser"
      ],
      shortTitle: "Open in browser",
      systemImageName: "cloud.rainbow.half",
      parameterPresentation: ParameterPresentation(
        for: \.$session,
        summary: Summary("Open \(\.$session) details in a browser")) {
          OptionsCollection(SessionEntityQuery(), title: "Favorite Sessions", systemImageName: "cloud.rainbow.half")
      }
    )

    /// `OpenFavorites` brings the app to the foreground and displays the contents of the Favorites collection in the UI.
    AppShortcut(
      intent: OpenFavorites(),
      phrases: [
        "Open Favorites in \(.applicationName)",
        "Show my favorite \(.applicationName)"
      ],
      shortTitle: "Open Favorites",
      systemImageName: "star.circle"
    )
  }
}
