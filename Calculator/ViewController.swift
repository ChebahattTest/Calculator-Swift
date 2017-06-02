//
//  ViewController.swift
//  Calculator
//
//  Created by Tatiana Kornilova on 3/8/17.
//  All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    @IBOutlet weak var tochka: UIButton!{
        didSet {
            tochka.setTitle(decimalSeparator, for: UIControlState())
        }
    }
    let decimalSeparator = formatter.decimalSeparator ?? "."
    var userInTheMiddleOfTyping = false
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            if (digit != decimalSeparator) || !(textCurrentlyInDisplay.contains(decimalSeparator)) {
            display.text = textCurrentlyInDisplay + digit
            }
        } else {
            display.text = digit
            userInTheMiddleOfTyping = true
        }
    }
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = formatter.string(from: NSNumber(value:newValue))

         }
    }
    
    private var brain = CalculatorBrain ()
    
    @IBAction func performOPeration(_ sender: UIButton) {
        if userInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userInTheMiddleOfTyping = false
        }
        if  let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        if let result = brain.result {
            displayValue = result
        }
     history.text = brain.description + (brain.resultIsPending ? " …" : " =")    
    }
    
    @IBAction func clearAll(_ sender: UIButton) {
        brain.clear()
        displayValue = 0
        history.text = " "
    }
    
    @IBAction func backspace(_ sender: UIButton) {
        guard userInTheMiddleOfTyping && !display.text!.isEmpty else { return }
            display.text = String (display.text!.characters.dropLast())
        if display.text!.isEmpty
        {	displayValue = 0.0
            userInTheMiddleOfTyping = false
        }
    }
}
