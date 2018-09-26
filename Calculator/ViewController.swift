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
        
        brain.setOperandHistory(operandStr: digit)
        historyValue = brain.history
    }
    
    private var displayValue : Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    private var historyValue : String {
        get {
            return history.text!
        }
        set {
            history.text = String(newValue)
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
            historyValue = brain.history
        }
    }
    
    @IBAction private func performOperation(_ sender: UIButton) {
        //let operand = sender.currentTitle!;

        if userIsInTheMiddleOfTyping {
            brain.setOperand(operand: displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(symbol: mathematicalSymbol)
        }
        
        displayValue = brain.result
        historyValue = brain.history
    }
}

