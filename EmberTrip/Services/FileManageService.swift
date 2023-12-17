//
//  FileManageService.swift
//  EmberTrip
//
//  Created by Elvis on 16/12/2023.
//

import Foundation

/// A service for managing file operations such as reading, writing, and deleting data.
class FileManageService {
    /// Load data from a file and decode it into the specified type.
    /// - Parameters:
    ///   - fileURL: The URL of the file to be loaded.
    ///   - type: The type into which the data should be decoded.
    /// - Returns: The decoded data of the specified type if successful; otherwise, nil.
    static func loadDataFromFile<T: Codable>(fileURL: URL, type: T.Type) -> T? {
        do {
            // Read the contents of the JSON file
            let data = try Data(contentsOf: fileURL)
            // Create a JSONDecoder instance
            let decoder = JSONDecoder()
            // Decode the JSON data into the specified type
            let decodedData = try decoder.decode(type, from: data)
            return decodedData
        } catch {
            print("Error decoding JSON: \(error)")
        }
        return nil
    }
    
    /// Returns the file URL for the cache file in the document directory.
    /// - Returns: A file URL for the cache file in the document directory.
    /// - Throws: An error if the file URL cannot be created.
    static func cacheFilePath() throws -> URL {
        return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("cache", conformingTo: .json)
    }
    
    /// Save data to the file cache.
    /// - Parameter data: The data to be saved to the cache.
    /// - Throws: An error if writing to the cache fails.
    static func saveDataToCache(data: Cache) throws {
        let filePath = try cacheFilePath()
        let encode = try JSONEncoder().encode(data)
        let fileManger = FileManager.default
        if fileManger.fileExists(atPath: filePath.relativePath) {
            try fileManger.removeItem(at: filePath)
        }
        try encode.write(to: filePath)
    }
    
    /// Load data from the file cache.
    /// - Returns: The data loaded from the cache if successful; otherwise, nil.
    static func loadDataFormCache() -> Cache? {
        do {
            let filePath = try cacheFilePath()
            return loadDataFromFile(fileURL: filePath, type: Cache.self)
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    /// Remove the cache file.
    static func removeCache() {
        do {
            let filePath = try cacheFilePath()
            let fileManger = FileManager.default
            if fileManger.fileExists(atPath: filePath.relativePath) {
                try fileManger.removeItem(at: filePath)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
