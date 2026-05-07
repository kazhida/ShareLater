import Foundation

@MainActor
final class NoteRepositoryImpl: NoteRepository {
    private let localDataSource: NoteLocalDataSource

    init(localDataSource: NoteLocalDataSource) {
        self.localDataSource = localDataSource
    }

    func fetchAllNotes() throws -> [Note] {
        try localDataSource.fetchAll().map { $0.toDomain() }
    }

    func insert(_ note: Note) throws {
        try localDataSource.insert(SwiftDataNoteRecord(note: note))
    }

    func update(_ note: Note) throws {
        try localDataSource.update(note)
    }

    func delete(_ note: Note) throws {
        try localDataSource.delete(id: note.id)
    }
}
