import Foundation
import SwiftData

@MainActor
final class NoteLocalDataSource {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func fetchAll() throws -> [SwiftDataNoteRecord] {
        let descriptor = FetchDescriptor<SwiftDataNoteRecord>(
            sortBy: [SortDescriptor(\.updatedAt, order: .reverse)]
        )
        return try modelContext.fetch(descriptor)
    }

    func insert(_ record: SwiftDataNoteRecord) throws {
        modelContext.insert(record)
        try modelContext.save()
    }

    func update(_ note: Note) throws {
        let existingRecord = try find(id: note.id)
        existingRecord?.apply(note: note)
        try modelContext.save()
    }

    func delete(id: Int64) throws {
        if let record = try find(id: id) {
            modelContext.delete(record)
            try modelContext.save()
        }
    }

    private func find(id: Int64) throws -> SwiftDataNoteRecord? {
        var descriptor = FetchDescriptor<SwiftDataNoteRecord>(
            predicate: #Predicate { $0.id == id }
        )
        descriptor.fetchLimit = 1
        return try modelContext.fetch(descriptor).first
    }
}
