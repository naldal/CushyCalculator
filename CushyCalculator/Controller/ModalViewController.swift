//
//  ModalViewController.swift
//  CushyCalculator
//
//  Created by 송하민 on 2021/06/26.
//

import UIKit


protocol MoveDataDelegate {
    func moveData(didInput value: String?)
}

class ModalViewController: UIViewController {
    var delegate: MoveDataDelegate?
    
    let deletedList = DeletedData.deleted
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ModalViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DeletedData.deleted.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = deletedList[indexPath.row]
        return cell
    }
}

extension ModalViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.moveData(didInput: deletedList[indexPath.row])
        dismiss(animated: true, completion: nil)
    }
}
