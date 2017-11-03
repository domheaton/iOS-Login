//
//  DigitSpan.swift
//  test
//
//  Created by Dominic Heaton on 02/11/2017.
//  Copyright © 2017 Dominic Heaton. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class DigitSpan: UIViewController {
    
    var patternsToTest: [[String]] = []
    var counter = 0
    var subcounter = 0
    var howManyWrong = 0
    
    @IBOutlet weak var patternToTest: UILabel!
    @IBOutlet weak var patternToReturn: UILabel!
    
    private var brain = DigitSpanCalculations()
    
    //Functions to hide navigation bar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        patternsToTest = brain.setPatternsToTestDigit
        brain.zeroScore()
        loadPattern()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! DigitSubtestComplete
        nextVC.finalResultsDigit = brain.getFinalResultsDigit()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func incrementSubcounter() {
        if subcounter == 1 {
            subcounter = 0
            counter = counter + 1
        }
        else if subcounter == 0 {
            subcounter = 1
        }
        else {
            subcounter = 0
            print("Error has occured in subcounter")
        }
    }
    
    func decrementSubcounter() {
        if subcounter == 0 {
            subcounter = 1
            counter = counter - 1
        }
        else if subcounter == 1 {
            subcounter = 0
        }
        else {
            subcounter = 0
            print("Error has occured in subcounter")
        }
    }
    
    func loadPattern() {

        if counter < patternsToTest.count {
            patternToTest.text = patternsToTest[counter][subcounter]
            patternToReturn.text = patternsToTest[counter][subcounter]
            incrementSubcounter()
        }
        else {
            brain.setNumberOfSets(Double(counter))
            brain.calculateResult()
            performSegue(withIdentifier: "toDigitSubtest", sender: nil)
        }
    }
    
    @IBAction func correctPressed(_ sender: UIButton) {
        brain.updateRawScore("correct")
        howManyWrong = 0
        loadPattern()
    }
    
    @IBAction func incorrectPressed(_ sender: UIButton) {
        brain.updateRawScore("incorrect")
        if howManyWrong == 1 {
            brain.setNumberOfSets(Double(counter))
            brain.calculateResult()
            performSegue(withIdentifier: "toDigitSubtest", sender: nil)
        }
        else {
            loadPattern()
            howManyWrong = howManyWrong + 1
        }
        
    }
    
    @IBAction func undoPressed(_ sender: UIButton) {
        if counter > 0 {
            decrementSubcounter()
            decrementSubcounter()
            patternToTest.text = patternsToTest[counter][subcounter]
            patternToReturn.text = patternsToTest[counter][subcounter]
            brain.setRawScore()
            incrementSubcounter()
        }
    }
    
}

