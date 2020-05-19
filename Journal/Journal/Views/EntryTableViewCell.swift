//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Cody Morley on 5/18/20.
//  Copyright © 2020 Cody Morley. All rights reserved.
//

import UIKit
import CoreData

class EntryTableViewCell: UITableViewCell {
    //MARK: - Properties -
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var bodyTextPreviewLabel: UILabel!
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }

    
    
    
    
    //MARK: - Mathods -
    private func updateViews() {
        guard let entry = entry else { return }
        
        titleLabel.text = entry.title
        dateTimeLabel.text = entry.timeStamp?.description
        bodyTextPreviewLabel.text = entry.bodyText
    }

}
