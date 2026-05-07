import Foundation

extension SwiftDataNoteRecord {
    convenience init(note: Note) {
        self.init(
            id: note.id,
            content: note.content,
            createdAt: note.createdAt,
            updatedAt: note.updatedAt
        )
    }

    func toDomain() -> Note {
        Note(
            id: id,
            content: content,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

    func apply(note: Note) {
        content = note.content
        createdAt = note.createdAt
        updatedAt = note.updatedAt
    }
}
