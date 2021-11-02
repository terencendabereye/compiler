//
//  Functions.swift
//  compiler
//
//  Created by Terence Ndabereye on 2021-10-15.
//

import Foundation

func decodeLine(_ inputString: String, outputString: inout String, variableDictionary: inout [String: Int], labelDic: inout [String: Int]) {
    if (!inputString.isEmpty) {
        if (inputString.hasPrefix("var ")) {
            outputString.append(doVar(inputString: inputString, variableDictionary: &variableDictionary))
        } else if (inputString.hasPrefix("free ")) {
            freeVar(inputString: inputString, variableDictionary: &variableDictionary)
        } else if (inputString.hasPrefix("set ")) {
            outputString.append(doSet(inputString: inputString, variableDictionary: &variableDictionary))
        } else if (inputString.hasPrefix("add ") || inputString.hasPrefix("sub ") || inputString.hasPrefix("mul ") || inputString.hasPrefix("div ") || inputString.hasPrefix("mod ")) {
            outputString.append(doCalc(inputString: inputString, variableDictionary: variableDictionary))
        } else if (inputString.hasPrefix("neg ")) {
            outputString.append(doNeg(inputString: inputString, variableDictionary: variableDictionary))
        } else if (inputString.hasPrefix("jump ")) {
            outputString.append(doJump(inputString: inputString, labelDic: labelDic))
        } else if (inputString.hasPrefix("if ")) {
            outputString.append(doIf(inputString: inputString, labelDic: labelDic, variableDic: variableDictionary))
        } else if (inputString.hasPrefix("$ ")) {
            var temp = inputString
            temp.removeFirst(2)
            outputString.append(temp)
            outputString.append("\n")
        } else if (inputString.hasPrefix("print ")) {
            outputString.append(doPrint(inputString: inputString, variableDic: variableDictionary))
        }
        
    }
}

func compile(sourceCode: String, machineCode: inout String) {
    var out: String = ""
    var dic: [String: Int] = [:]
    var labels: [String: Int] = [:]

    let lines = getLines(sourceCode)
    for i in lines {
        decodeLine(i, outputString: &out, variableDictionary: &dic, labelDic: &labels)
        if i.hasPrefix(":"){
            if (i.contains("@")) {
                
            } else {
                let temp = i
                labels[temp] = ((getLines(out).count) * 2)
            }
        }
    }

    machineCode = assemble(sourceCode: out)
    print(out)
}


func freeVar(inputString: String, variableDictionary: inout [String: Int])-> Void {
    let words = getWords(inputString)
    if (variableDictionary[words[1]] != nil) {
        variableDictionary[words[1]] = nil
    } else {
        fatalError("\(words[1]) is already free")
    }
}



func getWords(_ input: String) -> [String] {
    var temp = input
    var output: [String] = []
    while (!temp.isEmpty && !temp.hasPrefix("//")) {
        output.append(String(temp[temp.startIndex..<(temp.firstIndex(of: " ") ?? temp.endIndex)]))
        temp.removeSubrange(temp.startIndex...(temp.firstIndex(of: " ") ?? temp.index(before: temp.endIndex)))
    }
    return output
}

func getLines(_ input: String) -> [String]{
    var temp = input
    var output: [String] = []
    while (!temp.isEmpty) {
        output.append(String(temp[temp.startIndex..<(temp.firstIndex(of: "\n") ?? temp.endIndex)]))
        temp.removeSubrange(temp.startIndex...(temp.firstIndex(of: "\n") ?? temp.index(before: temp.endIndex)))
    }
    return output
}

func doVar(inputString: String, variableDictionary: inout [String: Int]) -> String {
    var words = getWords(inputString)
    var radix: Int = 0
    if (words[2].hasPrefix("@")) {
        radix = 16
    } else {
        radix = 10
    }
    words[2].removeFirst()
    
    if (variableDictionary[words[1]] == nil) {
        variableDictionary[words[1]] = Int(words[2], radix: radix)
    } else {
        fatalError("Variable \(words[1]) already exists")
    }
    
    var out = ""
    if (words.count == 4) {
        let temp = "set \(words[1]) \(words[3])"
        out.append(doSet(inputString: temp, variableDictionary: &variableDictionary))
    }
    
    return out
}

func doSet(inputString: String, variableDictionary: inout [String: Int]) -> String {
    // set a b
    // a = b
    var words = getWords(inputString)
    var output: String = ""
    var radix = 0
    var opp: Int = 0
    
    if (words[2].hasPrefix("#")) {
        radix = 16
    } else {
        radix = 10
    }
    if (words[2].hasPrefix("%")) {
       opp = 1
        words[2].removeFirst()
    } else if (words[2].hasPrefix("@")) {
        opp = 2
        words[2].removeFirst()
    }
    
    
    if (opp == 1) {
        words[2].insert("%", at: words[2].startIndex)
        output.append(readMemory(address: variableDictionary[words[2]]!, register: "GP0"))
        
    } else if (opp == 2){
        output.append(readMemory(address: Int(words[2], radix: 16)!, register: "GP0"))
    } else {
        if (words[2].hasPrefix("#")) {
            words[2].removeFirst()
        }
        output.append(inputToRegister(value: Int(words[2], radix: radix)!, register: "GP0"))
    }
    
    if (words[1].hasPrefix("%")) {
        output.append(writeMemory(address: variableDictionary[words[1]]!, register: "GP0"))
    } else if (words[1].hasPrefix("@")) {
        words[1].removeFirst()
        output.append(writeMemory(address: Int(words[1], radix: 16)!, register: "GP0"))
    }
    
    return output
}

func doCalc(inputString: String, variableDictionary: [String: Int]) -> String {
    // usage;
    // add a x y
    // where:  a = x + y
    // eg:
    // mul %totalCost %totalCost @e4b1
    
    var words = getWords(inputString)
    var out: String = ""
    let opp = words[0].uppercased()
    words.removeFirst()
    
    if (words[1].hasPrefix("@")) {
        words[1].removeFirst()
        out.append(readMemory(address: Int(words[1], radix: 16)!, register: "RX"))
    } else if (words[1].hasPrefix("%")) {
        out.append(readMemory(address: variableDictionary[words[1]]!, register: "RX"))
    } else if (words[1].hasPrefix("#")) {
        words[1].removeFirst()
        out.append(inputToRegister(value: Int(words[1], radix: 16)!, register: "RX"))
    } else {
        out.append(inputToRegister(value: Int(words[1], radix: 10)!, register: "RX"))
    }
    
    if (words[2].hasPrefix("@")) {
        words[2].removeFirst()
        out.append(readMemory(address: Int(words[2], radix: 16)!, register: "RY"))
    } else if (words[2].hasPrefix("%")) {
        out.append(readMemory(address: variableDictionary[words[2]]!, register: "RY"))
    } else if (words[2].hasPrefix("#")) {
        words[2].removeFirst()
        out.append(inputToRegister(value: Int(words[2], radix: 16)!, register: "RY"))
    } else {
        out.append(inputToRegister(value: Int(words[2], radix: 10)!, register: "RY"))
    }
    
    out.append(calculate(operation: opp))
    
    if (words[0].hasPrefix("@")) {
        words[0].removeFirst()
        out.append(writeMemory(address: Int(words[0] , radix: 16)!, register: "RA"))
    } else if (words[0].hasPrefix("%")) {
        out.append(writeMemory(address: variableDictionary[words[0]]!, register: "RA"))
    }
    
    return out
}

func doNeg(inputString: String, variableDictionary: [String: Int]) -> String {
    var out: String = ""
    var words = getWords(inputString)
    words.removeFirst()
    
    if (words[0].hasPrefix("@")) {
        words[0].removeFirst()
        out.append(readMemory(address: Int(words[0], radix: 16)!, register: "RX"))
        words[0].insert("@", at: words[0].startIndex)
    } else if (words[0].hasPrefix("%")) {
        out.append(readMemory(address: variableDictionary[words[0]]!, register: "RX"))
    } else if (words[0].hasPrefix("#")) {
        words[0].removeFirst()
        out.append(inputToRegister(value: Int(words[0], radix: 16)!, register: "RX"))
        words[0].insert("#", at: words[0].startIndex)
    } else {
        out.append(inputToRegister(value: Int(words[0], radix: 10)!, register: "RX"))
    }
    
    out.append(calculate(operation: "NEGA"))
    
    if (words.count == 1) {
        if (words[0].hasPrefix("@")) {
            words[0].removeFirst()
            out.append(writeMemory(address: Int(words[0] , radix: 16)!, register: "RA"))
        } else if (words[0].hasPrefix("%")) {
            out.append(writeMemory(address: variableDictionary[words[0]]!, register: "RA"))
        }
    } else {
        if (words[1].hasPrefix("@")) {
            words[1].removeFirst()
            out.append(writeMemory(address: Int(words[1] , radix: 16)!, register: "RA"))
        } else if (words[1].hasPrefix("%")) {
            out.append(writeMemory(address: variableDictionary[words[1]]!, register: "RA"))
        }
    }
    
    return out
}

func doJump(inputString: String, labelDic: [String: Int]) -> String {
    var word = getWords(inputString)[1]
    var out: String = ""
    
    if (word.hasPrefix("@")) {
        word.removeFirst()
        out.append(pointAddress(address: Int(word, radix: 16)!))
        out.append("""
JMP

""")
    } else if word.hasPrefix(":") {
        out.append(pointAddress(address: labelDic[word]!))
        out.append("""
JMP

""")
    }
    
    return out
}

func doIf(inputString: String, labelDic: [String: Int], variableDic: [String: Int]) -> String {
    var out: String = ""
    var words = getWords(inputString)
    var temp = ""
    var operation = ""
    words.removeFirst()
    
    if (words[0].hasPrefix("@")) {
        words[0].removeFirst()
        let temp = Int(words[0], radix: 16)!
        out.append(readMemory(address: temp, register: "RX"))
    } else if (words[0].hasPrefix("%")) {
        let temp = variableDic[words[0]]!
        out.append(readMemory(address: temp, register: "RX"))
    } else if (words[0].hasPrefix("#")) {
        words[0].removeFirst()
        let temp = Int(words[0], radix: 16)!
        out.append(inputToRegister(value: temp, register: "RX"))
    } else {
        let temp = Int(words[0], radix: 10)!
        out.append(inputToRegister(value: temp, register: "RX"))
    }
    
    if (words.count == 4) {
        if (words[2].hasPrefix("@")) {
            words[2].removeFirst()
            let temp = Int(words[2], radix: 16)!
            out.append(readMemory(address: temp, register: "RY"))
        } else if (words[2].hasPrefix("%")) {
            let temp = variableDic[words[2]]!
            out.append(readMemory(address: temp, register: "RY"))
        } else if (words[2].hasPrefix("#")) {
            words[2].removeFirst()
            let temp = Int(words[2], radix: 16)!
            out.append(inputToRegister(value: temp, register: "RY"))
        } else {
            let temp = Int(words[2], radix: 10)!
            out.append(inputToRegister(value: temp, register: "RY"))
        }
    }
    
    
    switch words[1] {
    case "<":
        operation = "LSN"
    case "=":
        operation = "EQL"
    case ">":
        operation = "GTR"
    default:
        operation = "EQL"
    }
    
    
    
    if (words[words.index(before: words.endIndex)].hasPrefix("@")) {
        words[words.index(before: words.endIndex)].removeFirst()
        let temp = Int(words[words.index(before: words.endIndex)], radix: 16)!
        out.append(pointAddress(address: temp))
    } else if (words[words.index(before: words.endIndex)].hasPrefix(":")) {
        out.append(pointAddress(address: labelDic[words[words.index(before: words.endIndex)]]!))
    }
    
    temp = """
JIF \(operation)

"""
    
    out.append(temp)
    
    return out
}

func doPrint(inputString: String, variableDic: [String: Int]) -> String {
    // print %name
    var word = getWords(inputString)[1]
    var out = ""
    if (word.hasPrefix("%")) {
        let temp = variableDic[word]!
        out.append(readMemory(address: temp, register: "RO"))
        out.append("OUTPT\n")
    } else if (word.hasPrefix("@")) {
        word.removeFirst()
        let temp = Int(word, radix: 16)!
        out.append(readMemory(address: temp, register: "RO"))
        out.append("OUTPT\n")
    } else if (word.hasPrefix("#")) {
        word.removeFirst()
        let temp = Int(word, radix: 16)!
        out.append(inputToRegister(value: temp, register: "RO"))
        out.append("OUTPT\n")
    } else {
        let temp = Int(word, radix: 10)!
        out.append(inputToRegister(value: temp, register: "RO"))
        out.append("OUTPT\n")
    }
    
    return out
}

func doScan(inputString: String, variableDic: [String: Int]) -> String {
    // reads one chacter from keyboard buffer
    // scan %(variable)
    // scan @(memory_adddress)
    
    return ""
}
