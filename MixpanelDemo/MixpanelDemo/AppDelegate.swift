//
//  AppDelegate.swift
//  MixpanelDemo
//
//  Created by Yarden Eitan on 6/5/16.
//  Copyright © 2016 Mixpanel. All rights reserved.
//

import UIKit
import Mixpanel

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        var ADD_YOUR_MIXPANEL_TOKEN_BELOW_🛠🛠🛠🛠🛠🛠: String
        Mixpanel.initialize(token: "28abe594236545f6c3496c9375d9c5cb")
        Mixpanel.mainInstance().loggingEnabled = true
        Mixpanel.mainInstance().flushInterval = 5
        let allTweaks: [TweakClusterType] = [MixpanelTweaks.floatTweak,
                                             MixpanelTweaks.intTweak,
                                             MixpanelTweaks.boolTweak,
                                             MixpanelTweaks.stringTweak]
        MixpanelTweaks.setTweaks(tweaks: allTweaks)

        let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)
        UIApplication.shared.registerForRemoteNotifications()

        Mixpanel.mainInstance().identify(
            distinctId: Mixpanel.mainInstance().distinctId)
        Mixpanel.mainInstance().people.set(properties: ["$name": "Max Panelle"])
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        debugPrint("did register for remote notification with token")
        Mixpanel.mainInstance().people.addPushDeviceToken(deviceToken)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        debugPrint(error)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Swift.Void) {
        debugPrint("did receive remote notification")

        if let message = (userInfo["aps"] as? [String: Any])?["alert"] as? String {
            let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
        completionHandler(.newData)
    }

}

extension MixpanelTweaks {
    public static let floatTweak = Tweak<CGFloat>(tweakName: "floatTweak", defaultValue: 20.5, min: 0, max: 30.1)
    public static let intTweak = Tweak<Int>(tweakName: "intTweak", defaultValue: 10, min: 0)
    public static let boolTweak = Tweak(tweakName: "boolTweak", defaultValue: true)
    public static let stringTweak = Tweak(tweakName: "stringTweak", defaultValue: "hello")
}
