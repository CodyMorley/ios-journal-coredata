//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Cody Morley on 5/18/20.
//  Copyright © 2020 Cody Morley. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    
    
    //MARK: - Convenience Inits -
    @discardableResult convenience init(title: String,
                                        bodyText: String? = nil,
                                        timeStamp: Date = Date(),
                                        identifier: String,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timeStamp = timeStamp
        self.identifier = identifier
        
    }
    
}
