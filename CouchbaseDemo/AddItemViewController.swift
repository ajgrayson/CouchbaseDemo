//
//  AddItemViewController.swift
//  CouchbaseDemo
//
//  Created by Johnathan Grayson on 16/11/14.
//  Copyright (c) 2014 Johnathan Grayson. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController {

    var item: Item?
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if(self.item != nil) {
            self.titleTextField.text = self.item?.title
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if sender as? NSObject != self.doneButton {
            return
        }
        
        if self.titleTextField.text.utf16Count > 0 {
            if(self.item != nil) {
                self.item?.title = self.titleTextField.text
            } else {
                self.item = Item(newDocumentInDatabase: self.appDelegate.database)
                self.item?.title = self.titleTextField.text
                self.item?.category = "none"
            }
        }
    }
    
    var appDelegate : AppDelegate {
        return UIApplication.sharedApplication().delegate as AppDelegate
    }

}
