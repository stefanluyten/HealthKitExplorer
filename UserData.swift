//
//  UserData.swift
//  HealthKitExplorer
//
//  Created by Stefan Luyten on 15/08/15.
//  Copyright © 2015 Triton Consulting. All rights reserved.
//

import Foundation

public class UserData: NSObject {

    public static let storageKey = "group.be.triton-consulting.HealthKitExplorer"
    public let userStorage = NSUserDefaults(suiteName: storageKey)
    
    public var latestBPMs: String {
        get {
            // Get setting from storage or default
            if userStorage?.objectForKey("latestBPMs") == nil {
                userStorage?.setObject(false, forKey: "latestBPMs")
                userStorage?.synchronize()
            }
    
            return (userStorage?.objectForKey("latestBPMs"))! as! String
        }

        set {
            // Set new value in storage
            userStorage?.setObject(newValue, forKey: "latestBPMs")
            userStorage?.synchronize()
        }
    }
}
