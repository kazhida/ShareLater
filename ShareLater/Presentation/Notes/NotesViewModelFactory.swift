import SwiftData

@MainActor
enum NotesViewModelFactory {
    static func make(modelContext: ModelContext) -> NotesViewModel {
        let dataSource = NoteLocalDataSource(modelContext: modelContext)
        let repository = NoteRepositoryImpl(localDataSource: dataSource)
        return NotesViewModel(repository: repository)
    }
}
