//
//  CreateEntryViewController.swift
//  Journal
//
//  Created by Cody Morley on 5/18/20.
//  Copyright © 2020 Cody Morley. All rights reserved.
//

import UIKit

class CreateEntryViewController: UIViewController {
    //MARK: - Properties -
    /// Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    @IBOutlet weak var bodyTextView: UITextView!
    
    var entryController: EntryController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //MARK: - Actions -
    @IBAction func cancel(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty else { return }
        
        let body = bodyTextView.text
        let moodIndex = moodSegmentedControl.selectedSegmentIndex
        let mood = Mood.allCases[moodIndex]
        
        let entry = Entry(title: title,
                          bodyText: body,
                          mood: mood)
        
        entryController?.sendEntryToServer(entry: entry)
        do {
            try CoreDataStack.shared.mainContext.save()
            navigationController?.dismiss(animated: true, completion: nil)
        } catch {
            NSLog("Error saving managed object context, entry was note saved: \(error) \(error.localizedDescription)")
        }
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
