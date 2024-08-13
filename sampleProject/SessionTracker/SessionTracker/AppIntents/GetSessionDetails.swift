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
//LESSON 2 and 3
import AppIntents
import Foundation

struct GetSessionDetails: AppIntent {
  static var title: LocalizedStringResource = "Get Session Details"
  static var description =
    IntentDescription(
      "Provides complete details on a sessions, including the runtime and topics.",
      categoryName: "Discover")

  /**
  A sentence that describes the intent, incorporating parameters as a natural part of the sentence. The Shortcuts editor displays this sentence
  inline. Without the parameter summary, the Shortcuts editor displays the `trail` parameter as a separate row, making the intent harder to
  configure in a shortcut.
  */
  static var parameterSummary: some ParameterSummary {
    Summary("Get information on \(\.$session)")
  }

  /**
  The trail this intent gets information on. Either the individual provides this parameter when the intent runs, or it comes preconfigured
  in a shortcut.
  - Tag: parameter
  */
  @Parameter(title: "Session", description: "The session to get information on.")
  var session: SessionEntity

  @Dependency private var sessionManager: SessionDataManager

  /// - Tag: custom_response
  func perform() async throws -> some IntentResult & ReturnsValue<SessionEntity> & ProvidesDialog & ShowsSnippetView {
    guard let sessionData = sessionManager.session(with: session.id) else {
      throw SessionIntentError.sessionNotFound
    }

    /**
    You provide a custom view by conforming the return type of the `perform()` function to the `ShowsSnippetView` protocol.
    */
    let snippet = SessionSiriDetailView(session: sessionData)

    /**
    This intent displays a custom view that includes the trail conditions as part of the view. The dialog includes the trail conditions when
    the system can only read the response, but not display it. When the system can display the response, the dialog omits the trail
    conditions.
    */
    let dialog = IntentDialog(
      full: "The runtime reported for \(session.name) indicate: \(session.sessionDescription).",
      supporting: "Here's the information on the requested session.")

    return .result(value: session, dialog: dialog, view: snippet)
  }
}
