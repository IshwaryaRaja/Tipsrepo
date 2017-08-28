//
//  ViewController.swift
//  Tips
//
//  Created by ishwaryaraja on 28/08/17.
//  Copyright © 2017 ishwaryaraja. All rights reserved.
//

import UIKit
import Charts


class ViewController: UIViewController {
    var avgsenValue = Int()
    var avgwordValue = Int()
    var listOfText = [String]()
    var sentencecount = [Int]()
    var wordcount = [Int]()
    var wordLists = [String]()
    var counts = [String: Int]()
    var dataEntries: [BarChartDataEntry] = []
    var word = [String]()
    var occurrance = [String]()
    
    @IBOutlet weak var barChartView: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parseData()
        
    }
    
    func displayAlertMessage(userMessage:String){
        let myAlert = UIAlertController(title: "Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler:nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        displayAlertMessage(userMessage: "The average length of sentences:\(avgsenValue),The average length of the words :\(avgwordValue)")
        
        
        for item in wordLists {
            counts[item] = (counts[item] ?? 0) + 1
        }
        
        let decending = counts.sorted(by: {$0.1 > $1.1})
        let n = 50
        let firstFifty = decending[0..<n]
        print(firstFifty)
        
        for (key, value) in firstFifty {
            word.append("\(key)")
            occurrance.append("\(value)")
            
        }
        print(word)
        print(occurrance)
        setChart(forX: word , forY: occurrance )
    }
  
    func setChart(forX: [String], forY: [String]) {
        barChartView.noDataText = "You need to provide data for the chart."
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<forX.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(forY[i])! , data: forX as AnyObject?)
            //            print(dataEntry )
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "\(word)")
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
    }
    private func parseData() {
    do {
        if let file = Bundle.main.url(forResource: "Tips", withExtension: "json") {
            let data = try Data(contentsOf: file)
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            if let object = json as? [String: AnyObject] {
                // json is a dictionary
                if let results = object["results"] as? [[String:AnyObject]]{
                    for i in 0..<results.count {
                        let result = results[i]
                        if  let text = result["text"] {
                            self.listOfText.append(text as! String)
                            let wordList =  (text as AnyObject).components(separatedBy: .punctuationCharacters).joined().components(separatedBy: " ").filter{!$0.isEmpty}
                            wordLists += wordList
                            wordcount.append(wordList.count)
                            let sentencelist = (text as AnyObject).components(separatedBy: ".").filter{!$0.isEmpty}
                            sentencecount.append(sentencelist.count)
                        }
                    }
                    let sum1 = sentencecount.reduce(0,+)
                    avgsenValue = sum1 / sentencecount.count
                    print("The average value of sentences are: \(avgsenValue)")
                    let sum =  wordcount.reduce(0,+)
                    avgwordValue = sum / wordcount.count
                    print("The average value of the words are:\(avgwordValue)")
                    
                    
                }
            }
            else {
                print("JSON is invalid")
            }
        }
        else {
            print("no file")
        }
    }
    catch {
        print(error.localizedDescription)
    }
}
}
