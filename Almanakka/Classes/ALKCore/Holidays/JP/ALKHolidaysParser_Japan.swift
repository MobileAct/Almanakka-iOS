//
//  ALKHolidaysParser_Japan.swift
//  ALKCore
//
//  Created by Oscar Peredo on 2020/05/11.
//  Copyright © 2020 Mobile Act, All rights reserved.
//

import Foundation

// Japanese national holidays
// https://www8.cao.go.jp/chosei/shukujitsu/gaiyou.html

public final class ALKHolidaysParserJapan : ALKHolidaysParser {
    
    static let fileName = "syukujitsu"
    static let fileType = "csv"
    
    private let minimunRequiredColumnsIndex = 1
    private let firstColumnIndex = 0
    private let secondColumnIndex = 1
    private let thirdColumnIndex = 2
    
    private var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    public func parseHolidays() -> [Day : ALKHoliday] {
        let holidays = parseHolidaysFromFile()
        return holidays
    }
    
    private func openFile() -> String? {
        
        let bundle = BundleLoader.AlmanakkaBundle()

        guard let filePath = bundle.path(forResource: ALKHolidaysParserJapan.fileName, ofType: ALKHolidaysParserJapan.fileType) else {
            print("Japan holidays CSV not found inside bundle: '\(bundle)'.")
            return  nil
        }
        
        do {
            let contentsOfFile = try String(contentsOfFile: filePath, encoding: .shiftJIS)
            return contentsOfFile
        } catch {
            print("Error: \(error)")
            return nil
        }
    }
    
    public func parseHolidaysFromFile() -> [Day: ALKHoliday] {
        var holidays:[Day: ALKHoliday] = [:]
        guard let contentsOfFile = openFile() else { return [:]}
        
        let rows = contentsOfFile.components(separatedBy: "\n")
        print(rows.count)
        for index in 1..<rows.count {
            let columns = rows[index].components(separatedBy: ",")
            
            if !isValidColumn(columns)  { continue }
            guard let date = validDate(from: columns[firstColumnIndex]) else { continue }
            
            let day = Day(referenceDate: date)
            if thirdColumnExists(in: columns) {
                
                holidays[day] = ALKHoliday(date: date,
                                               name: nameTrimmingSpaces(from: columns[secondColumnIndex]),
                                               nameEng: nameTrimmingSpaces(from: columns[thirdColumnIndex]))
            } else {
                holidays[day] = ALKHoliday(date: date,
                                         name: nameTrimmingSpaces(from: columns[secondColumnIndex]),
                                         nameEng: nil)
            }
        }
        
        return holidays
    }
    
    private func nameTrimmingSpaces(from string: String) -> String {
        return string.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private func validDate(from string: String) -> Date? {
        return formatter.date(from: string)
    }
    
    private func isValidColumn(_ column: [String]) -> Bool{
        return column.indices ~= minimunRequiredColumnsIndex
    }
    
    private func thirdColumnExists(in column: [String]) -> Bool {
        return column.indices.contains(thirdColumnIndex)
    }
}
