//
//  main.swift
//  SwiftDB
//
//  Created by Pete Prokop on 11/03/2019.
//  Copyright © 2019 Pete Prokop. All rights reserved.
//

import Foundation

enum Statement {
    case insert
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

func prepareStatement(input: String) -> Statement? {
    if input.starts(with: "insert") {
        return .insert
    } else if input.starts(with: "select") {
        return .select
    }

    return nil
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

    if let statement = prepareStatement(input: input) {
        execute(statement: statement)
    } else {
        print("Statement not recognized:", input)
    }

}
