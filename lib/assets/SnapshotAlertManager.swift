//
//  SnapshotAlertManager.swift
//
//  Created by Maxime Britto on 06/01/2016.
//  Copyright © 2016 dev2a. All rights reserved.
//

import Foundation
import XCTest

func automaticallyDismissAlerts(testCase:XCTestCase) -> NSObjectProtocol {
    return SnapshotAlertManager.automaticallyDismissAlerts(testCase)
}

func stopDismissingAlerts(testCase:XCTestCase) {
    SnapshotAlertManager.stopDismissingAlerts(testCase)
}

func waitForAlertsToBeDismissed() {
    SnapshotAlertManager.waitForAlertsToBeDismissed()
}

class SnapshotAlertManager: NSObject {
    static var alertInterruptionMonitor:NSObjectProtocol?

    class func stopDismissingAlerts(testCase:XCTestCase) {
        if let previousDismissHandler = alertInterruptionMonitor {
            testCase.removeUIInterruptionMonitor(previousDismissHandler)
        }
    }

    class func automaticallyDismissAlerts(testCase:XCTestCase) -> NSObjectProtocol
    {
        SnapshotAlertManager.stopDismissingAlerts(testCase)
        alertInterruptionMonitor = testCase.addUIInterruptionMonitorWithDescription("Snapshot alert auto hide") { (alert: XCUIElement) -> Bool in
            print("Alert \"\(alert.label)\" will be dismissed")
            return false
        }

        return alertInterruptionMonitor!
    }

    class func waitForAlertsToBeDismissed()
    {
        let query = XCUIApplication().alerts
        var waitCounter = 0
        while (query.count > 0) {
            sleep(1)
            waitCounter++
            print("Found an alert... waiting for it to disappear")
            if waitCounter > 2 {
              if alertInterruptionMonitor == nil {
                  print("The SnapshotAlertManager can automatically hide alerts that will prevent actions or screenshots. Just call this method to enable it : automaticallyDismissAlerts(testCase:XCTestCase)")
              } else {
                  XCUIApplication().tap() //UIInterruptionMonitor will only trigger if an action is prevented by the alert so we generate one if the user script hasn't after 2 seconds
              }
            }
        }
    }
}
