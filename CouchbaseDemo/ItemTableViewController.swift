//
//  ItemTableViewController.swift
//  CouchbaseDemo
//
//  Created by Johnathan Grayson on 16/11/14.
//  Copyright (c) 2014 Johnathan Grayson. All rights reserved.
//

import UIKit

@objc(ItemTableViewController)class ItemTableViewController: UITableViewController {

    var database: CBLDatabase!
    
    var dataSource: CBLUITableSource!
    
    // var items = [Item]()
    
    func useDatabase(database: CBLDatabase!) -> Bool {
        if database == nil {
            return false
        }
        self.database = database
        
        // Define a view with a map function that indexes to-do items by creation date:
        database.viewNamed("items").setMapBlock("2") {
            (doc, emit) in
            if let titleObj: AnyObject = doc["title"] {
                if let title = titleObj as? String {
                    emit(title, doc)
                }
            }
        }
        
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
//        self.items = [
//            Item(Title: "Hammer", Category: "Tools"),
//            Item(Title: "Knife", Category: "Utensils")
//        ]
        
        if self.dataSource == nil {
            self.dataSource = CBLUITableSource()
        }

        if useDatabase(appDelegate.database) {
            let query = database.viewNamed("items").createQuery().asLiveQuery();
            
            self.dataSource.query = query
            self.dataSource.labelProperty = "title"    // Document property to display in the cell label
        }
        
        self.tableView.dataSource = self.dataSource
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 0 // self.items.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as UITableViewCell

//        let item = self.items[indexPath.row]
//        
//        cell.textLabel.text = item.Title
//        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator

        return cell
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func unwindToList(segue: UIStoryboardSegue) {
        var source: AddItemViewController = segue.sourceViewController as AddItemViewController
        
        if source.item != nil {
            var item: Item = source.item!
        
            // add it to the database
            self.addItemToDatabase(item.Title, category: item.Category)
        
            self.tableView.reloadData()
        }
    }
    
    func addItemToDatabase(title: String, category: String) {
        var properties = ["title": title, "category": category];
        
        var doc = self.database.createDocument()
        
        var error: NSError?
        
        if doc.putProperties(properties, error: &error) == nil {
            
        }
        
    }

    var appDelegate : AppDelegate {
        return UIApplication.sharedApplication().delegate as AppDelegate
    }

}
