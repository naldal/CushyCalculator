import UIKit

class CustomViewController: UIViewController {
    
    @IBOutlet weak var workField: UILabel!
    
    @IBOutlet var buttons: [UIButton]!
    
    var operStack: [String] = []
    var result: Int = 0
    var operation = ""
    var reloadTextField = false
    var isDotContains = false
    let InitialCalculator: String = "0"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        workField.adjustsFontSizeToFitWidth = true
        workField.text = InitialCalculator
        
        buttons.forEach { button in
            button.setBackgroundColor(.white, for: .highlighted)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ModalViewController {
            vc.delegate = self
        }
    }
    
    @IBAction func pressedButton(_ sender: UIButton) {
        if let numberPad = sender.currentTitle {
            if numberPad == "." {
                guard isDotContains == false else {
                    return
                }
                isDotContains = true
            }
            if reloadTextField {
                workField.text! = String(numberPad)
                reloadTextField = false
                return
            }
            let currnetField = workField.text!
            if currnetField != InitialCalculator {
                workField.text! += String(numberPad)
            } else {
                if numberPad == "." {
                    workField.text! += String(numberPad)
                } else {
                    workField.text! = String(numberPad)
                }
            }
        }
    }
    
    @IBAction func operatorButton(_ sender: UIButton) {
        
        if reloadTextField {
            return
        }
        guard let operType = sender.restorationIdentifier else {
            return
        }
        
        reloadTextField = true
        let numberInField = workField.text!
    
        if operStack.count == 1 {
            operStack.append(operType)
            return
        }
        
        if operStack.isEmpty {
            operStack.append(numberInField)
            operStack.append(operType)
        } else {
            operStack.append(numberInField)
            
            guard let first = Double(operStack[0]) else {
                return
            }
            guard let second = Double(operStack[2]) else {
                return
            }
            let middleOperator = operStack[1]
            
            var result: Double = Double(InitialCalculator)!
            switch middleOperator {
            case "plus":
                result = first + second
            case "minus":
                result = first - second
            case "multi":
                result = first * second
            case "divide":
                result = first / second
            default:
                break
            }
            
            var finRes: String = String(result)
            if result == ceil(result) {
                finRes.removeSubrange(finRes.firstIndex(of: ".")!..<finRes.endIndex)
            }
            if operType == "equalSign" {
                workField.text = finRes
                operStack.removeAll()
                operStack.append(workField.text!)
                reloadTextField = false
                return
            } else if operType != "equalSign" {
                operStack[1] = operType
            }
            
            workField.text = finRes
            operStack[0] = finRes
        
            operStack.removeLast()
        }
    }

    @IBAction func percentBtn(_ sender: UIButton) {
        if let num = workField.text {
            let stringifiedNum:Double = Double(num)! * 0.01
            workField.text = String(stringifiedNum)
        }
    }
    
    @IBAction func plusMinusBtn(_ sender: UIButton) {
        if let num = workField.text {
            workField.text = String(Double(num)! * -1)
            if operStack.count == 1 {
                operStack[0] = workField.text!
            }
        }
    }
    
    @IBAction func clearBtn(_ sender: UIButton) {
        DeletedData.deleted.append(workField.text!)
        workField.text = InitialCalculator
        operStack.removeAll()
        isDotContains = false
    }
}

extension CustomViewController: MoveDataDelegate {
    func moveData(_ vc: UIViewController, didInput value: String?) {
        workField.text = value
        operStack.removeAll()
        operStack.append(value!)
    }
    
}
