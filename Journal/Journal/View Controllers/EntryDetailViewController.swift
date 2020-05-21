//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Cody Morley on 5/20/20.
//  Copyright © 2020 Cody Morley. All rights reserved.
//

import UIKit
import CoreData

class EntryDetailViewController: UIViewController {
    //MARK: - Properties -
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    @IBOutlet weak var bodyTextView: UITextView!
    
    var entry: Entry?
    var wasEdited: Bool = false
    
    //MARK: - Life Cycles -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = editButtonItem
        updateViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if wasEdited {
            updateEntry()
        }
    }
    

    /*›
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    //MARK: - Methods -
    private func updateViews() {
        guard let entry = entry else { return }
        
        guard let moodString = entry.mood,
            let mood = Mood(rawValue: moodString),
            let moodIndex = Mood.allCases.firstIndex(of: mood)
            else { return }
        
        
        titleTextField.text = entry.title
        moodSegmentedControl.selectedSegmentIndex = moodIndex
        bodyTextView.text = entry.bodyText
        
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing {
            wasEdited = editing
        }
        titleTextField.isUserInteractionEnabled = editing
        bodyTextView.isUserInteractionEnabled = editing
        moodSegmentedControl.isUserInteractionEnabled = editing
        navigationItem.hidesBackButton = editing
    }
    
    private func updateEntry() {
        guard let entry = self.entry,
            let title = titleTextField.text,
            !title.isEmpty,
            let body = bodyTextView.text else { return }
        let mood = Mood.allCases[moodSegmentedControl.selectedSegmentIndex].rawValue
        
        entry.title = title
        entry.mood = mood
        entry.bodyText = body
    }

}
