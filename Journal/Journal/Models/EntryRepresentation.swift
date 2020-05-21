//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Cody Morley on 5/20/20.
//  Copyright © 2020 Cody Morley. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    enum CodingKeys: String, CodingKey {
        case title
        case bodyText
        case mood
        case timeStamp
        case identifier
    }
    
    var title: String
    var bodyText: String?
    var mood: String
    var timeStamp: Date
    var identifier: String
}
