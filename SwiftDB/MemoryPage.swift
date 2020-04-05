//
//  MemoryPage.swift
//  SwiftDB
//
//  Created by Pete Prokop on 12/03/2019.
//  Copyright © 2019 Pete Prokop. All rights reserved.
//

import Foundation

public class Table {
    static let pageSize: UInt32 = 4096
    static let maxPages: UInt32 = 128
    static let rowsPerPage: UInt32 = pageSize / UInt32(Row.total)
    static let maxRows = rowsPerPage * maxPages

    var pages: [UnsafeMutableRawPointer] = []
    var numberOfRows = 0

    public init() {}

    func rowSlot(rowNum: UInt32) -> UnsafeMutableRawPointer {
        let pageNum = rowNum / Table.rowsPerPage
        let page: UnsafeMutableRawPointer
        if pages.count <= pageNum {
            page = UnsafeMutableRawPointer.allocate(
                byteCount: Int(Table.pageSize),
                alignment: MemoryLayout<UInt8>.alignment
            )
            pages.append(page)
        } else {
            page = pages[Int(pageNum)]
        }

        let rowOffset = rowNum % Table.rowsPerPage
        let byteOffset = Int(rowOffset) * Row.total

        return page.advanced(by: byteOffset)
    }
    
}
