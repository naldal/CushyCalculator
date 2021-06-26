import UIKit

class CustomViewController: UIViewController {
    
    @IBOutlet weak var workField: UILabel!
    
    var operStack: [String] = []
    var result: Int = 0
    var operation = ""
    var reloadTextField = false
    let InitialCalculator: String = "0"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        workField.adjustsFontSizeToFitWidth = true
        workField.text = InitialCalculator
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ModalViewController {
            vc.delegate = self
        }
    }
    
    @IBAction func pressedButton(_ sender: UIButton) {
        if let numberPad = sender.currentTitle {
            if reloadTextField {
                workField.text! = String(numberPad)
                reloadTextField = false
                return
            }
            let currnetField = workField.text!
            if currnetField != InitialCalculator {
                workField.text! += String(numberPad)
            } else {
                workField.text! = String(numberPad)
            }
        }
    }
    
    @IBAction func operatorButton(_ sender: UIButton) {
        if reloadTextField {
            return
        }
        
        var buttonType: String = ""
        
        if let operType = sender.restorationIdentifier {
            buttonType = operType
        }
        
        reloadTextField = true
        let numberInField = workField.text!
    
        if operStack.count == 1 {
            operStack.append(buttonType)
            return
        }
        
        if operStack.isEmpty {
            operStack.append(numberInField)
            operStack.append(buttonType)
        } else {
            operStack.append(numberInField)
            
            guard let first = Double(operStack[0]) else {
                return
            }
            let middleOperator = operStack[1]
            
            guard let second = Double(operStack[2]) else {
                return
            }
    
            
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
            if buttonType == "equalSign" {
                workField.text = String(result)
                operStack.removeAll()
                operStack.append(workField.text!)
                reloadTextField = false
                return
            }
            
            workField.text = String(result)
            operStack[0] = String(result)
            if buttonType != "equalSign" {
                operStack[1] = buttonType
            }
            operStack.removeLast()
                
            
        }
    }

    // special Actions
    @IBAction func percentBtn(_ sender: Any) {
        if let num = workField.text {
            let stringifiedNum:Double = Double(num)! * 0.01
            workField.text = String(stringifiedNum)
        }
    }
    
    @IBAction func plusMinusBtn(_ sender: Any) {
        if let num = workField.text {
            workField.text = String(Double(num)! * -1)
            if operStack.count == 1 {
                operStack[0] = workField.text!
            }
        }
    }
    
    @IBAction func clearBtn(_ sender: Any) {
        DeletedData.deleted.append(workField.text!)
        workField.text = InitialCalculator
        operStack.removeAll()
    }
}

extension CustomViewController: MoveDataDelegate {
    func moveData(_ vc: UIViewController, didInput value: String?) {
        workField.text = value
        operStack.removeAll()
        operStack.append(value!)
    }
    
}
