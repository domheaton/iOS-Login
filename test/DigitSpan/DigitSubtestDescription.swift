//
//  DigitSubtestDescription.swift
//  test
//
//  Created by Dominic Heaton on 02/11/2017.
//  Copyright © 2017 Dominic Heaton. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class DigitSubtestDescription: UIViewController {
    
    var finalResultsDigit = Double()
    var finalRawDigit = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //For debugging
        print("SubtestDescription: ", finalResultsDigit)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! RevDigitSpan
        nextVC.finalResultsDigit = finalResultsDigit
        nextVC.finalRawDigit = finalRawDigit
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
