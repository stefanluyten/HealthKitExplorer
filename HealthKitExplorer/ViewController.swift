//
//  ViewController.swift
//  HealthKitExplorer
//
//  Created by Stefan Luyten on 3/08/15.
//  Copyright © 2015 Triton Consulting. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let textCellIdentifier = "TextCell"
    let healthKitStore:HKHealthStore = HKHealthStore()
    var ready:  Bool = false
    
    @IBOutlet weak var txtOutput: UILabel!
    
    @IBOutlet weak var txtOutputBox: UITextView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func bntStart(sender: AnyObject) {
        print("btnStart() - Knop geklikt")
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss.SSSSxxx"
        let fromDate = "2015-01-19T01:22:18.964Z"
        let toDate = "2015-02-19T01:22:18.964Z"
        
        readHeartRateValues(fromDate,to: toDate, latestXSamples: 100)
    }
    
    var output:[HKSample] = []
    //let output = ["Ray Wenderlich", "NSHipster", "iOS Developer Tips", "Jameson Quave", "Natasha The Robot", "Coding Explorer", "That Thing In Swift", "Andrew Bancroft", "iAchieved.it", "Airspeed Velocity"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func readHeartRateValues(from: String, to: String, latestXSamples: Int) -> Int    {
        let sampleType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)
        let predicate = HKQuery.predicateForSamplesWithStartDate(NSDate.distantPast() , endDate: NSDate(), options: HKQueryOptions.None)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        var bpm: Int = 0
        
        var formatter = NSDateFormatter();
        formatter.dateFormat = "dd/MM/yyyy HH:mm:ss";
        var timeStamp: String = ""
    
        let query = HKSampleQuery(sampleType: sampleType!, predicate: predicate, limit: latestXSamples, sortDescriptors: [sortDescriptor])
        { (query, results, error) in
                if error != nil {
                    print("Error")
                } else {
                    self.ready = true
                    print("Aantal resultaten: \(results!.count)")
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                    self.output = results!
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        var result: Int
                        self.txtOutput.text = String(results?.count)
                        self.txtOutputBox.text = ""
                        for result in results! {
                            bpm = Int(((result.valueForKeyPath("_quantity._value"))?.floatValue)! * 60.0)
                            timeStamp = formatter.stringFromDate(result.startDate)
                            print(timeStamp + " - " + String(bpm))
                            self.txtOutputBox.text = self.txtOutputBox.text + timeStamp + " - " + String(bpm) + "\r\n"
                        }
                        
                    }
                    self.tableView.reloadData()
                
                }
        }
        healthKitStore.executeQuery(query)
            
        return 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        let row = indexPath.row
        cell.textLabel?.text = output[row].description

        return cell
    }

}

