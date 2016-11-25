//
//  TodayViewController.swift
//  Shopping List Widget
//
//  Created by Vadim Kononov on 19/11/2016.
//  Copyright © 2016 Vadim Kononov. All rights reserved.
//

import UIKit
import NotificationCenter

let file = "file.txt"

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var items: [Item] = [Item(title: "לחם", isSelected: false), Item(title: "חלב", isSelected: false), Item(title: "גבינה", isSelected: false), Item(title: "בשר", isSelected: false), Item(title: "דגים", isSelected: false)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.preferredContentSize = CGSize(width: 0, height: CGFloat(items.count * 44))
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = items[indexPath.row]
        if !item.isSelected {
            cell.textLabel?.attributedText = NSAttributedString(string: item.title, attributes: [:])
        } else {
            cell.textLabel?.attributedText = NSAttributedString(string: item.title, attributes: [NSStrikethroughStyleAttributeName: NSNumber(value: NSUnderlineStyle.styleSingle.rawValue)])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        items[indexPath.row].isSelected = !items[indexPath.row].isSelected
        let cell = tableView.cellForRow(at: indexPath)
        let item = items[indexPath.row]
        if !item.isSelected {
            cell?.textLabel?.attributedText = NSAttributedString(string: item.title, attributes: [:])
        } else {
            cell?.textLabel?.attributedText = NSAttributedString(string: item.title, attributes: [NSStrikethroughStyleAttributeName: NSNumber(value: NSUnderlineStyle.styleSingle.rawValue)])
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
