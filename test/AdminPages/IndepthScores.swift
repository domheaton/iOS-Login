//
//  IndepthScores.swift
//  test
//
//  Created by Dominic Heaton on 06/11/2017.
//  Copyright © 2017 Dominic Heaton. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import Charts

class IndepthScores: UIViewController {
    
    var getName = String()
    var getTest = String()
    var getTowreSWE = Double()
    var getTowrePDE = Double()
    var getTowre2 = Double()
    var getForwardDigitSpan = Double()
    var getRevDigitSpan = Double()
    var getDigitSpan = Double()
    
    var testArray: [String]!
    var testScoresToDisplay: [Double]!
    var selectedBarFromChart: String?
    var descriptionSWE: String?
    var descriptionPDE: String?
    var digitSpanPercentage: Double?
    var digitSpanPercentile: String?
    var towrePercentageSWE: Double?
    var towrePercentagePDE: Double?
    
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var nameOfStudentLabel: UILabel!
    @IBOutlet weak var nameOfTestLabel: UILabel!
    @IBOutlet weak var subtest1Label: UILabel!
    @IBOutlet weak var subtest2Label: UILabel!
    @IBOutlet weak var subtest1Score: UILabel!
    @IBOutlet weak var subtest2Score: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Test Breakdown"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save Graph", style: UIBarButtonItemStyle.plain, target: self, action: #selector(saveGraph))
        getDetails()
        
        barChartView.noDataText = "Hmmm, there should be some data around here somewhere."
        updateGraph()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getDetails() {
        self.nameOfStudentLabel.text = getName
        self.nameOfTestLabel.text = getTest
        if getTest == "Towre-2" {
            self.subtest1Label.text = "TowreSWE Result Descriptor:"
            self.subtest2Label.text = "TowrePDE Result Descriptor:"

            getDescriptionSWE()
            getDescriptionPDE()
            
            self.subtest1Score.text = descriptionSWE
            self.subtest2Score.text = descriptionPDE
        }
        else if getTest == "Digit Span" {
            
            self.subtest1Label.text = "Test Percentage:"
            self.subtest2Label.text = "Percentile Equivalent:"
            
            testPercentage()
            getDigitSpanPercentile()
            
            //For debugging
            print("getDigitSpan: ", getDigitSpan)
            print("digitSpanPercentile: ", digitSpanPercentile!)
            print("digitSpanPercentage: ", digitSpanPercentage!)
            
            self.subtest1Score.text = String(Float(digitSpanPercentage!))
            self.subtest2Score.text = digitSpanPercentile!
        }
    }
    
    @objc func saveGraph() {
        let image = barChartView.getChartImage(transparent: false)
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        
        let alertController = UIAlertController(title: "Graph Saved", message: "The graph has been saved to Photos", preferredStyle: UIAlertControllerStyle.actionSheet)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    func updateGraph() {
        var dataEntries: [BarChartDataEntry] = []
        
        //select only the scores that are available
        if getTowreSWE == 0 || getTowrePDE == 0 {
            testArray = ["Forward Digit Span", "Reverse Digit Span"]
            testScoresToDisplay = [getForwardDigitSpan, getRevDigitSpan]
        }
        else if getForwardDigitSpan == 0 || getRevDigitSpan == 0 {
            testArray = ["TowreSWE", "TowrePDE"]
            testScoresToDisplay = [towrePercentageSWE!, towrePercentagePDE!]
        }
        
        for i in 0..<testArray.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: testScoresToDisplay[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Test Results for: " + getName)
        barChartView.chartDescription?.text = ""
        let chartData = BarChartData(dataSet: chartDataSet)
        
        chartDataSet.colors = [UIColor(red: 74/255, green: 205/255, blue: 168/255, alpha: 1)]
        barChartView.xAxis.labelPosition = .bottom
        barChartView.animate(xAxisDuration: 0.0, yAxisDuration: 2.0)
        
        if getTest == "Towre-2" {
            let scaledLimitline = (100.0 / 145.0) * 100.0
            let limitline = ChartLimitLine(limit: scaledLimitline, label: "Average")
            barChartView.leftAxis.addLimitLine(limitline)
            let scaledLowerLimitline = (86.0 / 145.0) * 100.0
            let limitlineLower = ChartLimitLine(limit: scaledLowerLimitline, label: "Below Average")
            barChartView.leftAxis.addLimitLine(limitlineLower)
            let scaledUpperLimitline = (116.0 / 145.0) * 100.0
            let limitlineUpper = ChartLimitLine(limit: scaledUpperLimitline, label: "Above Average")
            barChartView.leftAxis.addLimitLine(limitlineUpper)
        }
        
        barChartView.xAxis.labelFont = UIFont(name: "HelveticaNeue", size: 10.0)!
        barChartView.legend.font = UIFont(name: "HelveticaNeue", size: 10.0)!
        barChartView.leftAxis.labelFont = UIFont(name: "HelveticaNeue", size: 10.0)!
        chartDataSet.valueFont = UIFont(name: "HelveticaNeue", size: 12.0)!
        barChartView.leftAxis.axisMinimum = 0.0
        barChartView.leftAxis.axisMaximum = 105.0
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.rightAxis.enabled = false
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: testArray)
        barChartView.doubleTapToZoomEnabled = false
        
        barChartView.xAxis.granularity = 1
        
        barChartView.data = chartData
    }
    
    func getDescriptionSWE() {
        if getTowreSWE < 70 {
            descriptionSWE = "Very Poor"
        }
        else if getTowreSWE >= 70 && getTowreSWE < 80 {
            descriptionSWE = "Poor"
        }
        else if getTowreSWE >= 80 && getTowreSWE < 90 {
            descriptionSWE = "Below Average"
        }
        else if getTowreSWE >= 90 && getTowreSWE < 111 {
            descriptionSWE = "Average"
        }
        else if getTowreSWE >= 111 && getTowreSWE < 121 {
            descriptionSWE = "Above Average"
        }
        else if getTowreSWE >= 121 && getTowreSWE < 131 {
            descriptionSWE = "Superior"
        }
        else if getTowreSWE >= 131 {
            descriptionSWE = "Very Superior"
        }
        towrePercentageSWE = (getTowreSWE / 145.0) * 100.0
    }
    
    func getDescriptionPDE() {
        if getTowrePDE < 70 {
            descriptionPDE = "Very Poor"
        }
        else if getTowrePDE >= 70 && getTowrePDE < 80 {
            descriptionPDE = "Poor"
        }
        else if getTowrePDE >= 80 && getTowrePDE < 90 {
            descriptionPDE = "Below Average"
        }
        else if getTowrePDE >= 90 && getTowrePDE < 111 {
            descriptionPDE = "Average"
        }
        else if getTowrePDE >= 111 && getTowrePDE < 121 {
            descriptionPDE = "Above Average"
        }
        else if getTowrePDE >= 121 && getTowrePDE < 131 {
            descriptionPDE = "Superior"
        }
        else if getTowrePDE >= 131 {
            descriptionPDE = "Very Superior"
        }
        towrePercentagePDE = (getTowrePDE / 145.0) * 100.0
    }
    
    func testPercentage() {
        digitSpanPercentage = (getDigitSpan / 157.0) * 100.0
    }
    
    func getDigitSpanPercentile() {
        if getDigitSpan >= 145 {
            digitSpanPercentile = "99.9"
        }
        else {
            switch getDigitSpan {
            case 54.0:
                digitSpanPercentile = "0.1"
            case 55.0:
                digitSpanPercentile = "0.1"
            case 56.0:
                digitSpanPercentile = "0.2"
            case 57.0:
                digitSpanPercentile = "0.2"
            case 58.0:
                digitSpanPercentile = "0.3"
            case 59.0:
                digitSpanPercentile = "0.3"
            case 60.0:
                digitSpanPercentile = "0.4"
            case 61.0:
                digitSpanPercentile = "0.5"
            case 62.0:
                digitSpanPercentile = "0.6"
            case 63.0:
                digitSpanPercentile = "0.7"
            case 64.0:
                digitSpanPercentile = "0.8"
            case 65.0:
                digitSpanPercentile = "1"
            case 66.0:
                digitSpanPercentile = "1"
            case 67.0:
                digitSpanPercentile = "1"
            case 68.0:
                digitSpanPercentile = "2"
            case 69.0:
                digitSpanPercentile = "2"
            case 70.0:
                digitSpanPercentile = "2"
            case 71.0:
                digitSpanPercentile = "3"
            case 72.0:
                digitSpanPercentile = "3"
            case 73.0:
                digitSpanPercentile = "4"
            case 74.0:
                digitSpanPercentile = "4"
            case 75.0:
                digitSpanPercentile = "5"
            case 76.0:
                digitSpanPercentile = "5"
            case 77.0:
                digitSpanPercentile = "6"
            case 78.0:
                digitSpanPercentile = "7"
            case 79.0:
                digitSpanPercentile = "8"
            case 80.0:
                digitSpanPercentile = "9"
            case 81.0:
                digitSpanPercentile = "10"
            case 82.0:
                digitSpanPercentile = "12"
            case 83.0:
                digitSpanPercentile = "13"
            case 84.0:
                digitSpanPercentile = "14"
            case 85.0:
                digitSpanPercentile = "16"
            case 86.0:
                digitSpanPercentile = "18"
            case 87.0:
                digitSpanPercentile = "19"
            case 88.0:
                digitSpanPercentile = "21"
            case 89.0:
                digitSpanPercentile = "23"
            case 90.0:
                digitSpanPercentile = "25"
            case 91.0:
                digitSpanPercentile = "27"
            case 92.0:
                digitSpanPercentile = "30"
            case 93.0:
                digitSpanPercentile = "32"
            case 94.0:
                digitSpanPercentile = "34"
            case 95.0:
                digitSpanPercentile = "37"
            case 96.0:
                digitSpanPercentile = "39"
            case 97.0:
                digitSpanPercentile = "42"
            case 98.0:
                digitSpanPercentile = "45"
            case 99.0:
                digitSpanPercentile = "47"
            case 100.0:
                digitSpanPercentile = "50"
            case 101.0:
                digitSpanPercentile = "53"
            case 102.0:
                digitSpanPercentile = "55"
            case 103.0:
                digitSpanPercentile = "58"
            case 104.0:
                digitSpanPercentile = "61"
            case 105.0:
                digitSpanPercentile = "63"
            case 106.0:
                digitSpanPercentile = "66"
            case 107.0:
                digitSpanPercentile = "68"
            case 108.0:
                digitSpanPercentile = "70"
            case 109.0:
                digitSpanPercentile = "73"
            case 110.0:
                digitSpanPercentile = "75"
            case 111.0:
                digitSpanPercentile = "77"
            case 112.0:
                digitSpanPercentile = "79"
            case 113.0:
                digitSpanPercentile = "81"
            case 114.0:
                digitSpanPercentile = "82"
            case 115.0:
                digitSpanPercentile = "84"
            case 116.0:
                digitSpanPercentile = "86"
            case 117.0:
                digitSpanPercentile = "87"
            case 118.0:
                digitSpanPercentile = "88"
            case 119.0:
                digitSpanPercentile = "90"
            case 120.0:
                digitSpanPercentile = "91"
            case 121.0:
                digitSpanPercentile = "92"
            case 122.0:
                digitSpanPercentile = "93"
            case 123.0:
                digitSpanPercentile = "94"
            case 124.0:
                digitSpanPercentile = "95"
            case 125.0:
                digitSpanPercentile = "95"
            case 126.0:
                digitSpanPercentile = "96"
            case 127.0:
                digitSpanPercentile = "96"
            case 128.0:
                digitSpanPercentile = "97"
            case 129.0:
                digitSpanPercentile = "97"
            case 130.0:
                digitSpanPercentile = "98"
            case 131.0:
                digitSpanPercentile = "98"
            case 132.0:
                digitSpanPercentile = "98"
            case 133.0:
                digitSpanPercentile = "99"
            case 134.0:
                digitSpanPercentile = "99"
            case 135.0:
                digitSpanPercentile = "99"
            case 136.0:
                digitSpanPercentile = "99.2"
            case 137.0:
                digitSpanPercentile = "99.3"
            case 138.0:
                digitSpanPercentile = "99.4"
            case 139.0:
                digitSpanPercentile = "99.5"
            case 140.0:
                digitSpanPercentile = "99.6"
            case 141.0:
                digitSpanPercentile = "99.7"
            case 142.0:
                digitSpanPercentile = "99.7"
            case 143.0:
                digitSpanPercentile = "99.8"
            case 144.0:
                digitSpanPercentile = "99.8"
            default:
                digitSpanPercentile = "0"
            }
        }
    }
    
}