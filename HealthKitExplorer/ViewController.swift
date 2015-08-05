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
    
    let healthKitStore:HKHealthStore = HKHealthStore()
    var ready:  Bool = false
    
    @IBOutlet weak var txtOutput: UILabel!
    
    @IBOutlet weak var txtOutputBox: UITextView!
    
    @IBAction func bntStart(sender: AnyObject) {
        print("btnStart() - Knop geklikt")
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss.SSSSxxx"
        let fromDate = "2015-01-19T01:22:18.964Z"
        let toDate = "2015-02-19T01:22:18.964Z"
        
        readHeartRateValues(fromDate,to: toDate, latestXSamples: 10)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewdidload()")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func readHeartRateValues(from: String, to: String, latestXSamples: Int) -> Int    {
        let sampleType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)
        let predicate = HKQuery.predicateForSamplesWithStartDate(NSDate.distantPast() , endDate: NSDate(), options: HKQueryOptions.None)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: sampleType!, predicate: predicate, limit: latestXSamples, sortDescriptors: [sortDescriptor])
        { (query, results, error) in
                if error != nil {
                    print("Error")
                } else {
                    self.ready = true
                    print("Aantal resultaten: \(results!.count)")
                    print(results?.debugDescription)
                    dispatch_async(dispatch_get_main_queue()) {
                        self.txtOutput.text = String(results?.count)
                        self.txtOutputBox.text = results?.debugDescription
                    }

                }
        }
        healthKitStore.executeQuery(query)
            
        return 0
    }
    

}

