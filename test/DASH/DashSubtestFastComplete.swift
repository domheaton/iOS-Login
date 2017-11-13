//
//  DashSubtestFastComplete.swift
//  test
//
//  Created by Dominic Heaton on 12/11/2017.
//  Copyright © 2017 Dominic Heaton. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class DashSubtestFastComplete: UIViewController {
    
    var copyBestWordsWritten = Double()
    var copyFastWordsWritten = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //For debugging
        print("SubtestCompleted")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! DashAlphabetDescription
        nextVC.copyBestWordsWritten = copyBestWordsWritten
        nextVC.copyFastWordsWritten = copyFastWordsWritten
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.title = "Subtest Complete"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}