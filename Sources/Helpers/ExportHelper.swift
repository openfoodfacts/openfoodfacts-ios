//
//  ExportHelper.swift
//  OpenFoodFacts
//
//  Created by Mykola Aleschenko on 4/20/20.
//

import RealmSwift

struct ExportHelper {
    func exportItemsToCSV(objects: [Object]) -> String {
        guard !objects.isEmpty else {
            return ""
        }

        // Make CSV "header" first
        var propertiesNames: [String] = []
        objects[0].objectSchema.properties.forEach { propertiesNames.append($0.name.capitalized) }
        let header = propertiesNames.joined(separator: ",")
        if header.isEmpty { return "" }

        // Add objects' values
        var values: [String] = []
        objects.forEach { values.append(($0 as? StringRepresentable)?.stringRepresentation()) }

        return "\(header)\n\(values.joined(separator: "\n"))"
    }
}
