//
//  Item.swift
//  Shopping List
//
//  Created by Vadim Kononov on 24/11/2016.
//  Copyright © 2016 Vadim Kononov. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Item: NSObject {
    
    private let titleKey = "title"
    private let isSelectedKey = "isSelected"
    
    var title: String!
    var isSelected: Bool = false
    private var ref: DatabaseReference?
    
    init(title: String, isSelected: Bool) {
        self.title = title
        self.isSelected = isSelected
    }
    
    init(snapshot: DataSnapshot) {
        ref = snapshot.ref
        let snapshotValue = snapshot.value as! [String: AnyObject]
        title = snapshotValue[titleKey] as! String
        isSelected = snapshotValue[isSelectedKey] as! Bool
    }
    
    func toAnyObject() -> Any {
        return [
            titleKey: title,
            isSelectedKey: isSelected
        ]
    }

    func delete() {
        ref?.removeValue()
    }
    
    func markSelected(_ isSelected: Bool) {
        ref?.updateChildValues([isSelectedKey : isSelected])
    }
    
    func updateTitle(_ text: String?) {
        if let _ = text {
            ref?.updateChildValues([titleKey : text!])
        }
    }
}
