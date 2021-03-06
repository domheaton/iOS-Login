//
//  AdminMenu.swift
//  test
//
//  Created by Dominic Heaton on 25/10/2017.
//  Copyright © 2017 Dominic Heaton. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import LocalAuthentication

class AdminMenu: UIViewController {
    
    @IBOutlet weak var welcomeToAdminMenuLabel: UILabel!
    @IBOutlet weak var noteBeforeAdvancing: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //override the back button in the navigation controller
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .done, target: self, action: #selector(self.signOutAdmin(sender:)))
        
        welcomeToAdminMenuLabel.adjustsFontSizeToFitWidth = true
        noteBeforeAdvancing.adjustsFontSizeToFitWidth = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func signOutAdmin(sender: AnyObject) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        self.performSegue(withIdentifier: "signOutAdmin", sender: nil)
    }
    
}
