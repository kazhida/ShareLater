//
//  ContentView.swift
//  ShareLater
//
//  Created by 樋田一幸 on 2026/05/07.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: NotesViewModel?

    var body: some View {
        Group {
            if let viewModel {
                NoteListView(viewModel: viewModel)
            } else {
                ProgressView()
            }
        }
        .onAppear {
            if viewModel == nil {
                viewModel = NotesViewModelFactory.make(modelContext: modelContext)
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: SwiftDataNoteRecord.self, inMemory: true)
}
