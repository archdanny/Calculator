//
//  ViewController.swift
//  Calculator
//
//  Created by Daniello on 18/11/15.
//  Copyright © 2015 DDdesigns. All rights reserved.
//


import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var userIsTyping = false
    var userTypedDot = false
    var brain = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton)
    {
        var digit = sender.currentTitle!
        
        if (digit == "π")
        {
            digit = "\(M_PI)"
            userTypedDot = true
        }

        if(userIsTyping)
        {
            switch (digit)
            {
                case "." :
                    if (!userTypedDot)
                    {
                        userTypedDot = true
                        fallthrough
                    }
                    else
                    {
                        break
                    }
            default  :
                print("string \(digit)");
                display.text = display.text! + digit
                break
            }
        }
        else
        {
            switch (digit)
            {
                case "." :
                    userTypedDot = true
                    digit = "0."
                    fallthrough
                default  :
                    display.text = digit
                    userIsTyping = true
                    break
            }
        }
    }
    
    
    @IBAction func clear()
    {
        brain.clear();
        display.text = " "
        descriptionLabel.text = " "
        
        
    }
    @IBAction func enter()
    {
        userIsTyping = false
        userTypedDot = false
        
       if let result = brain.pushOperand(displayValue)
        {
            displayValue = result
        }
        else
        {
        displayValue = 0
        }
    }
    
    
    var displayValue : Double
    {
        get{
            return  NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set{
            display.text = "\(newValue)"
            userIsTyping = false
            userTypedDot = false
        }
    }
    
    
    @IBAction func operate(sender: UIButton)
    {
        let operation = sender.currentTitle!
        
        if userIsTyping
        {
            enter()
        }


        let resultString = brain.performOperation(operation)
        
        if let result = resultString.result {
            displayValue = result
            if let text = resultString.description
            {
                descriptionLabel.text = text
            }
        }
        else
        {
            displayValue = 0
        }
    }
}

