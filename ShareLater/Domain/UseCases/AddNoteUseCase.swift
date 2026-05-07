import Foundation

@MainActor
struct AddNoteUseCase {
    private let repository: NoteRepository

    init(repository: NoteRepository) {
        self.repository = repository
    }

    func execute(content: String) throws {
        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedContent.isEmpty else { return }

        try repository.insert(Note(content: trimmedContent))
    }
}
