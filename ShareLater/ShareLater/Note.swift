//
//  Note.swift
//  ShareLater
//
//  Created by Codex on 2026/05/07.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class Note {
    var content: String
    var createdAt: Date
    var updatedAt: Date

    init(content: String = "", createdAt: Date = Date(), updatedAt: Date = Date()) {
        self.content = content
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

extension Note {
    var agedContentColor: Color {
        let age = Date().timeIntervalSince(createdAt) / 86_400

        switch age {
        case ..<1:
            return .black
        case ..<2:
            return .black.opacity(0.8)
        case ..<7:
            return .black.opacity(0.5)
        case ..<30:
            return .black.opacity(0.3)
        default:
            return .black.opacity(0.2)
        }
    }
}
