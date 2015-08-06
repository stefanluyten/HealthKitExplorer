//
//  ViewController.swift
//  HealthKitExplorer
//
//  Created by Stefan Luyten on 3/08/15.
//  Copyright © 2015 Triton Consulting. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController {
    
    let textCellIdentifier = "TextCell"
    let healthKitStore:HKHealthStore = HKHealthStore()
    var ready:  Bool = false
    
    @IBOutlet weak var txtOutput: UILabel!
    
    @IBOutlet weak var txtOutputBox: UITextView!
    
    @IBAction func bntStart(sender: AnyObject) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss.SSSSxxx"
        let fromDate = "2015-01-19T01:22:18.964Z"
        let toDate = "2015-02-19T01:22:18.964Z"
        
        readHeartRateValues(fromDate,to: toDate, latestXSamples: 1500)
    }
    
    //var output:[HKSample] = []

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
        var formatterEnd = NSDateFormatter();

        formatter.dateFormat = "dd/MM/yyyy HH:mm:ss";
        formatterEnd.dateFormat = "HH:mm:ss";
        var timeStamp: String = ""
        var timeStampEnd: String = ""
    
        let query = HKSampleQuery(sampleType: sampleType!, predicate: predicate, limit: latestXSamples, sortDescriptors: [sortDescriptor])
        { (query, results, error) in
                if error != nil {
                    print("Error")
                } else {
                    self.ready = true
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        var result: Int
                        self.txtOutputBox.text = ""
                        for result in results! {
                            bpm = Int(((result.valueForKeyPath("_quantity._value"))?.floatValue)! * 60.0)
                            timeStamp = formatter.stringFromDate(result.startDate)
                            timeStampEnd = formatterEnd.stringFromDate(result.endDate)
                            self.txtOutputBox.text = self.txtOutputBox.text + timeStamp + " - " + timeStampEnd + " : " + String(bpm) + "\r\n"
                        }
                        
                    }
                
                }
        }
        healthKitStore.executeQuery(query)
            
        return 0
    }
    


}

