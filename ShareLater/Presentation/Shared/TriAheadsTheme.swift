import SwiftUI

enum TriAheadsTheme {
    static let appBar = Color(red: 0.259, green: 0.647, blue: 0.961)
    static let fab = Color(red: 0.012, green: 0.855, blue: 0.773)
    static let surface = Color.white
    static let overlay = Color.white.opacity(0.5)

    static func agedTextColor(createdAt: Date, now: Date = Date()) -> Color {
        let age = Calendar.current.dateComponents([.day], from: createdAt, to: now).day ?? 0
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
