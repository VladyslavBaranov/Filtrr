//
//  ProjectsFileManager.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 15.05.2022.
//

import Foundation

final class ProjectsFileManager {
    
    static let shared = ProjectsFileManager()
    
    enum PNGFileError: Error {
        case commonError
    }
    
    func getImageDataWithURL(_ url: URL) -> Result<Data, PNGFileError> {
        
        guard let data = try? Data(contentsOf: url) else { return .failure(.commonError) }
        return .success(data)
        /*
        let manager = FileManager.default
        guard manager.fileExists(atPath: url.path) else {
            print("FILE NOT EXISTS")
            return .failure(.commonError)
        }
        print("FILE EXISTS")
        guard let data = try? Data(contentsOf: url) else { return .failure(.commonError) }
        return .success(data)*/
    }
    
    func createPNGImage(_ data: Data, name: String) -> URL? {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        let pngUrl = url.appendingPathComponent(name).appendingPathExtension("png")
        let manager = FileManager.default
        do {
            try data.write(to: pngUrl)
            return pngUrl
        } catch {
            return pngUrl
        }
    }
    
    func dropPNG(_ url: URL) -> Bool {
        let manager = FileManager.default
        if manager.fileExists(atPath: url.path) {
            do {
                try manager.removeItem(at: url)
                return true
            } catch {
                return false
            }
        } else {
            return false
        }
    }
}
