//
//  main.swift
//  SwiftDB
//
//  Created by Pete Prokop on 11/03/2019.
//  Copyright © 2019 Pete Prokop. All rights reserved.
//

import Foundation

struct Row {
    let id: Int32
    let name: String
    let email: String

    static let idOffset = 0
    static let nameOffset = 4
    static let emailOffset = 36

    static let total = 292
}

func serialize(row: Row, destination: UnsafeMutableRawPointer) {
    destination.initializeMemory(as: UInt8.self, repeating: 0, count: Row.total)

    withUnsafePointer(to: row.id) { (ptr) -> Void in
        destination.copyMemory(from: ptr, byteCount: 4)
    }

    copyMemory(from: row.name.utf8CString, to: destination, startingIndex: Row.nameOffset)
    copyMemory(from: row.email.utf8CString, to: destination, startingIndex: Row.emailOffset)
}

func deserialize(source: UnsafeMutableRawPointer) -> Row {
    let id = source.load(as: Int32.self)

    let namePtr = source.advanced(by: Row.nameOffset).bindMemory(to: UInt8.self, capacity: 32)
    let nameStr = String(cString: namePtr)

    let emailPtr = source.advanced(by: Row.emailOffset).bindMemory(to: UInt8.self, capacity: 256)
    let emailStr = String(cString: emailPtr)

    return Row(id: id, name: nameStr, email: emailStr)
}

enum Statement {
    // TODO: should handle insert in general case
    case insert(row: Row)
    case select
}

func printPrompt() {
    print("SwiftDB ➜", separator: "")
}

func executeMetaCommand(input: String) -> Bool {
    switch input {
    case ".exit":
        exit(0)
    default:
        return false
    }
}

enum PrepareStatementError: Error {
    case parse
    case insertWrongArguments
    case unknownStatement
}

func prepareStatement(input: String) throws -> Statement {
    let tokens = input.split(separator: " ", maxSplits: 65536, omittingEmptySubsequences: true)
    guard let statementWord = tokens.first else {
        throw PrepareStatementError.parse
    }

    switch statementWord {
    case "insert":
        guard
            tokens.count == 4,
            let id = Int32(tokens[1])
        else {
            throw PrepareStatementError.insertWrongArguments
        }

        let name = tokens[2]
        let email = tokens[3]
        guard
            name.count < 32,
            email.count < 256
        else {
            throw PrepareStatementError.insertWrongArguments
        }

        let row = Row(id: id, name: String(name), email: String(email))
        return .insert(row: row)
    case "select":
        return .select
    default:
        throw PrepareStatementError.unknownStatement
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

func execute(statement: Statement, table: Table) {
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

let table = Table()

while true {
    printPrompt()
    guard let input = readLine(strippingNewline: true) else {
        exit(0)
    }

    if input.first == "." {
        if !executeMetaCommand(input: input) {
            print("Command not recognized:", input)
        }
        continue
    }

    do {
        let statement = try prepareStatement(input: input)
        execute(statement: statement, table: table)
    }
    catch {
        print("Statement error:", error)
    }
}
