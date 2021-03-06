//
//  AppDelegate.swift
//  HealthKitExplorer
//
//  Created by Stefan Luyten on 3/08/15.
//  Copyright © 2015 Triton Consulting. All rights reserved.
//

import UIKit
import HealthKit
import MyHealthKit
import UserKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let healthStore:HKHealthStore = HKHealthStore()
    
    var myHealthKit = MyHealthKit()
    let dataStorage = UserData()
    
    func application(application: UIApplication, handleWatchKitExtensionRequest userInfo: [NSObject : AnyObject]?, reply: ([NSObject : AnyObject]?) -> Void) {
        if let infoDictionary = userInfo as? [String: String],
            message = infoDictionary["message"]
        {
            myHealthKit.readLatestHeartRateValues(1000)
            let responseDictionary = ["message" : dataStorage.latestBPMs]
            reply(responseDictionary)
        }
    }
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let healthStore: HKHealthStore? = {
            if HKHealthStore.isHealthDataAvailable() {
                return HKHealthStore()
            } else {
                return nil
            }
            }()
        
        let dateOfBirthCharacteristic = HKCharacteristicType.characteristicTypeForIdentifier(
            HKCharacteristicTypeIdentifierDateOfBirth)
        
        let biologicalSexCharacteristic = HKCharacteristicType.characteristicTypeForIdentifier(
            HKCharacteristicTypeIdentifierBiologicalSex)
        
        let bloodTypeCharacteristic = HKCharacteristicType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierBloodType)

        let heartRate = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)
        

        let dataTypesToRead = NSSet(objects:
            dateOfBirthCharacteristic!,
            biologicalSexCharacteristic!,
            bloodTypeCharacteristic!, heartRate!)
        
        healthStore?.requestAuthorizationToShareTypes(nil,
            readTypes: (dataTypesToRead as! Set<HKObjectType>),
            completion: { (success, error) -> Void in
                if success {
                    //print("success")
                } else {
                    print(error!.description)
                }
        })
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

