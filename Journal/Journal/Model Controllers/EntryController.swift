//
//  ModelController.swift
//  Journal
//
//  Created by Cody Morley on 5/20/20.
//  Copyright © 2020 Cody Morley. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    //MARK: - Enums & Type Aliases -
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    enum NetworkError: Error {
        case noId
        case noData
        case badData
        case badResponse
        case noResponse
        case noEncode
        case noDecode
        case otherError
    }
    
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    
    
    //MARK: - Properties -
    private let baseURL: URL = URL(string: "https://journal-8ffed.firebaseio.com/")!
    private lazy var jsonDecoder = JSONDecoder()
    private lazy var jsonEncoder = JSONEncoder()
    
    //MARK: - Initializers -
    init() {
        fetchEntriesFromServer()
    }
    
    
    //MARK: - Actions -
    func sendEntryToServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let identifier = entry.identifier else {
            completion(.failure(.noId))
            return
        }
        
        let requestURL = baseURL.appendingPathComponent("\(identifier)").appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        do {
            let jsonEntry = try jsonEncoder.encode(entry.representation)
            request.httpBody = jsonEntry
        } catch {
            NSLog("Error encoding entry for transmission: \(error) \(error.localizedDescription)")
            completion(.failure(.noEncode))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                NSLog("Error. Failed saving to database: \(error) \(error.localizedDescription)")
                completion(.failure(.otherError))
                return
            }
            completion(.success(true))
        }.resume()
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let identifier = entry.identifier else {
            NSLog("Error deleting entry. No Entry ID.")
            completion(.failure(.noId))
            return
        }
        
        let requestURL = baseURL.appendingPathComponent("\(identifier)")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                NSLog("Error deleting entry from database: \(error) \(error.localizedDescription)")
                completion(.failure(.otherError))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                response.statusCode == 200 else {
                    NSLog("Error deleting entry from database. Bad response from host.")
                    completion(.failure(.badResponse))
                    return
            }
            completion(.success(true))
        }.resume()
    }
    
    func updateEntries(with representations: [EntryRepresentation]) {
        let entryFetchIDs = representations.compactMap { $0.identifier }
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(entryFetchIDs, representations))
        var entriesToCreate = representationsByID
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", entryFetchIDs)
        
        let context = CoreDataStack.shared.mainContext
        
        do {
            let existingEntries = try context.fetch(fetchRequest)
            for entry in existingEntries {
                guard let identifier = entry.identifier,
                    let representation = representationsByID[identifier] else {
                        continue
                }
                
                self.update(entry: entry, representation: representation)
                entriesToCreate.removeValue(forKey: identifier)
                
                for representation in entriesToCreate.values {
                    Entry(representation: representation, context: context)
                }
                
                try context.save()
            }
        } catch {
            NSLog("Error fetching entries from extrenal database: \(error) \(error.localizedDescription)")
        }
    }
    
    func fetchEntriesFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let fetchURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: fetchURL) { data, _, error in
            if let error = error {
                NSLog("Error fetching data: \(error) \(error.localizedDescription)")
                completion(.failure(.otherError))
                return
            }
            
            guard let data = data else {
                NSLog("Error fetching request: no data returned from firebase.")
                completion(.failure(.noData))
                return
            }
            
            do {
                let fetchedEntries = Array(try self.jsonDecoder.decode([String : EntryRepresentation].self, from: data).values)
                self.updateEntries(with: fetchedEntries)
                completion(.success(true))
            } catch {
                NSLog("Error decoding fetched entries: \(error) \(error.localizedDescription)")
                completion(.failure(.noDecode))
                return
            }
        }.resume()
    }
    
    
    //MARK: - Methods -
    private func update(entry: Entry, representation: EntryRepresentation) {
        entry.title = representation.title
        entry.bodyText = representation.bodyText
        entry.mood = representation.mood
        
    }
    
    
    
    
}
