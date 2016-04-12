//
//  ViewController.swift
//  Firebase Tutorial
//
//  Created by Bogil, John on 3/24/16.
//  Copyright © 2016 Bogil, John. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var uid = ""
    var userDefauts = NSUserDefaults.standardUserDefaults()
    var ref = Firebase(url: "https://5mintutorial2.firebaseio.com")
    var usersRef = Firebase(url: "https://5mintutorial2.firebaseio.com/users")
    var groupsRef = Firebase(url: "https://5mintutorial2.firebaseio.com/groups")
    let groups = ["ACLU", "PP", "EANY"]
    let subscribedGroups : NSMutableArray = []
    
    var tableViewData : NSMutableArray = [];
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.userAuth()
        self.fetchGroups()
        self.createGroups()
    }
    
    func createGroups() {
        self.groupsRef.setValue(self.groups)
    }
    
    func userAuth() {
        
        // Check if there is a stored UID
        if (userDefauts.stringForKey("uid") != nil) {
            uid = userDefauts.stringForKey("uid")!
            print("We already have a UID")
        }
        else {
            // Create a UID
            ref.authAnonymouslyWithCompletionBlock { error, authData in
                if error != nil {
                    print("login fail")
                } else {
                    print(authData.uid)
                    print("login sucess")
                    self.uid = authData.uid
                    
                    // Save the UID locally
                    self.userDefauts.setValue(self.uid, forKey: "uid")
                    
                    // Save the UID remotely
                    self.usersRef.setValue(self.uid)
                }
            }
        }
    }
    
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
        
        return self.tableViewData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        cell.textLabel?.text = self.tableViewData[indexPath.row] as? String
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if (self.segmentControl.selectedSegmentIndex == 0) {
            self.subscribeToGroup(self.tableViewData.objectAtIndex(indexPath.row))
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        if self.segmentControl.selectedSegmentIndex == 0 {
            return false
        }
        else {
            return true
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    @IBAction func indexChanged(sender: AnyObject) {
        
        if self.segmentControl.selectedSegmentIndex == 0 {
            self.fetchGroups()
        }
        else {
            self.fetchSubscribedGroups()
        }
        self.tableView.reloadData()
    }
    
    func fetchGroups() {
        
        self.groupsRef.observeEventType(.Value, withBlock: { snapshot in
            print(snapshot.value)
            self.tableViewData = snapshot.value as! NSMutableArray
            self.tableView.reloadData()
            }, withCancelBlock: { error in
                print(error.description)
        })
    }
    
    func subscribeToGroup(sender: AnyObject) {
        
        if (!self.subscribedGroups.containsObject(sender)) {
            self.subscribedGroups.addObject(sender)
            let subscribedGroupsRef = Firebase(url: "https://5mintutorial2.firebaseio.com/users/\(self.uid)/subscribedGroups")
            subscribedGroupsRef.setValue(self.subscribedGroups)
        }
    }
    
    func fetchSubscribedGroups() {
        
        let subscribedGroupsRef = Firebase(url: "https://5mintutorial2.firebaseio.com/users/\(self.uid)/subscribedGroups")
        
        subscribedGroupsRef.observeEventType(.Value, withBlock: { snapshot in
            print(snapshot.value)
            self.tableViewData = snapshot.value as! NSMutableArray
            self.tableView.reloadData()
            }, withCancelBlock: { error in
                print(error.description)
        })
    }
    
    func unsubscribeToGroup() {
        
    }
}

