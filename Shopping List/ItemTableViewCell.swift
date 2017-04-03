//
//  ItemTableViewCell.swift
//  Shopping List
//
//  Created by Vadim Kononov on 07/11/2016.
//  Copyright © 2016 Vadim Kononov. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    @IBOutlet weak var label: CustomLabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func populate(item: Item) {
        let att = NSMutableAttributedString(string: item.title)
        let range = NSMakeRange(0, item.title.characters.count)
        att.addAttributes([NSFontAttributeName: UIFont.init(name: "HelveticaNeue", size: 18) as Any], range: range)
        if item.isSelected {
            att.addAttributes([NSStrikethroughStyleAttributeName: NSNumber(value: NSUnderlineStyle.styleThick.rawValue)], range: range)
        }
        label.attributedText = att
    }
}

final class CustomLabel: UILabel {
    
    override func drawText(in rect: CGRect) {
        guard let attributedText = attributedText else {
            super.drawText(in: rect)
            return
        }
        
        if #available(iOS 10.3, *) {
            attributedText.draw(in: rect)
        } else {
            super.drawText(in: rect)
        }
    }
}

