//
//  Executor.swift
//  SwiftDB
//
//  Created by Pete Prokop on 13/03/2019.
//  Copyright © 2019 Pete Prokop. All rights reserved.
//

import Foundation

public func executeMetaCommand(input: String) -> Bool {
    switch input {
    case ".exit":
        exit(0)
    default:
        return false
    }
}

enum ExecuteStatementError: Error {
    case tableFull
}

func executeInsert(row: Row, table: Table) throws {
    if table.numberOfRows >= Table.maxRows {
        throw ExecuteStatementError.tableFull
    }
    serialize(row: row, destination: table.rowSlot(rowNum: UInt32(table.numberOfRows)))
    table.numberOfRows += 1
}

func executeSelect(table: Table) {
    for i in 0 ..< table.numberOfRows {
        let row = deserialize(source: table.rowSlot(rowNum: UInt32(i)))
        print(row)
    }
}

public func execute(statement: Statement, table: Table) {
    switch statement {
    case .select:
        print("Executing select")
        executeSelect(table: table)
    case .insert(let row):
        print("Executing insert")
        do {
            try executeInsert(row: row, table: table)
        }
        catch {
            print(error)
        }
    }
}
