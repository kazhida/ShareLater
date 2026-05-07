import Foundation

struct Note: Identifiable, Equatable, Hashable {
    let id: Int64
    var content: String
    let createdAt: Date
    var updatedAt: Date

    init(
        id: Int64 = NoteIDGenerator.next(),
        content: String,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.content = content
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

enum NoteIDGenerator {
    static func next(date: Date = Date()) -> Int64 {
        let milliseconds = Int64(date.timeIntervalSince1970 * 1_000)
        return milliseconds * 1_000 + Int64.random(in: 0..<1_000)
    }
}
