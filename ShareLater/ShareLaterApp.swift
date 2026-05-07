//
//  ShareLaterApp.swift
//  ShareLater
//
//  Created by 樋田一幸 on 2026/05/07.
//

import SwiftUI
import SwiftData

@main
struct ShareLaterApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            SwiftDataNoteRecord.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
