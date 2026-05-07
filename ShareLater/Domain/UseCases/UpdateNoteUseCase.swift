import Foundation

@MainActor
struct UpdateNoteUseCase {
    private let repository: NoteRepository

    init(repository: NoteRepository) {
        self.repository = repository
    }

    func execute(note: Note, content: String) throws {
        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedContent.isEmpty else { return }

        var updatedNote = note
        updatedNote.content = trimmedContent
        updatedNote.updatedAt = Date()
        try repository.update(updatedNote)
    }
}
