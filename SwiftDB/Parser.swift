//
//  Parser.swift
//  SwiftDB
//
//  Created by Pete Prokop on 13/03/2019.
//  Copyright © 2019 Pete Prokop. All rights reserved.
//

import Foundation

public enum Statement {
    // TODO: should handle insert in general case
    case insert(row: Row)
    case select
}

enum PrepareStatementError: Error {
    case parse
    case insertWrongArguments
    case unknownStatement
}

public func prepareStatement(input: String) throws -> Statement {
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
