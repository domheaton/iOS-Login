//
//  DashCopyFastDescription.swift
//  test
//
//  Created by Dominic Heaton on 12/11/2017.
//  Copyright © 2017 Dominic Heaton. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class DashCopyFastDescription: UIViewController {
    
    var copyBestWordsWritten = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //For debugging
        print("SubtestDescription")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! DashCopyFast
        nextVC.copyBestWordsWritten = copyBestWordsWritten
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.title = "Description"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
