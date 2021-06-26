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
        
        reloadTextField = true
        let numberInField = workField.text!
    
        if operStack.count == 1 {
            if let senderIdentifier = sender.restorationIdentifier {
                operStack.append(senderIdentifier)
            }
            return
        }
        
        if operStack.isEmpty {
            operStack.append(numberInField)
            if let senderIdentifier = sender.restorationIdentifier {
                operStack.append(senderIdentifier)
            }
        } else {
            operStack.append(numberInField)
            if let operType = sender.restorationIdentifier {
                let first = Double(operStack[0])!
                let middleOperator = operStack[1]
                let second = Double(operStack[2])!
                
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
                if operType == "equalSign" {
                    workField.text = String(result)
                    operStack.removeAll()
                    operStack.append(workField.text!)
                    reloadTextField = false
                    return
                }
                
                workField.text = String(result)
                operStack[0] = String(result)
                if operType != "equalSign" {
                    operStack[1] = operType
                }
                operStack.removeLast()
                
            }
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
