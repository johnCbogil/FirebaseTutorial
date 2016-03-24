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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get a refernce to the data
        let ref = Firebase(url: "https://5mintutorial2.firebaseio.com/")
        
        // Create two users as dictionaries
        let alanisawesome = ["full_name": "Alan Turinggggg", "date_of_birth": "June 23, 1912"]
        let gracehop = ["full_name": "Grace Hopper", "date_of_birth": "December 9, 1906"]
        
        // Get a reference to the users
        //let usersRef = ref.childByAppendingPath("/users")
        
        // Create a dict of users
        let users = ["alanisawesome": alanisawesome, "gracehop": gracehop]
        
        // Set the users dictionary to the database of users
        ref.setValue(users)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func fiveMinTutorial() {
        // Create a reference to a Firebase location
        let myRootRef = Firebase(url:"https://5mintutorial.firebaseio.com")
        
        // Write data to Firebase
        myRootRef.setValue("Do you have data? You'll love Firebase123.")
        
        // Read data and react to changes
        myRootRef.observeEventType(.Value, withBlock: {
            snapshot in
            print("\(snapshot.key) -> \(snapshot.value)")
        })
        
        myRootRef.createUser("bobtony@example.com", password: "correcthorsebatterystaple",
                             withValueCompletionBlock: { error, result in
                                if error != nil {
                                    // There was an error creating the account
                                    print("there was an error creating the acct")
                                } else {
                                    let uid = result["uid"] as? String
                                    print("Successfully created user account with uid: \(uid)")
                                }
        })
    }

}

