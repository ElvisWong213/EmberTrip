//
//  FileManageService.swift
//  EmberTrip
//
//  Created by Elvis on 16/12/2023.
//

import Foundation

class FileManageService {
    static func loadDataFromFile<T: Codable>(fileURL: URL, type: T.Type) -> T? {
        do {
            // Read the contents of the JSON file
            let data = try Data(contentsOf: fileURL)
            
            // Create a JSONDecoder instance
            let decoder = JSONDecoder()
            
            // Decode the JSON data into the MyData struct
            let decodedData = try decoder.decode(type, from: data)
            
            return decodedData
        } catch {
            print("Error decoding JSON: \(error)")
        }
        return nil
    }
    
    static func saveDataToCache(data: Cache) throws {
        let filePath = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("cache", conformingTo: .json)
        let encode = try JSONEncoder().encode(data)
        let fileManger = FileManager.default
        if fileManger.fileExists(atPath: filePath.relativePath) {
            try fileManger.removeItem(at: filePath)
        }
        try encode.write(to: filePath)
    }
    
    static func loadDataFormCache() -> Cache? {
        do {
            let filePath = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("cache", conformingTo: .json)
            return loadDataFromFile(fileURL: filePath, type: Cache.self)
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    static func removeCache() {
        do {
            let filePath = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("cache", conformingTo: .json)
            let fileManger = FileManager.default
            if fileManger.fileExists(atPath: filePath.relativePath) {
                try fileManger.removeItem(at: filePath)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
