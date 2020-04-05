//
//  main.swift
//  SwiftDB
//
//  Created by Pete Prokop on 11/03/2019.
//  Copyright © 2019 Pete Prokop. All rights reserved.
//

import Foundation
import SwiftDB

func printPrompt() {
    print("SwiftDB ➜", separator: "")
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
