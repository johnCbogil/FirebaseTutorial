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
    var tableViewData : NSMutableArray = [];
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.userAuth()
        self.fetchSubscribedGroups()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func userAuth() {
        // check if there is a stored UID
        if (userDefauts.stringForKey("uid") != nil) {
            uid = userDefauts.stringForKey("uid")!
            print("We already have a UID")
            
            // retrieve the groups for the associated UID
            let usersRef = self.ref.childByAppendingPath("users/\(self.uid)")
            usersRef.observeEventType(.Value, withBlock: { snapshot in
                print(snapshot.value)
                }, withCancelBlock: { error in
                    print(error.description)
            })
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
        
//        if !self.tableViewData.containsObject(self.listOfGroups[indexPath.row]) {
//            self.tableViewData.addObject(self.listOfGroups[indexPath.row])
//            self.saveSubscribedGroups()
//        }
        
//        if (self.selectedSegment == 0) {
//            [self followInterestGroup:[self.tableViewData objectAtIndex:indexPath.row]];
//        }
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
        self.tableViewData = ["ACLU", "PP", "EANY"]
        self.tableView.reloadData()
    }
    
    func fetchSubscribedGroups() {
        ref.observeEventType(.ChildAdded, withBlock: { snapshot in
            self.tableViewData = (snapshot.value.objectForKey(self.uid)) as! NSMutableArray
            self.tableView.reloadData()
        })
    }
    
    func subscribeToGroup() {
        
    }
    
    func unsubscribeToGroup() {
        
    }
}

