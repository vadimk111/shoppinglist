//
//  NewItemTableViewCell.swift
//  Shopping List
//
//  Created by Vadim Kononov on 07/11/2016.
//  Copyright © 2016 Vadim Kononov. All rights reserved.
//

import UIKit

protocol NewItemTableViewHeaderDelegate: class {
    func newItemTableViewHeaderDidTapContinue(newItemTableViewHeader: NewItemTableViewHeader)
}

class NewItemTableViewHeader: UIView, UITextFieldDelegate {
    
    weak var delegate: NewItemTableViewHeaderDelegate?
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var button: UIButton!
    
    @IBAction func didTapDone(_ sender: UIButton) {
        delegate?.newItemTableViewHeaderDidTapContinue(newItemTableViewHeader: self)
        textField.text = nil
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.newItemTableViewHeaderDidTapContinue(newItemTableViewHeader: self)
        textField.text = nil
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        button.isHidden = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        button.isHidden = true
    }
}
