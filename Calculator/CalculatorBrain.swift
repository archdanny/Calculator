//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Daniello on 23/11/15.
//  Copyright © 2015 DDdesigns. All rights reserved.
//

import Foundation


class CalculatorBrain
{
    private var opStack = [Op]()
    private var knownOps = [String:Op]()     //Dictionary<String, Op>
    

    
    private enum Op : CustomStringConvertible
    {
        case Operand(Double)
        case Unairyperation(String, Double -> Double)
        case binairyOperation(String, (Double, Double)->Double)
        
        var description : String
            {
            get
            {
                switch self
                {
                case .Operand( let operand) :
                    return "\(operand)"
                case .binairyOperation(let symbol, _):
                    return symbol
                case .Unairyperation(let symbol, _):
                    return symbol

                }
            }
            
        }

    }
    
    
    init()
    {
        knownOps["×"] = Op.binairyOperation("×", *)
        knownOps["÷"] = Op.binairyOperation("÷") {$1 / $0}
        knownOps["+"] = Op.binairyOperation("+", +)
        knownOps["−"] = Op.binairyOperation("−") {$1 - $0}
        knownOps["√"] = Op.Unairyperation("√",sqrt )
        knownOps["sin"] = Op.Unairyperation("sin",sin)
        knownOps["cos"] = Op.Unairyperation("cos",cos)
        
        variableValues = Dictionary<String,Double>()
    }
    
    
    var program : AnyObject
        {
        get
        {
            return opStack.map{$0.description}
        }
        set
        {
            if let opSymbols = newValue as? Array<String>
            {
               var newOpStack = [Op]()
                for opSymbol in opSymbols
                {
                    if let op = knownOps[opSymbol]
                    {
                        newOpStack.append(op)
                    }
                    else if let operand = NSNumberFormatter().numberFromString(opSymbol)?.doubleValue
                    {
                       // newOpStack.append(.Operand()
                    }
   
                }
            }
        }
    }
    
    
    func pushOperand(operand : Double) ->Double?
    {
        opStack.append(Op.Operand(operand))
        return evaluate().result
    }
    
    
    func performOperation(symbol : String) ->(result :Double?, description :String?)
    {
        if let operation = knownOps[symbol]
        {
            opStack.append(operation)
        }

        return evaluate()
    }
    
    func evaluate() ->(result :Double?, description :String?)
    {
        let (result, remainder) = evaluate(opStack)
        print("\(opStack) = \(result) with \(remainder) left over")
        
        var currentString = descriptionString(opStack).resultString
        if let newString =  descriptionString(remainder).resultString
        {
            if let currentStringCheck =  currentString
            {
                 currentString = newString + "," + currentStringCheck
            }
        }
       
        return (result, currentString)
    }
    
    @nonobjc
    private func evaluate( ops : [Op]) ->(result :Double?, remainingOps :[Op])
    {
        if !ops.isEmpty
        {
            var remainingOps = ops
            let op  = remainingOps.removeLast()
            switch op
            {
                
            case .Operand(let operand) :
                return(operand, remainingOps)
                
            case .Unairyperation(_, let operation) :
                let operandEvalutation = evaluate(remainingOps)
                if let operand = operandEvalutation.result
                {
                    return (operation(operand),operandEvalutation.remainingOps)
                }
                
            case .binairyOperation(_, let operation):
                let operand1Evalutation = evaluate(remainingOps)
                if let operand1 = operand1Evalutation.result
                {
                    let operand2Evalutation = evaluate(operand1Evalutation.remainingOps)
                    if let operand2 = operand2Evalutation.result
                    {
                        return (operation(operand1,operand2), operand2Evalutation.remainingOps)
                    }
                }
                
           // default : break
                
            }
        }
       return (nil, ops)
    }
    
    func clear()
    {
        opStack.removeAll();
    }
    
    func pushOperand(symbol: String) -> Double?
    {
        let returnValue = evaluate().result
        variableValues.updateValue(returnValue!, forKey: symbol)
        return returnValue
    }
    
    var variableValues: Dictionary<String,Double>
    
    
    func descriptionString() -> String
    {
        return descriptionString(opStack).resultString!
    }
    
    private func descriptionString( ops : [Op]) ->(resultString :String?, remainingOps :[Op])
    {
        var returnString = ""
        
        if !ops.isEmpty
        {
            var remainingOps = ops
            let op  = remainingOps.removeLast()
            switch op
                {
                
            case .Operand(_) :
                returnString = returnString + op.description
                return(returnString, remainingOps)
                
            case .Unairyperation(_,  _) :
                    
                let operandEvalutation = descriptionString(remainingOps)
                if let operandString = operandEvalutation.resultString
                {
                    returnString = returnString + op.description +  "(" + operandString  + ")"
                    return (returnString, operandEvalutation.remainingOps)
                }
                
            case .binairyOperation(_,  _):
                let operand1 = descriptionString(remainingOps)
                if let operand1Ev = operand1.resultString
                {
                    let operand2 = descriptionString(operand1.remainingOps)
                    if let operand2Ev = operand2.resultString
                    {
                        if (operand2.remainingOps.count > 0 )
                        {
                            returnString = returnString + "(" + operand2Ev + op.description + operand1Ev + ")"
                        }
                        else
                        {
                            returnString = returnString + operand2Ev + op.description + operand1Ev
                        }
                        return (returnString, operand2.remainingOps)
                    }
                }
            }
        }
        return (returnString, ops)
    }

    
    
    
}