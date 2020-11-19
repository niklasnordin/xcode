//
//  ViewController.swift
//  calculator
//
//  Created by Niklas Nordin on 2020-05-21.
//

import UIKit

class ViewController: UIViewController
{

    let bgMsgLabelColor = #colorLiteral(red: 0.7676206231, green: 0.9906770587, blue: 0.6379750371, alpha: 1)
    let bgEditLabelColor = #colorLiteral(red: 0.671900034, green: 0.8703789115, blue: 0.5610793233, alpha: 1)

    var calc = CalculatorEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.updateModeButtons()
        self.updateView()
    }

    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var infoLabel1: UILabel!
    
    @IBOutlet weak var modeLabel: UILabel!
    
    @IBOutlet var stack: [UILabel]!
    
    @IBOutlet var modeButtons: [calcButton]!
    
    @IBAction func functionKeyPressed(_ sender: calcButton)
    {
        let tag = sender.tag
        
        switch tag
        {
        case 33:
            calc.funcButtonPressed(funcButton: CalculatorEngine.Func.button_pi)
        case 34:
            calc.funcButtonPressed(funcButton: CalculatorEngine.Func.button_e)
                
        case 100:
            calc.funcButtonPressed(funcButton: CalculatorEngine.Func.button_sin)
        case 101:
            calc.funcButtonPressed(funcButton: CalculatorEngine.Func.button_asin)
        case 102:
            calc.funcButtonPressed(funcButton: CalculatorEngine.Func.button_sinh)
        case 103:
            calc.funcButtonPressed(funcButton: CalculatorEngine.Func.button_asinh)
        case 104:
            calc.funcButtonPressed(funcButton: CalculatorEngine.Func.button_deg)
            
        case 200:
            calc.funcButtonPressed(funcButton: CalculatorEngine.Func.button_cos)
        case 201:
            calc.funcButtonPressed(funcButton: CalculatorEngine.Func.button_acos)
        case 202:
            calc.funcButtonPressed(funcButton: CalculatorEngine.Func.button_cosh)
        case 203:
            calc.funcButtonPressed(funcButton: CalculatorEngine.Func.button_acosh)
        case 204:
            calc.funcButtonPressed(funcButton: CalculatorEngine.Func.button_rad)

        case 300:
            calc.funcButtonPressed(funcButton: CalculatorEngine.Func.button_tan)
        case 301:
            calc.funcButtonPressed(funcButton: CalculatorEngine.Func.button_atan)
        case 302:
            calc.funcButtonPressed(funcButton: CalculatorEngine.Func.button_tanh)
        case 303:
            calc.funcButtonPressed(funcButton: CalculatorEngine.Func.button_atanh)
        case 304:
            calc.funcButtonPressed(funcButton: CalculatorEngine.Func.button_grad)

        default:
            print("tag unkownn")
        }
        updateView()

    }
    
    @IBAction func dotPressed(_ sender: UIButton)
    {
        calc.dotPressed()
        updateView()
    }
    
    @IBAction func numberPressed(_ sender: UIButton)
    {
        calc.digitPressed((sender.titleLabel?.text)!)
        updateView()
    }
    
    @IBAction func enterPressed(_ sender: UIButton)
    {
        calc.enterPressed()
        updateView()
    }
    
    @IBAction func modePressed(_ sender: UIButton)
    {
        let tag = sender.tag
        switch tag
        {
        case 38:
            calc.modePressed(mode: CalculatorEngine.Mode.trig)
        case 39:
            calc.modePressed(mode: CalculatorEngine.Mode.log)
        case 40:
            calc.modePressed(mode: CalculatorEngine.Mode.units)
        case 41:
            calc.modePressed(mode: CalculatorEngine.Mode.funcMode)
        case 42:
            calc.modePressed(mode: CalculatorEngine.Mode.plot)
        default:
            print("no")
        }
        updateView()
        updateModeButtons()
    }
    
    @IBAction func operationPressed(_ sender: UIButton)
    {
        let tag = sender.tag
        //var operation = CalculatorEngine.Operation.addition
        
        switch tag {
        case 1:
            calc.operationKeyPressed(op: CalculatorEngine.Operation.addition)
        case 2:
            calc.operationKeyPressed(op: CalculatorEngine.Operation.subtraction)
        case 3:
            calc.operationKeyPressed(op: CalculatorEngine.Operation.division)
        case 4:
            calc.operationKeyPressed(op: CalculatorEngine.Operation.multiplication)
        case 5:
            calc.operationKeyPressed(op: CalculatorEngine.Operation.changeSign)
        case 6:
            calc.operationKeyPressed(op: CalculatorEngine.Operation.drop)
        case 7:
            calc.operationKeyPressed(op: CalculatorEngine.Operation.swap)
        case 8:
            calc.operationKeyPressed(op: CalculatorEngine.Operation.rotate)
        case 9:
            calc.operationKeyPressed(op: CalculatorEngine.Operation.clear)
        case 10:
            calc.operationKeyPressed(op: CalculatorEngine.Operation.exp)
        case 11:
            calc.operationKeyPressed(op: CalculatorEngine.Operation.backspace)
        case 13:
            calc.operationKeyPressed(op: CalculatorEngine.Operation.inverse)
        case 14:
            calc.operationKeyPressed(op: CalculatorEngine.Operation.squareroot)
        case 15:
            calc.operationKeyPressed(op: CalculatorEngine.Operation.square)
        case 16:
            calc.operationKeyPressed(op: CalculatorEngine.Operation.nthroot)
        case 17:
            calc.operationKeyPressed(op: CalculatorEngine.Operation.power)
        case 400:
            calc.operationKeyPressed(op: CalculatorEngine.Operation.undo)
        default:
            print("null")
        }
        
        updateView()
    }
    
    func updateView()
    {
        //print("stack.count = \(stack.count)")
        //print("calc stack.count = \(calc.stack.count)")
        for (index, lbl) in stack.enumerated()
        {
            if calc.stack.count > index
            {
                //print("index = \(index), v = \(calc.stack[index])")
                lbl.text = calc.stack[index]
            }
            else
            {
                lbl.text = ""
            }
        }
        messageLabel.text = calc.message
        modeLabel.text = calc.modeText
        infoLabel1.text = calc.degreeText
        
        if calc.editMode
        {
            messageLabel.backgroundColor = bgEditLabelColor
        }
        else
        {
            messageLabel.backgroundColor = bgMsgLabelColor
        }
    }
    
    func updateModeButtons()
    {
        for button in modeButtons
        {
            let tag = button.tag
            let row = Int(tag/100) - 1
            let column = tag - 100*(row + 1)
            let text = calc.modeButtons(row: row, col: column)
            //print("text = \(text)")
            button.setTitle(text, for: UIControl.State.normal)
        }
    }
}

