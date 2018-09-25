//
//  ViewController.swift
//  Calculator
//
//  Created by Juyong Lee on 2018. 9. 11..
//  Copyright © 2018년 Juyong Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var display: UILabel!
    @IBOutlet private weak var history: UILabel!
    
    private var userIsInTheMiddleOfTyping = false
    private var userIsCalculatorHistory = false;
    
    @IBAction private func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        
        if digit == "." && (display.text?.contains("."))! {
            return
        }
        
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text! 
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
        }
        
        userIsInTheMiddleOfTyping = true

        displayHistory(value: digit)
    }
    
    private var displayValue : Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.Constant,
        "e" : Operation.Constant,
        "√" : Operation.UnaryOperation,
        "cos" : Operation.UnaryOperation,
        "=" : Operation.Equals
    ]
    
    private enum Operation {
        case Constant
        case UnaryOperation
        case Equals
    }

    private func displayHistory(value: String) {
        
        let historyRecord = history.text!
        let displayValue = display.text!
        
        if let operation = operations[value] {
            switch operation {
            case .Constant :
                history.text = value + "=" + displayValue
            case .UnaryOperation :
                history.text = historyRecord + value + "=" + displayValue
            case .Equals :
                history.text = historyRecord + value + displayValue
            }
            userIsCalculatorHistory = false
        }else{
            if !userIsCalculatorHistory {
                history.text = value
                userIsCalculatorHistory = true
            }else{
                history.text = historyRecord + value
            }
        }
    }
    
    var brain : CalculatorBrain = CalculatorBrain()
    
    var savedProgram : CalculatorBrain.PropertyList?
    
    @IBAction func save() {
        savedProgram = brain.program
    }
    
    @IBAction func restore() {
        if savedProgram != nil {
            brain.program = savedProgram!
            displayValue = brain.result
        }
    }
    
    @IBAction private func performOperation(_ sender: UIButton) {
        let operand = sender.currentTitle!;

        if userIsInTheMiddleOfTyping {
            brain.setOperand(operand: displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(symbol: mathematicalSymbol)
        }
        
        displayValue = brain.result

        if !userIsCalculatorHistory {
            userIsCalculatorHistory = true
        }
        displayHistory(value: operand)
    }
}

