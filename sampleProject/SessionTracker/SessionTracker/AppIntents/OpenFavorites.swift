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
 People are likely to visit the Favorites trail collection often, so this intent makes it quicker and more convenient to open the app to that content.
 
 - Tag: open_favorites_intent
 */
struct OpenFavorites: AppIntent {
    
    /// Every intent needs to include metadata, such as a localized title. The title of the intent is displayed throughout the system.
    static var title: LocalizedStringResource = "Open Favorite Sessions"

    /// An intent can optionally provide a localized description that the Shortcuts app displays.
    static var description = IntentDescription("Opens the app and goes to your favorite sessions.")
    
    /// Tell the system to bring the app to the foreground when the intent runs.
    static var openAppWhenRun: Bool = true
    
    /**
     When the system runs the intent, it calls `perform()`.
     
     Intents run on an arbitrary queue. Intents that manipulate UI need to annotate `perform()` with `@MainActor`
     so that the UI operations run on the main actor.
     */
    @MainActor
    func perform() async throws -> some IntentResult {
        navigationModel.selectedCollection = sessionManager.favoritesCollection
        
        /// Return an empty result, indicating that the intent is complete.
        return .result()
    }
    
    /**
     The app uses the navigation model to update the UI to the individual's favorite trail.
     The `@Dependency` property wrapper sets up the specific navigation model to use, which the app provides
     during its launch. See `AppIntentsSampleApp` to observe where the app creates the dependency.
     */
    @Dependency
    private var navigationModel: NavigationModel
    
    @Dependency
    private var sessionManager: SessionDataManager
}
