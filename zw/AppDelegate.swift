//
//  AppDelegate.swift
//  zw
//
//  Created by Zhanqiulin on 2016/12/1.
//  Copyright © 2016年 Zhanqiulin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        application.statusBarStyle = .lightContent
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.barTintColor = UIColor.bgBlack
        navigationBarAppearace.tintColor = UIColor.white
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        ZWRealm.shared.query { (realm) in
            if realm.object(ofType: UserSetting.self, forPrimaryKey: "call110") == nil {
                try! realm.write {
                    realm.add(UserSetting(), update: true)
                }
            }
        }
        
//        Alamofire.request("http://192.168.1.185:8092/zw/p/getblackphone").validate().responseJSON { (response) in
//            switch response.result {
//            case .success(let value):
//                let result = JSON(value)
//                let data = result["data"].arrayValue.map({ (obj) -> BlackPhone in
//                    let phone = BlackPhone()
//                    phone.createTime = obj["createTime"].stringValue
//                    phone.city = obj["city"].stringValue
//                    phone.phone = obj["phone"].stringValue
//                    phone.remark = obj["remark"].stringValue
//                    phone.type = obj["type"].intValue
//                    return phone
//                })
//                RealmUtil.write(data, { (realm) in })
//            case .failure(let error):
//                print(error)
//            }
//        }
//      
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }

}

