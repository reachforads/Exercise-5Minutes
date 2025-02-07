//
//  Item.swift
//  Exercise-5Minutes
//
//  Created by manohara shankar on 2/2/25.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
