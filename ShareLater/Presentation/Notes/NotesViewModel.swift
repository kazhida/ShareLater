import Combine
import Foundation

@MainActor
final class NotesViewModel: ObservableObject {
    @Published private(set) var notes: [Note] = []
    @Published var errorMessage: String?

    private let fetchNotesUseCase: FetchNotesUseCase
    private let addNoteUseCase: AddNoteUseCase
    private let updateNoteUseCase: UpdateNoteUseCase
    private let deleteNoteUseCase: DeleteNoteUseCase

    init(repository: NoteRepository) {
        fetchNotesUseCase = FetchNotesUseCase(repository: repository)
        addNoteUseCase = AddNoteUseCase(repository: repository)
        updateNoteUseCase = UpdateNoteUseCase(repository: repository)
        deleteNoteUseCase = DeleteNoteUseCase(repository: repository)
        refresh()
    }

    func refresh() {
        do {
            notes = try fetchNotesUseCase.execute()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func addNote(content: String) {
        do {
            try addNoteUseCase.execute(content: content)
            refresh()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func update(note: Note, content: String) {
        do {
            try updateNoteUseCase.execute(note: note, content: content)
            refresh()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func delete(note: Note) {
        do {
            try deleteNoteUseCase.execute(note: note)
            refresh()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
