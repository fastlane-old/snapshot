//
//  SnapshotHelper.swift
//  Example
//
//  Created by Felix Krause on 10/8/15.
//  Copyright © 2015 Felix Krause. All rights reserved.
//

import Foundation
import XCTest

var deviceLanguage = ""

func setLanguage(app: XCUIApplication)
{
    Snapshot.setLanguage(app)
}

func snapshot(name: String, waitForLoadingIndicator: Bool = false)
{
    Snapshot.snapshot(name, waitForLoadingIndicator: waitForLoadingIndicator)
}



@objc class Snapshot: NSObject
{
    class func setLanguage(app: XCUIApplication)
    {
        let path = "/tmp/language.txt"

        do {
            let locale = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding) as String
            deviceLanguage = locale.substringToIndex(locale.startIndex.advancedBy(2, limit:locale.endIndex))
            app.launchArguments += ["-AppleLanguages", "(\(deviceLanguage))", "-AppleLocale", "\"\(locale)\"","-ui_testing"]
        } catch {
            print("Couldn't detect/set language...")
        }
    }
    
    class func snapshot(name: String, waitForLoadingIndicator: Bool = false)
    {
        if (waitForLoadingIndicator)
        {
            waitForLoadingIndicatorToDisappear()
        }
        print("snapshot: \(name)") // more information about this, check out https://github.com/krausefx/snapshot
        
        sleep(1) // Waiting for the animation to be finished (kind of)
        XCUIDevice.sharedDevice().orientation = .Unknown
    }
    
    class func waitForLoadingIndicatorToDisappear()
    {
        let app = XCUIApplication()
        let predicate = NSPredicate(format: "label == 'Network connection in progress'")
        let element = app.statusBars.childrenMatchingType(.Other).elementBoundByIndex(1).childrenMatchingType(.Other).elementMatchingPredicate(predicate)
        
        while (element.exists) {
            sleep(1)
            print("Network activity indicator present... waiting for status bar to disappear")
        }
    }
}

// Please don't remove the lines below
// They are used to detect outdated configuration files
// SnapshotHelperVersion [[1.0]]
