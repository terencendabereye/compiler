//
//  LowLevelFunc.swift
//  compiler
//
//  Created by Terence Ndabereye on 20/10/2021.
//

import Foundation

//func readMemory(address: String, register: String) -> String {
//    var out: String
//    let addr0: String = String(address[..<(address.index(address.startIndex, offsetBy: 2))])
//    let addr1: String = String(address[(address.index(address.startIndex, offsetBy: 2))..<address.endIndex])
//    
//    out = """
//    INPT \(addr0)
//    MOV RIN AD0
//    INPT \(addr1)
//    MOV RIN AD1
//    MOV MEM \(register)
//    
//    """
//    return out
//}

func writeMemory(address: Int, register: String) -> String {
    var out: String
    
    out = pointAddress(address: address)
    out.append("""
MOV \(register) MEM

""")
    
    return out
}

func inputToRegister(value: Int, register: String) -> String {
    var out: String = ""
    out = """
       INPT \(String(value, radix: 16))
       MOV RIN \(register)
       
       """
    return out
}

func readMemory(address: Int, register: String) -> String {
    var out: String
    
    out = pointAddress(address: address)
    out.append("""
MOV MEM \(register)

""")
    
    return out
}

func calculate(operation: String) -> String {
    var out = ""
    out = """
CMPT \(operation)

"""
    return out
}

func pointAddress(address: Int) -> String {
    var out: String
    let addr1: Int = (address & 0xff00) >> 8
    let addr0: Int = address & 0xff
    out = """
    INPT \(String(addr0, radix: 16))
    MOV RIN AD0
    INPT \(String(addr1, radix: 16))
    MOV RIN AD1
    
    """
    return out
}

func getProgramCounter(register0: String = "A0", register1: String = "A1") -> String {
    var out = ""
    out = """
GTPCR
MOV RPC \(register0)
MOV RPC \(register1)

"""
    return out
}
