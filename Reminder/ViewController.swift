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
    @IBOutlet weak var deleteButton: NSButton!
    
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
                //print(reminderItems.count)
            } catch {}
        }
        tableView.reloadData()
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
                    //print("Not Important")
                    reminder.important = false
                } else {
                    //print("Important")
                    reminder.important = true
                }
                (NSApplication.shared().delegate as? AppDelegate)?.saveAction(nil)
                textField.stringValue = ""
                importantCheckBox.state = 0
                
                getReminderItems()
            }
        }
    }
    
    @IBAction func deleteClicked(_ sender: AnyObject) {
        let reminderItem = reminderItems[tableView.selectedRow]
        if let context = (NSApplication.shared().delegate as? AppDelegate)?.managedObjectContext {
            context.delete(reminderItem)
            (NSApplication.shared().delegate as? AppDelegate)?.saveAction(nil)
            getReminderItems()
            deleteButton.isHidden = true
        }

    }
    
    
    //MARK: TableView Stuff
    func numberOfRows(in tableView: NSTableView) -> Int {
        return reminderItems.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let reminder = reminderItems[row]

        if tableColumn?.identifier == "importantColumn" {
            if let cell = tableView.make(withIdentifier: "importantCell", owner: self) as? NSTableCellView {
                
                if reminder.important {
                    cell.textField?.stringValue = "❗️"
                } else {
                    cell.textField?.stringValue = ""
                }
                return cell
            }
        } else {
            if let cell = tableView.make(withIdentifier: "reminderCell", owner: self) as? NSTableCellView {
                cell.textField?.stringValue = reminder.name!
                return cell
            }
        }
        return nil
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        deleteButton.isHidden = false
    }
    
}

