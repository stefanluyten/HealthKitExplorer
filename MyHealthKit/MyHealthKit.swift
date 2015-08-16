//
//  MyHealthKit.swift
//  HealthKitExplorer
//
//  Created by Stefan Luyten on 16/08/15.
//  Copyright © 2015 Triton Consulting. All rights reserved.
//

import Foundation
import HealthKit
import UserKit


public class MyHealthKit: NSObject {
    
    let healthKitStore:HKHealthStore = HKHealthStore()
    
    public override init(){
        
    }
    
    public func readLatestHeartRateValues(latestXSamples: Int) -> Int    {
        let dataStorage = UserData()
        let sampleType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)
        let predicate = HKQuery.predicateForSamplesWithStartDate(NSDate.distantPast() , endDate: NSDate(), options: HKQueryOptions.None)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        var bpm: Int = 0
        
        let formatterWatch = NSDateFormatter();
        var data: String = ""
        formatterWatch.dateFormat = "dd/MM HH:mm"

        var timeStampWatch: String = ""
        
        let query = HKSampleQuery(sampleType: sampleType!, predicate: predicate, limit: latestXSamples, sortDescriptors: [sortDescriptor])
            { (query, results, error) in
                if error != nil {
                    print("Error")
                } else {
                        for result in results! {
                            
                            bpm = Int(((result.valueForKeyPath("_quantity._value"))?.floatValue)! * 60.0)
                            timeStampWatch = formatterWatch.stringFromDate(result.startDate)
                            data = data + timeStampWatch + " - " + String(bpm) + "\n"
                        }
                        dataStorage.latestBPMs = data
                    
                }
        }
        healthKitStore.executeQuery(query)
        
        return 0
    }
    
    
}
