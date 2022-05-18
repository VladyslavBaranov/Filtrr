//
//  GraphicsLoader.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 18.05.2022.
//

import Foundation

struct GraphicsCollection: Codable {
    struct Content: Codable {
        var image: String
        var layoutType: Int
    }
    var thumb: String
    var title: String
    var numberOfPics: Int
    var header: String
    var content: [Content]
}

final class GraphicsLoader {
    
    var collections: [GraphicsCollection] = []
    init() {
        guard let path = Bundle.main.url(forResource: "GraphicsSystem", withExtension: "json") else { return }
        guard let data = try? Data(contentsOf: path) else { return }
        guard let collections = try? JSONDecoder().decode([GraphicsCollection].self, from: data) else { return }
        self.collections = collections
    }
}
