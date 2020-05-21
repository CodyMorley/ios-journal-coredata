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
        let entryFetchIDs = representations.compactMap {}
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
    }
    
    
    //MARK: - Methods -
    private func update(entry: Entry, representation: EntryRepresentation) {
        entry.title = representation.title
        entry.bodyText = representation.bodyText
        entry.mood = representation.mood
        
    }
    
    
    
    
}
