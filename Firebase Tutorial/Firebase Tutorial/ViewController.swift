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
    var groupsRef = Firebase(url: "https://5mintutorial2.firebaseio.com/Groups")
    let groups = ["ACLU", "PP", "EANY"]
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createGroups() {
        self.groupsRef.setValue(self.groups)
    }
    
    func userAuth() {
        
        // check if there is a stored UID
        if (userDefauts.stringForKey("uid") != nil) {
            uid = userDefauts.stringForKey("uid")!
            print("We already have a UID")
            
            // retrieve the groups for the associated UID
            //            self.usersRef.observeEventType(.Value, withBlock: { snapshot in
            //                print(snapshot.value.objectForKey(self.uid))
            //                }, withCancelBlock: { error in
            //                    print(error.description)
            //            })
        }
        else {
            // create a UID
            ref.authAnonymouslyWithCompletionBlock { error, authData in
                if error != nil {
                    print("login fail")
                } else {
                    print(authData.uid)
                    print("login sucess")
                    self.uid = authData.uid
                    
                    // save the UID locally
                    self.userDefauts.setValue(self.uid, forKey: "uid")
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
            //[self followInterestGroup:[self.tableViewData objectAtIndex:indexPath.row]];
            self.subscribeToGroup(self.tableViewData.objectAtIndex(indexPath.row))
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
        
        let currentUserRef = self.usersRef.childByAppendingPath(self.uid)
        let currentUserSubscriptionsRef = currentUserRef.childByAppendingPath("subscribedGroups")
        let subscribedGroups = self.tableViewData
        
        currentUserSubscriptionsRef.observeEventType(.Value, withBlock: { snapshot in
            
            if (!snapshot.value.hasChild(sender as! String)) {
                subscribedGroups.addObject(sender)
                currentUserRef.updateChildValues(["subscribedGroups" : subscribedGroups])
                
            }
        })
        
    }
    
    func fetchSubscribedGroups() {
        
        // This is only temporary
        self.tableViewData = []
        
    }
    
    
    
    func unsubscribeToGroup() {
        
    }
}

