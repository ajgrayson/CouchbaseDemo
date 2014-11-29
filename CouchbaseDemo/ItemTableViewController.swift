//
//  ItemTableViewController.swift
//  CouchbaseDemo
//
//  Created by Johnathan Grayson on 16/11/14.
//  Copyright (c) 2014 Johnathan Grayson. All rights reserved.
//

import UIKit

// @objc etc. here so that the unwindToList func below works
@objc(ItemTableViewController)class ItemTableViewController: UITableViewController {

    var database: CBLDatabase!
    
    var dataSource: CBLUITableSource!
    
    var syncManager: CBLSyncManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        syncManager = appDelegate.syncManager
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if (!syncManager.userIsAuthenticated()) {
            showLoginView({
                self.setupDatasource()
            })
        } else {
            setupDatasource()
        }
    }
    
    func useDatabase(database: CBLDatabase!) -> Bool {
        if database == nil {
            return false
        }
        self.database = database
        
        // Define a view with a map function that indexes to-do items by creation date:
        database.viewNamed("items").setMapBlock("2") {
            (doc, emit) in
            
            let type : String? = doc["type"] as String?
            
            if (type == "item") {
                if let titleObj: AnyObject = doc["title"] {
                    if let title = titleObj as? String {
                        emit(title, doc)
                    }
                }
            }
        }
        
        return true
    }
    
    func setupDatasource() {
        if self.dataSource == nil {
            self.dataSource = CBLUITableSource()
        
            if useDatabase(appDelegate.database) {
                let query = database.viewNamed("items").createQuery().asLiveQuery();
                query.descending = true
            
                self.dataSource.query = query
                self.dataSource.labelProperty = "title"    // Document property to display in the cell label
            }
        }
        
        self.dataSource.reloadFromQuery()
        
        self.tableView.reloadData()
    }
    
    func showLoginView(completion: () -> ()) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let vc = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as UIViewController;
        
        self.navigationController?.presentViewController(vc, animated: true, completion: completion)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.dataSource?.rows != nil) {
            return self.dataSource.rows.count
        }
        return 0
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as UITableViewCell
        
        var row : CBLQueryRow = self.dataSource.rowAtIndexPath(indexPath)
        var doc : CBLDocument = row.document
        
        var docContent : NSMutableDictionary = NSMutableDictionary(dictionary: doc.properties)
        
        var title : NSString = docContent.valueForKey("title") as NSString
        
        cell.textLabel.text = title;
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "EditItem") {
            var nvc : UINavigationController = segue.destinationViewController as UINavigationController
            var vc : AddItemViewController = nvc.topViewController as AddItemViewController
            
            var indexPath : NSIndexPath = self.tableView.indexPathForSelectedRow()!
            
            var row = self.dataSource.rowAtIndexPath(indexPath)
            
            var doc : CBLDocument = row.document
            
            vc.item = Item(forDocument: doc)
        }
    }
    
    @IBAction func unwindToList(segue: UIStoryboardSegue) {
        var source: AddItemViewController = segue.sourceViewController as AddItemViewController
        
        if source.item != nil {
            var item: Item = source.item!
        
            // add it to the database
            self.saveItem(item)
        }
    }
    
    func saveItem(item : Item) {
        var properties : NSMutableDictionary;
        
        if item.id == nil {
            item.type = "item"
            item.owner = syncManager.getUserId()
            //item.channels = [syncManager.getUserId()]
        }
        
        var error: NSError?
        item.save(&error)
        
        if(error != nil) {
            println("Error saving: " + (error != nil ? error!.description : ""))
        }
        
    }
    
    var appDelegate : AppDelegate {
        return UIApplication.sharedApplication().delegate as AppDelegate
    }

}
