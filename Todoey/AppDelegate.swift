//
//  AppDelegate.swift
//  Todoey
//
//  Created by Gauri Bhagwat on 29/03/18.
//  Copyright © 2018 Development. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
//        print(Realm.Configuration.defaultConfiguration.fileURL)
 
        
        do {
        _ = try Realm()
        } catch {
            print("Error Initializing Realm \(error)")
        }
        return true
    }

}
