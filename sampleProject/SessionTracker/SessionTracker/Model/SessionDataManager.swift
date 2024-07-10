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
import Observation

@Observable class SessionDataManager: @unchecked Sendable {
    
    static let shared = SessionDataManager()

    /// An array of all the trails in the app.
    let sessions: [Session]
    
    /// An array of trail collections containing the featured trail groups, representing a section in `SidebarColumn`.
    let featuredSessionCollections: [SessionCollection]
    
    /// The trail collections in the For You group of `SidebarColumn`, including favorite trails and those close to the individual.
    let forYouCollections: [SessionCollection]
    
    /// A trail collection containing the individual's favorite trails.
    let favoritesCollection: SessionCollection
    
    /// A trail collection containing all of the trails in the `trails` property.
    let completeSessionCollection: SessionCollection
    
    private init() {
        guard let dataURL = Bundle.main.url(forResource: "SessionData", withExtension: "plist") else {
            fatalError("Could not locate data file.")
        }
        
        var dataContainer: DataContainer!
        do {
            let data = try Data(contentsOf: dataURL)
            let decoder = PropertyListDecoder()
            dataContainer = try decoder.decode(DataContainer.self, from: data)
        } catch let error {
            fatalError("Could not decode data. Error: \(error)")
        }
                
        let configuredSessions = dataContainer.sessions.map { sessionDetails in
            return Session(data: sessionDetails)
        }
        
        let completeSessionList = SessionCollection(id: 2,
                                                collectionType: .browseSessions,
                                                displayName: "Browse",
                                                symbolName: "figure.hiking",
                                                members: configuredSessions.map { $0.id })
        
        
        let favorites = dataContainer.collections.first(where: { $0.collectionType == .favorites })!
        forYouCollections = [favorites, completeSessionList]
        
        favoritesCollection = favorites
        completeSessionCollection = completeSessionList
        
        sessions = configuredSessions
        featuredSessionCollections = dataContainer.collections.filter { $0.collectionType == .featured }
    }
}

/// This extension contains the public query API to find specific trails.
extension SessionDataManager {
    
    /// - Returns: The `Session` with `identifier`, or `nil` if no match is found.
    func session(with identifier: Session.ID) -> Session? {
        return sessions.first { $0.id == identifier }
    }
    
    /// - Returns: An array of `Session` structures with the requested `identifiers`.
    func sessions(with identifiers: [Session.ID]) -> [Session] {
        return sessions.compactMap { session in
            return identifiers.contains(session.id) ? session : nil
        }
    }
    
    /// - Returns: An array of `Session` structures that the `predicate` closure returns.
    func sessions(matching predicate: (Session) -> Bool) -> [Session] {
        return sessions.filter(predicate)
    }
}
