//
//  ViewController.swift
//  Shopping List
//
//  Created by Vadim Kononov on 07/11/2016.
//  Copyright © 2016 Vadim Kononov. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NewItemTableViewHeaderDelegate, ItemTableViewCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableBottomConstraint: NSLayoutConstraint!
    
    var list: DatabaseReference!
    var items: [Item] = []
    var showCompleted = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardDidShow, object: nil, queue: nil, using: { (notification: Notification) in
            if let bounds = notification.userInfo?["UIKeyboardBoundsUserInfoKey"] as? CGRect {
                self.tableBottomConstraint.constant = bounds.height - 44
            }
        })
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: nil, using: { (notification: Notification) in
            self.tableBottomConstraint.constant = 0
        })
        
        loadList()
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func loadList() {
        let ref = Database.database().reference().child("ShoppingLists")
        if let listId = UserDefaults.standard.string(forKey: "listId") {
            list = ref.child(listId)
        } else {
            list = ref.childByAutoId()
            UserDefaults.standard.set(list.key, forKey: "listId")
            UserDefaults.standard.synchronize()
        }
        
        list.observe(.value, with: { snapshot in
            self.items = []
            for child in snapshot.children {
                self.items.append(Item(snapshot: child as! DataSnapshot))
            }
            self.tableView.reloadData()
        })
    }
    
    func reloadList() {
        list.removeAllObservers()
        loadList()
    }
    
    func getItems() -> [Item] {
        return showCompleted ?  items : items.filter() { $0.isSelected == false }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getItems().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ItemTableViewCell
        cell.populate(item: getItems()[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view =  Bundle.main.loadNibNamed("NewItemTableViewHeader", owner: self, options: nil)?.first as! NewItemTableViewHeader
        view.delegate = self
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = getItems()[indexPath.row]
        item.markSelected(!item.isSelected)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        becomeFirstResponder()
        
        var actions = [UITableViewRowAction]()
        
        let edit = UITableViewRowAction.init(style: UITableViewRowActionStyle.normal, title: "ערוך", handler: { (action: UITableViewRowAction, indexPath: IndexPath) -> Void in
            tableView.setEditing(false, animated: true)
            let cell = tableView.cellForRow(at: indexPath) as! ItemTableViewCell
            cell.edit()
        })
        actions.append(edit)
        
        let delete = UITableViewRowAction.init(style: UITableViewRowActionStyle.normal, title: "מחק", handler: { (action: UITableViewRowAction, indexPath: IndexPath) -> Void in
            self.getItems()[indexPath.row].delete()
        })
        actions.append(delete)
        
        return actions
    }
    
    func itemTableViewCell(_ itemTableViewCell: ItemTableViewCell, endEditingWith text: String?) {
        if let indexPath = tableView.indexPath(for: itemTableViewCell) {
            getItems()[indexPath.row].updateTitle(text)
        }
    }

    func newItemTableViewHeaderDidTapContinue(newItemTableViewHeader: NewItemTableViewHeader) {
        if let str = newItemTableViewHeader.textField.text, str.count > 0 {
            list.childByAutoId().setValue(Item(title: str, isSelected: false).toAnyObject())
        }
    }
        
    @IBAction func didTapClear(_ sender: UIButton) {
        let a = UIAlertController(title: "למחוק את כל הפריטים?", message: "", preferredStyle: UIAlertControllerStyle.alert)
        a.addAction(UIAlertAction(title: "אישור", style: .default) { action -> Void in
            self.list.removeValue()
        })
        a.addAction(UIAlertAction(title: "ביטול", style: .default) { action -> Void in })
        self.present(a, animated: true, completion: nil)
    }
    
    @IBAction func didTapHide(_ sender: UIButton) {
        showCompleted = !showCompleted
        tableView.reloadData()
        
        var str: String
        if showCompleted {
            str = "הסתר מסומנים"
        } else {
            str = "הראה מסומנים"
        }
        sender.setTitle(str, for: UIControlState.normal)
    }
    
    @IBAction func didTapShare(_ sender: UIButton) {
        if let url = NSURL(string: "list.shopping://" + (list.key ?? "")) {
            let objectsToShare = ["רשימת הקניות:", url] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = sender
            present(activityVC, animated: true, completion: nil)
        }
    }
}

