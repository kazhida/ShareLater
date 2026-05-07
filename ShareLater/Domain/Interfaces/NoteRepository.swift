import Foundation

@MainActor
protocol NoteRepository {
    func fetchAllNotes() throws -> [Note]
    func insert(_ note: Note) throws
    func update(_ note: Note) throws
    func delete(_ note: Note) throws
}
