//
//  Towre.swift
//  test
//
//  Created by Dominic Heaton on 21/10/2017.
//  Copyright © 2017 Dominic Heaton. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class Towre: UIViewController {
    
    var wordsToTest: [String] = []
    var counter = 0
    var timer = Timer()
    var time = 0
    
    private var brain = TowreBrain()
    
    @IBOutlet weak var wordToTest: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(Towre.checkTimeElapsed), userInfo: nil, repeats: true)
        wordsToTest = brain.setWordsToTest
        brain.setNumberOfWords(Double(wordsToTest.count))
        brain.zeroScore()
        loadWord()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func correctPressed(_ sender: UIButton) {
        brain.updateRawScore("correct")
        loadWord()
    }
    
    @IBAction func incorrectPressed(_ sender: UIButton) {
        brain.updateRawScore("incorrect")
        loadWord()
    }
    
    //Function to increment timer - ends test after 45 Seconds -- Objective-C function call
    @objc func checkTimeElapsed() {
        if time < 45 {
            time += 1
        }
        else {
            //For debugging
            print("Timer Expired")
            
            timer.invalidate()
            time = 0
            brain.calculateResult()
            performSegue(withIdentifier: "towreToTestCompleted", sender: nil)
        }
    }
    
    //Function to load next word from array - or finish test if list completed
    func loadWord() {
        if counter < wordsToTest.count {
            wordToTest.text = wordsToTest[counter]
            counter = counter + 1
        }
        else {
            brain.calculateResult()
            performSegue(withIdentifier: "towreToTestCompleted", sender: nil)
        }
    }
}
