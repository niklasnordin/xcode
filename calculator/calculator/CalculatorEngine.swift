//
//  CalculatorEngine.swift
//  calculator
//
//  Created by Niklas Nordin on 2020-05-29.
//

//import Complex
import Foundation

class CalculatorEngine
{
    enum degreeMode
    {
        case degree
        case radian
        case grad
    }
    
    enum Func
    {
        case button_pi
        case button_e
        case button_x
        case button_comma
        case button_i
        case button_sin
        case button_asin
        case button_sinh
        case button_asinh
        case button_deg
        case button_cos
        case button_acos
        case button_cosh
        case button_acosh
        case button_rad
        case button_tan
        case button_atan
        case button_tanh
        case button_atanh
        case button_grad
    }
    
    enum Mode {
        case trig
        case log
        case units
        case funcMode
        case plot
    }
    
    enum Operation {
        case addition
        case subtraction
        case division
        case multiplication
        case power
        case swap
        case drop
        case inverse
        case square
        case squareroot
        case clear
        case changeSign
        case rotate
        case backspace
        case exp
        case nthroot
        case undo
    }

    // keep track if the number in the stack was entered by pressing digits or an operation
    var editMode = false
    var funcMode = false
    var message = ""
    var modeText = "Trig"
    var mode = Mode.trig {
        didSet
        {
            switch mode
            {
            case Mode.trig:
                self.modeText = "Trig"
                funcMode = false
            case Mode.log:
                self.modeText = "Log"
                funcMode = false
            case Mode.units:
                self.modeText = "Units"
                funcMode = false
            case Mode.funcMode:
                self.modeText = "Func"
                funcMode = true
            case Mode.plot:
                self.modeText = "Plot"
                funcMode = false
            }
        }
    }
    var degreeText = "deg"
    var degMode = degreeMode.degree {
        didSet
        {
            switch degMode
            {
            case degreeMode.degree:
                degreeText = "deg"
            case degreeMode.radian:
                degreeText = "rad"
            case degreeMode.grad:
                degreeText = "grad"
            }
        }
    }
    
    let deg2rad = Double.pi/180.0
    let grad2rad = Double.pi/200.0
    
    // each button can have alternative functions depending on shift/option/alt
    var shift = false
    var option = false
    var alt = false
    
    var undoStack = [String]()
    
    // make the stack String and not Double for future implementation of equation solver
    var stack = [String]() {
        didSet {
            if stack.count > 0
            {
                if stack[0] == ""
                {
                    if ( !editMode)
                    {
                        stack[0] = "0"
                    }
                }
            }
        }
    }

    func convert2Rad(angle: Double) -> Double
    {
        var factor = 1.0
        if degMode == degreeMode.degree
        {
            factor = deg2rad
        }
        if degMode == degreeMode.grad
        {
            factor = grad2rad
        }
        return angle*factor
    }
    
    func convertRad2CurrentAngle(angle: Double) -> Double
    {
        var factor = 1.0
        if degMode == degreeMode.degree
        {
            factor = deg2rad
        }
        if degMode == degreeMode.grad
        {
            factor = grad2rad
        }
        return angle/factor
    }
    func popStack()
    {
        for (index, _) in stack.enumerated()
        {
            if (index < stack.count-1)
            {
                stack[index] = stack[index+1]
            }
        }
        stack.removeLast()
    }
    
    func pushStack()
    {
        stack.append("")
        let stackLength = stack.count

        for (index, _) in stack.enumerated()
        {
            let si = stackLength - index - 1
            if (index != stackLength - 1)
            {
                //print("tsi = \(si)")
                stack[si] = stack[si-1]
            }
        }
    }
    
    func dotPressed()
    {
        undoStack = stack
        
        if stack.count > 0
        {
            if editMode
            {
                let str = stack[0]
                if !str.contains(".")
                {
                    if str.count > 0
                    {
                        if !stack[0].contains("e")
                        {
                            stack[0] += "."
                        }
                    }
                    else
                    {
                        stack[0] = "0."
                    }
                }
            }
            else
            {
                pushStack()
                stack[0] = "0."
            }
        }
        else
        {
            stack.append("0.")
        }
        editMode = true

    }
    
    func digitPressed(_ key: String)
    {
        undoStack = stack
        
        message = ""
        if !editMode
        {
            if (stack.count > 0)
            {
                if stack[0] != "0"
                {
                    pushStack()
                }
                stack[0] = ""
            }
            else
            {
                stack.append("")
            }
            stack[0] = key
        }
        else
        {
            stack[0] += key
        }
        editMode = true

    }
    
    func funcButtonPressed(funcButton: Func)
    {
        undoStack = stack

        switch funcButton {
        case Func.button_pi:
            pushStack()
            stack[0] = String(Double.pi)
        case Func.button_e:
            pushStack()
            stack[0] = String(M_E)
        default:
            print("hej")
        }
        if stack.count > 0
        {
            let input = Double(stack[0]) ?? 0
            // let arg be the input converted to radians
            var arg = convert2Rad(angle: input)
            
            switch funcButton
            {
            case Func.button_sin:
                switch self.mode {
                case Mode.trig:
                    message = "sin"
                    arg = sin(arg)
                    stack[0] = String(arg)
                case Mode.log:
                    message = "log10"
                    arg = log10(input)
                    stack[0] = String(arg)
                case Mode.units:
                    message = "K"
                    arg = 273.15 + input
                    stack[0] = String(arg)
                default:
                    print("hej in sin")
                }
                
            case Func.button_asin:
                switch self.mode {
                case Mode.trig:
                    message = "asin"
                    arg = asin(input)
                    stack[0] = String(convertRad2CurrentAngle(angle: arg))
                case Mode.log:
                    message = "10^"
                    arg = pow(10.0, input)
                    stack[0] = String(arg)
                case Mode.units:
                    message = "°F"
                    arg = input*9.0/5.0 + 32
                    stack[0] = String(arg)
                default:
                    print("hej in asin")
                }
              
            case Func.button_sinh:
                switch self.mode {
                case Mode.log:
                    message = "sinh"
                    arg = sinh(input)
                    stack[0] = String(arg)
                case Mode.trig:
                    message = "csc"
                    arg = 1.0/sin(arg)
                    stack[0] = String(arg)
                case Mode.units:
                    message = "°C"
                    arg = input - 273.15
                    stack[0] = String(arg)
                default:
                    print("hej in sin")
                }
                 
            case Func.button_asinh:
                switch self.mode {
                case Mode.log:
                    message = "asinh"
                    arg = asinh(input)
                    stack[0] = String(arg)
                case Mode.trig:
                    message = "acsc"
                    arg = asin(1.0/input)
                    stack[0] = String(convertRad2CurrentAngle(angle: arg))
                case Mode.units:
                    message = "°C"
                    arg = (input - 32.0)*5.0/9.0
                    stack[0] = String(arg)
                default:
                    print("yo")
                }
                    
            case Func.button_cos:
                switch self.mode {
                case Mode.trig:
                    message = "cos"
                    arg = cos(arg)
                    stack[0] = String(arg)
                case Mode.log:
                    message = "ln"
                    arg = log(input)
                    stack[0] = String(arg)
                case Mode.units:
                    message = "kg/s"
                    arg = input/3600.0
                    stack[0] = String(arg)
                default:
                    print("hej in cos")
                }
                
            case Func.button_acos:
                switch self.mode {
                case Mode.trig:
                    message = "acos"
                    arg = acos(input)
                    stack[0] = String(convertRad2CurrentAngle(angle: arg))
                case Mode.log:
                    message = "exp"
                    arg = exp(input)
                    stack[0] = String(arg)
                case Mode.units:
                    message = "kg/s"
                    arg = 1.0e-3*input/60.0
                    stack[0] = String(arg)
                default:
                    print("hej in cos")
                }
                
            case Func.button_cosh:
                switch self.mode {
                case Mode.log:
                    message = "cosh"
                    arg = cosh(input)
                    stack[0] = String(arg)
                case Mode.trig:
                    message = "sec"
                    arg = 1.0/cos(arg)
                    stack[0] = String(arg)
                case Mode.units:
                    message = "km/h"
                    arg = 1.852*input
                    stack[0] = String(arg)
                default:
                    print("hej in cos")
                }
                    
            case Func.button_acosh:
                switch self.mode {
                case Mode.log:
                    message = "acosh"
                    arg = acosh(input)
                    stack[0] = String(arg)
                case Mode.trig:
                    message = "asec"
                    arg = acos(1.0/input)
                    stack[0] = String(convertRad2CurrentAngle(angle: arg))
                default:
                    print("hej in acosh")
                }
                        
            case Func.button_tan:
                switch self.mode {
                case Mode.trig:
                    message = "tan"
                    arg = tan(arg)
                    stack[0] = String(arg)
                case Mode.log:
                    message = "log2"
                    arg = log2(input)
                    stack[0] = String(arg)
                case Mode.units:
                    message = "l/min"
                    arg = input/0.06
                    stack[0] = String(arg)
                default:
                    print("hej in tan")
                }
                    
            case Func.button_atan:
                switch self.mode {
                case Mode.trig:
                    message = "atan"
                    arg = atan(input)
                    stack[0] = String(convertRad2CurrentAngle(angle: arg))
                case Mode.log:
                    message = "2^"
                    arg = pow(2.0, input)
                    stack[0] = String(arg)
                case Mode.units:
                    message = "m3/h"
                    arg = 0.06*input
                    stack[0] = String(arg)
                default:
                    print("hej in atan")
                }
                
            case Func.button_tanh:
                switch self.mode {
                case Mode.log:
                    message = "tanh"
                    arg = tanh(input)
                    stack[0] = String(arg)
                case Mode.trig:
                    message = "cot"
                    arg = 1.0/tan(arg)
                    stack[0] = String(arg)
                default:
                    print("hej in tanh")
                }
                
            case Func.button_atanh:
                switch self.mode {
                case Mode.log:
                    message = "atanh"
                    arg = atanh(input)
                    stack[0] = String(arg)
                case Mode.trig:
                    message = "acot"
                    arg = atan(1.0/input)
                    stack[0] = String(convertRad2CurrentAngle(angle: arg))
                default:
                    print("hej in atanh")
                }
            
            default:
                print("hej")
            }
            
            editMode = false
        }
        
        switch self.mode
        {
            // these do not change editMode
        case Mode.trig:
            switch funcButton
            {
            case Func.button_deg:
                degMode = degreeMode.degree
            case Func.button_rad:
                degMode = degreeMode.radian
            case Func.button_grad:
                degMode = degreeMode.grad
            default:
                print("hello")
            }
        default:
            print("hello")
        }
    }
    
    func modePressed(mode:Mode)
    {
        self.mode = mode
    }
    
    // a number should be appended to the end of the first stack string
    func numberPressed(_ key: String)
    {
        message = ""
        if !editMode
        {
            editMode = true
        }
        
        if stack.count > 0
        {
            let line = stack[0]
            let floatValue = line.contains(".")
            
            let value = Double(line)
            let num = Double(key)
            if num != nil
            {
                if value != nil
                {
                    let newValue = 10*(value ?? 0)+(num ?? 0)
                    if floatValue
                    {
                        stack[0] = String(newValue)
                    }
                    else
                    {
                        stack[0] = String(Int(newValue))
                    }
                }
                else
                {
                    let newValue = num ?? 0
                    if floatValue
                    {
                        stack[0] = String(newValue)
                    }
                    else
                    {
                        stack[0] = String(Int(newValue))
                    }
                }
            }
        }
        else
        {
            stack.append(key)
        }
    }
    
    // enter was pressed, so move stacks up one level
    func enterPressed()
    {
        undoStack = stack
        
        if editMode
        {
            editMode = false
            if stack[0].count == 0
            {
                stack[0] = "0"
            }
        }
        else
        {
            if stack.count > 0
            {
                pushStack()
                stack[0] = stack[1]
            }
        }
        //print("hello")
        message = ""
    }
    
    func operationKeyPressed(op operation: Operation)
    {
        if ( operation != Operation.undo)
        {
            undoStack.removeAll()
            for s in stack {
                undoStack.append(s)
            }
        }
        
        //print("enter operationKeyPressed: undoStack")
        //print(undoStack)
        
        switch operation
        {
        case Operation.drop:
            message = "Drop"
            if stack.count > 0
            {
                popStack()
            }
            if stack.count == 0
            {
                stack.append("0")
            }
            editMode = false

        case Operation.addition:
            message = "Addition"
            if stack.count > 1
            {
                let x1 = Double(stack[0]) ?? 0
                let x2 = Double(stack[1]) ?? 0
                let sum = x1 + x2
                popStack()
                stack[0] = String(sum)
            }
            else
            {
                message = "Illegal"
            }
            editMode = false

        case Operation.subtraction:
            message = "Subtract"
            if stack.count > 1
            {
                let x1 = Double(stack[0]) ?? 0
                let x2 = Double(stack[1]) ?? 0
                let sum = x2 - x1
                popStack()
                stack[0] = String(sum)
            }
            else
            {
                message = "Illegal"
            }
            editMode = false

        case Operation.multiplication:
            message = "Multiply"
            if stack.count > 1
            {
                let x1 = Double(stack[0]) ?? 0
                let x2 = Double(stack[1]) ?? 0
                let sum = x2 * x1
                popStack()
                stack[0] = String(sum)
            }
            else
            {
                message = "Illegal"
            }
            editMode = false

        case Operation.division:
            if stack.count > 1
            {
                let x1 = Double(stack[0]) ?? 0
                let x2 = Double(stack[1]) ?? 0
                if x1 != 0
                {
                    message = "Divide"
                    let sum = x2 / x1
                    popStack()
                    stack[0] = String(sum)
                }
                else
                {
                    message = "Div by 0"
                }
            }
            else
            {
                message = "Illegal"
            }
            editMode = false

        case Operation.clear:
            message = "Clear"
            stack.removeAll()
            stack.append("0")
            editMode = false

        case Operation.backspace:
            if stack.count > 0
            {
                message = "←"
                var str = stack[0]
                if str.count > 0
                {
                    if editMode
                    {
                        str.removeLast()
                        stack[0] = str
                    }
                    else
                    {
                        editMode = true
                        pushStack()
                        str.removeLast()
                        stack[0] = str
                    }
                }
            }
            else
            {
                message = "Illegal"
            }
            
        case Operation.swap:
            if stack.count > 1
            {
                message = "Swap"
                let tmp = stack[0]
                stack[0] = stack[1]
                stack[1] = tmp
            }
            else
            {
                message = "Illegal"
            }
            editMode = false

        case Operation.rotate:
            editMode = false
            if stack.count > 2
            {
                message = "Rotate"
                let tmp = stack[0]
                stack[0] = stack[2]
                stack[2] = stack[1]
                stack[1] = tmp
            }
            else
            {
                message = "Illegal"
            }
        case Operation.square:
            message = "x²"
            if stack.count > 0
            {
                let x1 = Double(stack[0]) ?? 0
                let sum = x1*x1
                stack[0] = String(sum)
            }
            else
            {
                message = "Illegal"
            }
            editMode = false

        case Operation.inverse:
            if stack.count > 0
            {
                let x1 = Double(stack[0]) ?? 0
                if x1 != 0
                {
                    message = "1/x"
                    let sum = 1.0 / x1
                    stack[0] = String(sum)
                }
                else
                {
                    message = "Div by 0"
                }
            }
            else
            {
                message = "Illegal"
            }
            editMode = false

        case Operation.squareroot:
            if stack.count > 0
            {
                let x1 = Double(stack[0]) ?? 0
                if x1 > 0
                {
                    message = "√x"
                    let sum = sqrt(x1)
                    stack[0] = String(sum)
                }
                else
                {
                    message = "Illegal"
                }
            }
            else
            {
                message = "Illegal"
            }
            editMode = false

        case Operation.changeSign:
            message = "﹢/﹣"
            if stack.count > 0
            {
                let str = stack[0]
                if !str.contains("e") || !editMode
                {
                    let x1 = Double(stack[0]) ?? 0
                    let sum = -1 * x1
                    stack[0] = String(sum)
                }
                else
                {
                    // split string at 'e' and change exponent sign
                    let splt = str.split(separator: "e")
                    if splt.count > 1
                    {
                        let expValue = splt[1]
                        if expValue.count > 0
                        {
                            var ivalue = Int(expValue) ?? 0
                            ivalue *= -1
                            stack[0] = splt[0] + "e" + String(ivalue)
                        }
                        else
                        {
                            stack[0] = splt[0] + "e-"
                        }
                    }
                }
            }
            else
            {
                message = "Illegal"
            }
            
        case Operation.power:
            if stack.count > 1
            {
                let x1 = Double(stack[0]) ?? 0
                let x2 = Double(stack[1]) ?? 0
                if x1 != 0
                {
                    message = "^"
                    let sum = pow(x2, x1)
                    popStack()
                    stack[0] = String(sum)
                }
            }
            else
            {
                message = "Illegal"
            }
            editMode = false

        case Operation.exp:
            if stack.count > 0
            {
                let str = stack[0]
                if !str.contains("e")
                {
                    message = "e"
                    stack[0] = str + "e"
                    editMode = true
                }
                else
                {
                    message = "Illegal"
                }
            }
        case Operation.nthroot:
            if stack.count > 1
            {
                message = "ʸ√x"
                let x1 = Double(stack[0]) ?? 0
                let x2 = Double(stack[1]) ?? 0
                let answer = pow(x2, 1.0/x1)
                popStack()
                stack[0] = String(answer)
            }
            else
            {
                message = "illegal"
            }
            editMode = false
            
        case Operation.undo:
            //print("Undo")
            message = "Undo"
            //print(stack)
            //print(undoStack)
            var tmpStack = [String]()
            for s in stack {
                tmpStack.append(s)
            }
            stack.removeAll()
            for s in undoStack {
                stack.append(s)
            }
            undoStack.removeAll()
            for s in tmpStack {
                undoStack.append(s)
            }
        }

        //print("exit funcButtonPressed: undoStack")
        //print(undoStack)
        // comment to push with git in terminal
    }

    
    func modeButtons(row r:Int, col c:Int) -> String
    {
        var buttons = [String]()
        let idx = r*5 + c
        //print("r = \(r), c = \(c)")
        switch mode
        {
        case Mode.trig:
            buttons.append(contentsOf: ["sin", "asin", "csc", "acsc", "deg"])
            buttons.append(contentsOf: ["cos", "acos", "sec", "asec", "rad"])
            buttons.append(contentsOf: ["tan", "atan", "cot", "acot", "grad"])

        case Mode.log:
            buttons.append(contentsOf: ["log10", "10^", "sinh", "asinh", ""])
            buttons.append(contentsOf: ["ln", "exp", "cosh", "acosh", ""])
            buttons.append(contentsOf: ["log2", "2^", "tanh", "atanh", ""])

        case Mode.units:
            buttons.append(contentsOf: ["°C→K", "°C→°F", "K→°C", "°F→°C", "→"])
            buttons.append(contentsOf: ["kg/h→kg/s", "g/min→kg/s", "knop→km/h", "→", "→"])
            buttons.append(contentsOf: ["m3/h→l/min", "l/min→m3/h", "→", "→", "→"])

        case Mode.funcMode:
            buttons.append(contentsOf: ["(", ")", "", "", ""])
            buttons.append(contentsOf: ["", "", "", "", ""])
            buttons.append(contentsOf: ["", "", "", "", ""])

        case Mode.plot:
            buttons.append(contentsOf: ["", "", "", "", ""])
            buttons.append(contentsOf: ["", "", "", "", ""])
            buttons.append(contentsOf: ["", "", "", "", ""])

        }
        
        return buttons[idx]
    }
    
    
     init()
     {
     // read the database
     //print("init calculator")
        if self.stack.count == 0
        {
            stack.append("0")
        }
     }
     
}

