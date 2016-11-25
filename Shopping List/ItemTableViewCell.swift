//
//  ItemTableViewCell.swift
//  Shopping List
//
//  Created by Vadim Kononov on 07/11/2016.
//  Copyright © 2016 Vadim Kononov. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func populate(item: Item) {
        if !item.isSelected {
            label.attributedText = NSAttributedString(string: item.title, attributes: [:])
        } else {
            label.attributedText = NSAttributedString(string: item.title, attributes: [NSStrikethroughStyleAttributeName: NSNumber(value: NSUnderlineStyle.styleSingle.rawValue)])
        }
    }
}
