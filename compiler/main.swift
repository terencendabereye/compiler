//
//  main.swift
//  compiler
//
//  Created by Terence Ndabereye on 2021-10-15.

// todo:
// done can directly input assembly
// done can output data
// add support for pointers in the form var &ptr @12 @33r4
// add scan function


//  sample code
//  add @1 1 1
//  set @2 13
//  //neg @2
//  jump @0

import Foundation
import FileProvider

let sampleSource: String = """
var %age @ec3a #ff
print %age

"""

var source: URL = URL(fileURLWithPath: CommandLine.arguments[1])
var output: URL
if (!FileManager.default.fileExists(atPath: CommandLine.arguments[2])) {
    FileManager.default.createFile(atPath: CommandLine.arguments[2], contents: nil)
    output = URL(fileURLWithPath: CommandLine.arguments[2])
} else {
    output = URL(fileURLWithPath: CommandLine.arguments[2])
}
var inputString: String = try! String(contentsOf: source, encoding: .ascii)
var outputString: String = ""

compile(sourceCode: inputString, machineCode: &outputString)
outputString.insert(contentsOf: "v2.0 raw\n", at: outputString.startIndex)

try! outputString.write(to: output, atomically: true, encoding: .ascii)

