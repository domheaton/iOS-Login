//
//  TestCompleted.swift
//  test
//
//  Created by Dominic Heaton on 22/10/2017.
//  Copyright © 2017 Dominic Heaton. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class TestCompleted: UIViewController {
    
    var finalResultsSWE = Double()
    var finalResultsPDE = Double()
    var finalResultsTowre = Double()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! Menu
        nextVC.finalResultsSWE = finalResultsSWE
        nextVC.finalResultsPDE = finalResultsPDE
        nextVC.finalResultsTowre = finalResultsTowre
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.title = "Test Complete"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func returnToMenuPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "returnToMenu", sender: nil)
    }
}
