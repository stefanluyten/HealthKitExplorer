//
//  ViewController.swift
//  HealthKitExplorer
//
//  Created by Stefan Luyten on 3/08/15.
//  Copyright © 2015 Triton Consulting. All rights reserved.
//

import UIKit
import HealthKit
import UserKit
import MyHealthKit

class ViewController: UIViewController {
    
    let textCellIdentifier = "TextCell"
    let healthKitStore:HKHealthStore = HKHealthStore()
    var ready:  Bool = false
    
    var dataStorage = UserData()
    var myHealthKit = MyHealthKit()
    
    
    @IBOutlet weak var txtOutput: UILabel!
    
    @IBOutlet weak var txtOutputBox: UITextView!
    
    @IBAction func bntStart(sender: AnyObject) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss.SSSSxxx"
        self.view.endEditing(true)
        myHealthKit.readLatestHeartRateValues(1000)
        dispatch_async(dispatch_get_main_queue()) {
            //self.txtOutputBox.text = "Fetching data ..."
            self.txtOutputBox.text = self.dataStorage.latestBPMs
        }
        

    }
    
    @IBOutlet weak var txtNumber: UITextField!
    
    //var output:[HKSample] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        NSTimer.scheduledTimerWithTimeInterval(600, target: self, selector: Selector("update:"), userInfo: nil, repeats: true)
    }
    
    @objc dynamic func update(timer:NSTimer!) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}

