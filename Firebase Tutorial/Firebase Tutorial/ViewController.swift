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
    let listOfGroups = ["ACLU", "PP", "EANY"]
    var listOfSelectedGroups : NSMutableArray = [];
    //@property (strong, nonatomic) NSMutableArray *tableViewData;

    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
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
                    
                    // save the UID remotely
                    let usersRef = self.ref.childByAppendingPath("users")
                    let groups = ["ACLU", "PP", "EANY"]
                    usersRef.updateChildValues([self.uid : groups])
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
        if self.segmentControl.selectedSegmentIndex == 0 {
            return self.listOfGroups.count
        }
        else {
            return self.listOfSelectedGroups.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        if self.segmentControl.selectedSegmentIndex == 0 {
            cell.textLabel?.text = self.listOfGroups[indexPath.row]
        }
        else {
            cell.textLabel?.text = self.listOfSelectedGroups[indexPath.row] as? String
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if !self.listOfSelectedGroups.containsObject(self.listOfGroups[indexPath.row]) {
            self.listOfSelectedGroups.addObject(self.listOfGroups[indexPath.row])
        }
    }
    
    @IBAction func indexChanged(sender: AnyObject) {
        self.tableView.reloadData()
    }
}

