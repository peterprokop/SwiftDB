//
//  main.swift
//  SwiftDB
//
//  Created by Pete Prokop on 11/03/2019.
//  Copyright © 2019 Pete Prokop. All rights reserved.
//

import Foundation

enum Statement {
    // TODO: should handle insert in general case
    case insert(id: Int, name: String, email: String)
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
            let id = Int(tokens[1])
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

        return .insert(id: id, name: String(name), email: String(email))
    case "select":
        return .select
    default:
        throw PrepareStatementError.unknownStatement
    }
}

func execute(statement: Statement) {
    switch statement {
    case .select:
        print("Executing select")
    case .insert:
        print("Executing insert")
    }
}

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
        execute(statement: statement)
    }
    catch {
        print("Statement error:", error)
    }
}
