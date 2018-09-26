//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Juyong Lee on 2018. 9. 16..
//  Copyright © 2018년 Juyong Lee. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private var accumulator = 0.0
    private var internalProgram = [AnyObject]()
    private var internalHistory = " "
    
    var history : String {
        get {
            return internalHistory
        }
    }
    
    func setOperandHistory(operandStr: String){
        internalHistory.append(operandStr)
    }
    
    func setOperand(operand: Double) {
        accumulator = operand
        internalProgram.append(operand as AnyObject)
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.Constant(.pi),
        "e" : Operation.Constant(M_E),
        "√" : Operation.UnaryOperation(sqrt),
        "cos" : Operation.UnaryOperation(cos),
        "±" : Operation.UnaryOperation({ -$0 }),
        "×" : Operation.BinaryOperation({ $0 * $1 }),
        "÷" : Operation.BinaryOperation({ $0 / $1 }),
        "+" : Operation.BinaryOperation({ $0 + $1 }),
        "−" : Operation.BinaryOperation({ $0 - $1 }),
        "=" : Operation.Equals,
        "AC" : Operation.Init
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
        case Init
    }
    
    func performOperation(symbol : String) {
        internalProgram.append(symbol as AnyObject)
        
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value) :
                accumulator = value
                internalHistory = symbol + "=" + String(accumulator)
            case .UnaryOperation(let function) :
                accumulator = function(accumulator)
                internalHistory.append(symbol + "=" + String(accumulator))
            case .BinaryOperation(let function) :
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
                internalHistory.append(symbol)
            case .Equals :
                executePendingBinaryOperation()
                internalHistory.append(symbol + String(result))
            case .Init :
                clear()
            }
        }
    }
    
    private func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    private var pending : PendingBinaryOperationInfo?
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction : (Double, Double) -> Double
        var firstOperand : Double
    }
    
    typealias PropertyList = AnyObject
    
    var program : PropertyList {
        get {
            return internalProgram as CalculatorBrain.PropertyList
        }
        set {
            clear()
            
            if let arrayOfOps = newValue as? [AnyObject] {
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        setOperand(operand: operand)
                        setOperandHistory(operandStr: String(operand))
                    } else if let operation = op as? String {
                        performOperation(symbol: operation)
                    }
                }
            }
        }
    }
    
    func clear() {
        accumulator = 0.0
        pending = nil
        internalProgram.removeAll()
        internalHistory = " "
    }
    
    var result : Double {
        get {
            return accumulator
        }
    }
}
