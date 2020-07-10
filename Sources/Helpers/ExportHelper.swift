//
//  ExportHelper.swift
//  OpenFoodFacts
//
//  Created by Mykola Aleschenko on 4/20/20.
//

import Foundation
import RealmSwift

struct ExportHelper {
    private let fileName = "history.csv"

    // MARK: - Export

    func exportItemsToCSV(objects: [Object]) -> URL? {
        guard !objects.isEmpty else {
            return nil
        }

        // Make CSV "header" first
        var propertiesNames: [String] = []
        objects[0].objectSchema.properties.forEach { propertiesNames.append($0.name.capitalized) }
        let header = propertiesNames.joined(separator: ",")
        if header.isEmpty { return nil }

        // Add objects' values
        var values: [String] = []
        objects.forEach { values.append(($0 as? StringRepresentable)?.stringRepresentation()) }

        let contents = "\(header)\n\(values.joined(separator: "\n"))"
        saveToFile(contents)

        return getDocumentsDirectory().appendingPathComponent(fileName).absoluteURL
    }

    // MARK: - File access

    private func saveToFile(_ contents: String) {
        let filename = getDocumentsDirectory().appendingPathComponent(fileName)

        do {
            try contents.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
            AnalyticsManager.record(error: error)
        }
    }

    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
