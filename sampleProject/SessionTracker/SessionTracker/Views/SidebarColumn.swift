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

/// The sidebar column for the app, containing user info, trail collections, and a view that opens the Shortcuts app.
struct SidebarColumn: View {
    
    @Environment(SessionDataManager.self) private var sessionManager
    @Environment(NavigationModel.self) private var navigationModel
    
    var body: some View {
        @Bindable var navigationModel = navigationModel
        List(selection: $navigationModel.selectedCollection) {
        
            Section("For You") {
                ForEach(sessionManager.forYouCollections) { collection in
                    NavigationLink(value: collection) {
                        Label(collection.displayName, systemImage: collection.symbolName)
                    }
                }
            }
            Section("Featured Sessions") {
                ForEach(sessionManager.featuredSessionCollections) { collection in
                    NavigationLink(value: collection) {
                        Label(collection.displayName, systemImage: collection.symbolName)
                    }
                }
            }
            HStack {
                Spacer()
                
                /// `ShortcutsLink` opens this app's page in the Shortcuts app, so the user can see all of the App Shortcuts provided by the app.
                ShortcutsLink()
                    .shortcutsLinkStyle(.automatic)
                
                Spacer()
            }
        }
        .navigationTitle("Session Collections")
    }
}
