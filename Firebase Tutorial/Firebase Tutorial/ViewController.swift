//
//  ViewController.swift
//  Firebase Tutorial
//
//  Created by Bogil, John on 3/24/16.
//  Copyright © 2016 Bogil, John. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    var uid = ""
    var userDefauts = NSUserDefaults.standardUserDefaults()
    var ref = Firebase(url: "https://5mintutorial2.firebaseio.com")

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
}