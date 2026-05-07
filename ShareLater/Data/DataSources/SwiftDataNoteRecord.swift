import Foundation
import SwiftData

@Model
final class SwiftDataNoteRecord {
    @Attribute(.unique) var id: Int64
    var content: String
    var createdAt: Date
    var updatedAt: Date

    init(id: Int64, content: String, createdAt: Date, updatedAt: Date) {
        self.id = id
        self.content = content
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
