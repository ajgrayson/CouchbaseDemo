//
//  ItemTableViewController.swift
//  CouchbaseDemo
//
//  Created by Johnathan Grayson on 16/11/14.
//  Copyright (c) 2014 Johnathan Grayson. All rights reserved.
//

import UIKit

private let kServerUrl = NSURL(string: "http://localhost:4985/default/")

@objc(ItemTableViewController)class ItemTableViewController: UITableViewController {

    var database: CBLDatabase!
    
    var dataSource: CBLUITableSource!
    
    private var _push: CBLReplication!
    private var _pull: CBLReplication!
    private var _syncError: NSError?
    
    // var items = [Item]()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }
    
    func notSignedIntoFacebook() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let vc = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as UIViewController;
        //self.presentViewController(vc, animated: true, completion: nil);
        
        self.navigationController?.presentViewController(vc, animated: true, completion: nil)
    }
    
    func signedIntoFacebook() {
        if self.dataSource == nil {
            self.dataSource = CBLUITableSource()
        
            if useDatabase(appDelegate.database) {
                let query = database.viewNamed("items").createQuery().asLiveQuery();
                query.descending = true
            
                self.dataSource.query = query
                self.dataSource.labelProperty = "title"    // Document property to display in the cell label
            }
        
            self.dataSource.tableView = self.tableView
        
            _push = setupReplication(database.createPushReplication(kServerUrl))
            _pull = setupReplication(database.createPullReplication(kServerUrl))
            
            var auth : CBLAuthenticatorProtocol = CBLAuthenticator.facebookAuthenticatorWithToken(FBSession.activeSession().accessTokenData.accessToken)
            
            _push.authenticator = auth
            _pull.authenticator = auth
            
            _push.start()
            _pull.start()
        }
        
        // self.tableView.dataSource = self.dataSource
        
        self.dataSource.reloadFromQuery()
        
        self.tableView.reloadData()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if (!FBSession.activeSession().isOpen) {
            self.notSignedIntoFacebook()
        } else {
            self.signedIntoFacebook()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            
            var docContent : NSMutableDictionary = NSMutableDictionary(dictionary: doc.properties)
            
            vc.item = Item(id: doc.documentID, title: docContent.valueForKey("title") as String, category: docContent.valueForKey("category") as String)
        }
    }
    
    @IBAction func unwindToList(segue: UIStoryboardSegue) {
        var source: AddItemViewController = segue.sourceViewController as AddItemViewController
        
        if source.item != nil {
            var item: Item = source.item!
        
            // add it to the database
            self.addItemToDatabase(item.id, title: item.title, category: item.category)
        }
    }
    
    func addItemToDatabase(id: String?, title: String, category: String) {
        var properties : NSMutableDictionary;
        
        var doc : CBLDocument
        
        if id != nil && id != "" {
            doc = self.database.existingDocumentWithID(id)

            properties = NSMutableDictionary(dictionary: doc.properties)
            properties["title"] = title
            properties["category"] = category
            
        } else {
            doc = self.database.createDocument()
            properties = ["title": title, "category": category, "type": "item"]
        }
        
        var error: NSError?
        
        if doc.putProperties(properties, error: &error) == nil {
            
        }
        
    }

    func setupReplication(replication: CBLReplication!) -> CBLReplication! {
        if replication != nil {
            replication.continuous = true
            //            NSNotificationCenter.defaultCenter().addObserver(self,
            //                selector: "replicationProgress:",
            //                name: kCBLReplicationChangeNotification,
            //                object: replication)
        }
        return replication
    }

    
    var appDelegate : AppDelegate {
        return UIApplication.sharedApplication().delegate as AppDelegate
    }

}
