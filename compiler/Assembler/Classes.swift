//
//  Classes.swift
//  compiler
//
//  Created by Terence Ndabereye on 20/10/2021.
//

import Foundation
class Instruction {
    var RawOperation: String
    var RawOperand: String
    
    var CodedOperation: Int
    var CodedOperand: Int
    
    enum SyntaxError: Error {
        case MOV
        case CMPT
        case JIF
    
    }
    init(Operation: String, OpCode: String) {
        RawOperation = Operation
        RawOperand = OpCode
        CodedOperation = 0x00
        CodedOperand = 0x00
    }
    
    init() {
        RawOperation = ""
        RawOperand = ""
        CodedOperation = 0x00
        CodedOperand = 0x00
    }
    
    var instructionDic = [
        "NOOP": 0x00,
        "INPT": 0x01,
        "MOV": 0x02,
        "CMPT": 0x03,
        "OUTPT": 0x04,
        "JMP": 0x05,
        "JIF": 0x06,
        "GTPCR": 0x07
    ]
    
    var registerReadDic = [
        "GP0": 0x0,
        "GP1": 0x1,
        "GP2": 0x2,
        "GP3": 0x3,
        "GP4": 0x4,
        "GP5": 0x5,
        "GP6": 0x6,
        "GP7": 0x7,
        "RA": 0x8,
        "RBI": 0x9,
        "RPC": 0xa,
        "RIN": 0xb,
        "AD0": 0xc,
        "AD1": 0xd,
        "MEM": 0xe
    ]
    
    var registerWriteDic = [
        "GP0": 0x0,
        "GP1": 0x1,
        "GP2": 0x2,
        "GP3": 0x3,
        "GP4": 0x4,
        "GP5": 0x5,
        "GP6": 0x6,
        "GP7": 0x7,
        "RX": 0x9,
        "RY": 0xa,
        "RO": 0xb,
        "AD0": 0xc,
        "AD1": 0xd,
        "MEM": 0xe
    ]
    
    var ifDic = [
        "OVF": 0x0,
        "LSN": 0x1,
        "EQL": 0x2,
        "GTR": 0x3,
        "NEG": 0x4,
        "ZER": 0x5
    ]
    
    var aluDic = [
        "ADD": 0,
        "SUB": 1,
        "MUL": 2,
        "DIV": 3,
        "MOD": 4,
        "NEGA": 5,
        "NEGB": 6
    ]
    
    
    func encode() throws {
        // do encoding
        CodedOperation = instructionDic[RawOperation] ?? 0x00
        switch CodedOperation {
        case 0x1: //INPT
            if (RawOperand.starts(with: "$")) {
                RawOperand.removeFirst()
                CodedOperand = Int(RawOperand, radix: 10) ?? 0
            } else {
//                let d1 = RawOperand.first
//                let d0 = RawOperand.last
//                let d1x = (d1?.hexDigitValue ?? 0)
//                let d0x = (d0?.hexDigitValue ?? 0)
                CodedOperand = Int(RawOperand, radix: 16) ?? 0
            }
        case 0x2: //MOV
            let fromStr = String(RawOperand[..<RawOperand.firstIndex(of: " ")!])
            RawOperand.removeSubrange(RawOperand.startIndex...(RawOperand.firstIndex(of: " ") ?? RawOperand.endIndex))
            let toStr = RawOperand
            
            let from = registerReadDic[fromStr]! * 0x10
            let to = registerWriteDic[toStr]!
            
            CodedOperand = from + to
            
        case 0x3: //CMPT
            CodedOperand = aluDic[RawOperand] ?? 0xeeee
            if (CodedOperand == 0xeeee) {
                throw SyntaxError.CMPT
            }
        case 0x6: //JIF
            CodedOperand = ifDic[RawOperand] ?? 0xeeee
            if (CodedOperand == 0xeeee) {
                throw SyntaxError.JIF
            }
        default:
            CodedOperand = 0
        }
    }
}

func assemble(sourceCode: String)-> String {
    let inputString: String = sourceCode
    

    var intermediateString: [String] = []

    
    var temp: String = ""
    for i in inputString {
        if !i.isNewline {
            temp.append(i)
        } else {
            intermediateString.append(temp)
            temp.removeAll()
        }
    }

    var instructions:[Instruction] = []

    for i in intermediateString {
        if (i.hasPrefix("//")) {
            // do nothing
        } else if (i.hasPrefix(":")){
            
        } else {
            let temp: Instruction = Instruction()
            temp.RawOperation = String(i[..<(i.firstIndex(of: " ") ?? i.endIndex)])
            temp.RawOperand = String(i[(i.firstIndex(of: " ") ?? i.endIndex) ..< i.endIndex])
            if !(temp.RawOperand.isEmpty) {
                temp.RawOperand.removeFirst()
            }
            instructions.append(temp)
        }
    }

    for i in instructions {
        try? i.encode()
    }

    for i in instructions {
        print(String(format: "%02X", i.CodedOperation), String(format: "%02X", i.CodedOperand))
    }

    var outputString: String = ""

    for i in instructions {
        outputString.append(String(format: "%02X ", i.CodedOperation))
        outputString.append(String(format: "%02X ", i.CodedOperand))
    }
    
    print("\(instructions.count * 2) bytes used of \(0xffff) bytes total available")
    
    return outputString
}

let functionLength:[String: Int] = [
    "var": 0,
    "set": 0,
    "free": 0,
    "add": 0,
    "sub": 0,
    "mul": 0,
    "div": 0,
    "mod": 0,
    "neg": 0,
    "jump": 0,
    "if": 0,
    "$": 1,
    "print": 0
]
