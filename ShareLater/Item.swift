//
//  Item.swift
//  ShareLater
//
//  Created by 樋田一幸 on 2026/05/07.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
