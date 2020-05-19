//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Cody Morley on 5/18/20.
//  Copyright © 2020 Cody Morley. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case happy = "😁"
    case sad = "😞"
    case fck = "🤬"
}

extension Entry {
    
    
    //MARK: - Convenience Inits -
    @discardableResult convenience init(title: String,
                                        bodyText: String? = nil,
                                        mood: Mood = .happy,
                                        timeStamp: Date = Date(),
                                        identifier: String = UUID().uuidString,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.mood = mood.rawValue
        self.timeStamp = timeStamp
        self.identifier = identifier
        
    }
    
}
