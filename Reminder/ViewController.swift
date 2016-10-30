//
//  ViewController.swift
//  Reminder
//
//  Created by Terry Johnson on 10/29/16.
//  Copyright © 2016 Terry Johnson. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var importantCheckBox: NSButton!
    @IBOutlet weak var tableView: NSTableView!
    
    var reminderItems : [Reminder] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getReminderItems()
    }
    
    func getReminderItems() {
        
        if let context = (NSApplication.shared().delegate as? AppDelegate)?.managedObjectContext {
            
            do {
                reminderItems = try context.fetch(Reminder.fetchRequest())
                print(reminderItems.count)
            } catch {}
        }
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func addClicked(_ sender: AnyObject) {
        if textField.stringValue != "" {
            if let context = (NSApplication.shared().delegate as? AppDelegate)?.managedObjectContext {
                let reminder = Reminder(context: context)
                reminder.name = textField.stringValue
                if importantCheckBox.state == 0 {
                    reminder.important = false
                } else {
                    reminder.important = true
                }
                (NSApplication.shared().delegate as? AppDelegate)?.saveAction(nil)
                textField.stringValue = ""
                importantCheckBox.state = 0
                
                getReminderItems()
            }
        }
    }
    
    //MARK: TableView Stuff
    func numberOfRows(in tableView: NSTableView) -> Int {
        return reminderItems.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let cell = tableView.make(withIdentifier: "importantCell", owner: self) as? NSTableCellView {
            cell.textField?.stringValue = "YELLOW"
            return cell
        }
        return nil
    }
    
}

