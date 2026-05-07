@MainActor
struct FetchNotesUseCase {
    private let repository: NoteRepository

    init(repository: NoteRepository) {
        self.repository = repository
    }

    func execute() throws -> [Note] {
        try repository.fetchAllNotes()
    }
}
