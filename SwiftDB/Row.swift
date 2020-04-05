//
//  Row.swift
//  SwiftDB
//
//  Created by Pete Prokop on 13/03/2019.
//  Copyright © 2019 Pete Prokop. All rights reserved.
//

import Foundation

public struct Row {
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
