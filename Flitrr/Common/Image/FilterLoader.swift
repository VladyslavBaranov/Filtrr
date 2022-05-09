//
//  FilterLoader.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 09.05.2022.
//

import UIKit

struct Filter: Codable {
    struct Parameter: Codable {
        var displayName: String
        var pName: String
        var defaultScalarValue: Float
        var min: Float
        var max: Float
    }
    
    var displayName: String
    var filterName: String
    var parameters: [Parameter]
}

final class FilterLoader {
    var filters: [Filter] = []
    
    init() {
        guard let filtersSource = Bundle.main.url(forResource: "Filters", withExtension: "json") else { return }
        guard let data = try? Data(contentsOf: filtersSource) else { return }
        guard let filters = try? JSONDecoder().decode([Filter].self, from: data) else { return }
        self.filters = filters
    }
}
