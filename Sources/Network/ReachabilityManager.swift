//
//  ReachabilityManager.swift
//  OpenFoodFacts
//
//  Created by Sahil Dhawan on 17/02/18.
//  Copyright © 2018 Andrés Pizá Bückmann. All rights reserved.
//

import Foundation
import Reachability
import NotificationBanner

class ReachabilityManager {
    
    // instance of Reachability
    let reachability = Reachability()
    
    //a shared instance of Reachability Manager to access from App Delegate
    static let shared = ReachabilityManager()
    
    // start monitoring network connection
    func startMonitoring(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged), name: Notification.Name.reachabilityChanged, object: reachability)
        do {
            try reachability?.startNotifier()
        } catch {
            print("Could not start reachability notifier")
        }
    }
    
    // stop monitoring network connection when application enters background
    func stopMonitoring(){
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: Notification.Name.reachabilityChanged, object: reachability)
    }
    
    // start observing changes in network
    @objc func reachabilityChanged(notification : Notification){
        let reachability = notification.object as! Reachability
        
        switch reachability.connection {
        case .cellular :
            print("Cellular network available")
        case .wifi:
            print("Wifi Network Avaiable")
        case .none:
            // creating a status bar banner to indicate no internet connection
            let banner = StatusBarNotificationBanner(title: "No Internet Connection", style: .danger, colors: nil)
            banner.show()
        }
    }
}
