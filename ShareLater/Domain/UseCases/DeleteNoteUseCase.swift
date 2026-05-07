@MainActor
struct DeleteNoteUseCase {
    private let repository: NoteRepository

    init(repository: NoteRepository) {
        self.repository = repository
    }

    func execute(note: Note) throws {
        try repository.delete(note)
    }
}
