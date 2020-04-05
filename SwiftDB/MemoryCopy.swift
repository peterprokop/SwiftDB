//
//  MemoryCopy.swift
//  SwiftDB
//
//  Created by Pete Prokop on 12/03/2019.
//  Copyright © 2019 Pete Prokop. All rights reserved.
//

import Foundation

/// Caution: when T is not a `primitive` type, this code may cause severe memory issue
func copyMemory<T>(from arr: [T], to umrp: UnsafeMutableRawPointer, startingIndex: Int) {
    let byteOffset = MemoryLayout<T>.stride * startingIndex
    let byteCount = MemoryLayout<T>.stride * arr.count
    umrp.advanced(by: byteOffset).copyMemory(from: arr, byteCount: byteCount)
}

/// Caution: when T is not a `primitive` type, this code may cause severe memory issue
func copyMemory<T>(from arr: ContiguousArray<T>, to umrp: UnsafeMutableRawPointer, startingIndex: Int) {
    let byteOffset = MemoryLayout<T>.stride * startingIndex
    let byteCount = MemoryLayout<T>.stride * arr.count
    umrp.advanced(by: byteOffset).copyMemory(from: Array(arr), byteCount: byteCount)
}
