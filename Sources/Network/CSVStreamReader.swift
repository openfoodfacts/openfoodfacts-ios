//
//  OfflineService.swift
//  OpenFoodFacts
//
//  Created by Philippe Auriach on 05/03/2019.
//

import Foundation

class CSVStreamReader {
    let encoding: String.Encoding
    let chunkSize: Int
    let fileHandle: FileHandle
    var buffer: Data
    let delimPattern: Data
    let csvDelimiter: String
    var colHeaders: [String]?

    init?(url: URL,
          delimiter: String = "\n",
          encoding: String.Encoding = .utf8,
          chunkSize: Int = 4096,
          csvDelimiter: String = ",",
          colHeaders: [String]? = nil) {

        if FileManager.default.fileExists(atPath: url.path) == false {
            log.error("[CSVStreamReader] File do not exist, impossible to use CSVStreamReader")
            return nil
        }

        do {
            let fileHandle = try FileHandle(forReadingFrom: url)
            self.fileHandle = fileHandle
        } catch let error as NSError {
            log.error("[CSVStreamReader] File handle no created ? \(error)")
            return nil
        }

        self.chunkSize = chunkSize
        self.encoding = encoding
        buffer = Data(capacity: chunkSize)
        delimPattern = delimiter.data(using: .utf8)!
        self.csvDelimiter = csvDelimiter

        self.colHeaders = colHeaders
    }

    deinit {
        fileHandle.closeFile()
    }

    func nextLine() -> String? {
        repeat {
            if let range = buffer.range(of: delimPattern, options: [], in: buffer.startIndex ..< buffer.endIndex) {
                let subData = buffer.subdata(in: buffer.startIndex ..< range.lowerBound)
                let line = String(data: subData, encoding: encoding)
                buffer.replaceSubrange(buffer.startIndex ..< range.upperBound, with: [])
                return line
            } else {
                let tempData = fileHandle.readData(ofLength: chunkSize)
                if tempData.isEmpty {
                    return (buffer.isEmpty == false) ? String(data: buffer, encoding: encoding) : nil
                }
                buffer.append(tempData)
            }
        } while true
    }

    func nextCSVLine() -> [String]? {
        guard let line = nextLine() else {
            return nil
        }

        return line.components(separatedBy: csvDelimiter)
            .map { $0.trimmingCharacters(in: CharacterSet.whitespaces) }
    }

    func streamCSV(onLineItem: @escaping ([String: String]) -> Void) {
        if colHeaders == nil {
            colHeaders = nextCSVLine()
        }

        guard let colHeaders = colHeaders else {
            log.error("[CSVStreamReader] Tried to stream in csv mode without headers ??")
            return
        }

        var continueRepeat = true
        repeat {
            autoreleasepool {
                var lineItem = [String: String]()
                guard let line = nextCSVLine() else {
                    continueRepeat = false
                    return
                }
                for (index, col) in colHeaders.enumerated() where line.count > index {
                    lineItem[col] = line[index]
                }
                if lineItem.isEmpty == false {
                    onLineItem(lineItem)
                }
            }
        } while continueRepeat
    }
}

class TypedCSVStreamReader<T>: CSVStreamReader {

    func batchStream(batchSize: Int, parse: @escaping ([String]) -> T?, treatBatch: @escaping ([T]) -> Void) {
        var batch = [T]()

        var continueRepeat = true
        repeat {
            autoreleasepool {
                guard let line = nextLine() else {
                    continueRepeat = false
                    return
                }
                let datas = line.split(separator: "\t").map { $0.trimmingCharacters(in: .whitespaces )}
                if datas.isEmpty == false, let parsed = parse(datas) {
                    batch.append(parsed)
                }

                if batch.count >= batchSize {
                    treatBatch(batch)
                    batch.removeAll()
                }
            }
        } while continueRepeat

        if batch.isEmpty == false {
            treatBatch(batch)
            batch.removeAll()
        }
    }

    func batchStreamCSV(batchSize: Int, parse: @escaping ([String: String]) -> T?, treatBatch: @escaping ([T]) -> Void) {
        var batch = [T]()

        streamCSV { (lineItem: [String: String]) in
            if let item = parse(lineItem) {
                batch.append(item)
            }

            if batch.count >= batchSize {
                treatBatch(batch)
                batch.removeAll()
            }
        }

        if batch.isEmpty == false {
            treatBatch(batch)
            batch.removeAll()
        }
    }

}
