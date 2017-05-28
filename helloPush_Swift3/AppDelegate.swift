/*
 *     Copyright 2016 IBM Corp.
 *     Licensed under the Apache License, Version 2.0 (the "License");
 *     you may not use this file except in compliance with the License.
 *     You may obtain a copy of the License at
 *     http://www.apache.org/licenses/LICENSE-2.0
 *     Unless required by applicable law or agreed to in writing, software
 *     distributed under the License is distributed on an "AS IS" BASIS,
 *     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *     See the License for the specific language governing permissions and
 *     limitations under the License.
 */

import UIKit
import FuntastyKit
import BMSCore
import BMSPush
import UserNotifications
import UserNotificationsUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        coordinator = AppCoordinator(window: window!)
        coordinator?.start()

        window?.makeKeyAndVisible()
        setupAppearance()

        registerForPush()

        return true
    }

    func registerForPush () {
        let myBMSClient = BMSClient.sharedInstance
        myBMSClient.initialize(bluemixRegion: BMSClient.Region.unitedKingdom)
        let push =  BMSPushClient.sharedInstance
        push.initializeWithAppGUID(appGUID: "02bfd12b-9df3-4283-aecc-661b2abb77a2", clientSecret: "771dd6d9-edfb-4329-b389-336b77b8d1f1")
    }
    
    func unRegisterPush () {

        // MARK: RETRIEVING AVAILABLE SUBSCRIPTIONS
        
        let push =  BMSPushClient.sharedInstance
        push.retrieveSubscriptionsWithCompletionHandler { (response, statusCode, error) -> Void in
            if error.isEmpty {
                print( "Response during retrieving subscribed tags : \(response?.description)")
                print( "status code during retrieving subscribed tags : \(statusCode)")
                self.sendNotifToDisplayResponse(responseValue: "Response during retrieving subscribed tags: \(response?.description)")
                
                // MARK: UNSUBSCRIBING TO TAGS
                
                push.unsubscribeFromTags(tagsArray: response!, completionHandler: { (response, statusCode, error) -> Void in
                    if error.isEmpty {
                        print( "Response during unsubscribed tags : \(response?.description)")
                        print( "status code during unsubscribed tags : \(statusCode)")
                        self.sendNotifToDisplayResponse(responseValue: "Response during unsubscribed tags: \(response?.description)")
                        
                        // MARK: UNSREGISTER DEVICE

                        push.unregisterDevice(completionHandler: { (response, statusCode, error) -> Void in
                            if error.isEmpty {
                                print( "Response during unregistering device : \(response)")
                                print( "status code during unregistering device : \(statusCode)")
                                self.sendNotifToDisplayResponse(responseValue: "Response during unregistering device: \(response)")
                                UIApplication.shared.unregisterForRemoteNotifications()
                            } else {
                                print( "Error during unregistering device \(error) ")
                                self.sendNotifToDisplayResponse( responseValue: "Error during unregistering device \n  - status code: \(statusCode) \n Error :\(error) \n")
                            }
                        })
                    } else {
                        print( "Error during  unsubscribed tags \(error) ")
                        self.sendNotifToDisplayResponse( responseValue: "Error during unsubscribed tags \n  - status code: \(statusCode) \n Error :\(error) \n")
                    }
                })
            } else {
                print( "Error during retrieving subscribed tags \(error) ")
                self.sendNotifToDisplayResponse( responseValue: "Error during retrieving subscribed tags \n  - status code: \(statusCode) \n Error :\(error) \n")
            }
        }
    }
    
    func application (_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data){
        let push = BMSPushClient.sharedInstance
        push.registerWithDeviceToken(deviceToken: deviceToken) { (response, statusCode, error) -> Void in
            if error.isEmpty {

                APIAdapter.sharedInstance.getMessages()

                print( "Response during device registration : \(response)")
                print( "status code during device registration : \(statusCode)")
                self.sendNotifToDisplayResponse(responseValue: "Response during device registration json: \(response)")
                
                // MARK: RETRIEVING AVAILABLE TAGS
                
                push.retrieveAvailableTagsWithCompletionHandler(completionHandler: { (response, statusCode, error) -> Void in
                    if error.isEmpty {
                        print( "Response during retrieve tags : \(response)")
                        print( "status code during retrieve tags : \(statusCode)")
                        self.sendNotifToDisplayResponse(responseValue: "Response during retrieve tags: \(response?.description)")
                        
                        // MARK: SUBSCRIBING TO AVAILABLE TAGS

                        push.subscribeToTags(tagsArray: response!, completionHandler: { (response, statusCode, error) -> Void in
                            if error.isEmpty {
                                print( "Response during Subscribing to tags : \(response?.description)")
                                print( "status code during Subscribing tags : \(statusCode)")
                                self.sendNotifToDisplayResponse(responseValue: "Response during Subscribing tags: \(response?.description)")
                                
                                // MARK: RETRIEVING AVAILABLE SUBSCRIPTIONS

                                push.retrieveSubscriptionsWithCompletionHandler(completionHandler: { (response, statusCode, error) -> Void in
                                    if error.isEmpty {
                                        print( "Response during retrieving subscribed tags : \(response?.description)")
                                        print( "status code during retrieving subscribed tags : \(statusCode)")
                                        self.sendNotifToDisplayResponse(responseValue: "Response during retrieving subscribed tags: \(response?.description)")
                                    } else {
                                        print( "Error during retrieving subscribed tags \(error) ")
                                        self.sendNotifToDisplayResponse( responseValue: "Error during retrieving subscribed tags \n  - status code: \(statusCode) \n Error :\(error) \n")
                                    }
                                })
                            } else {
                                print( "Error during subscribing tags \(error) ")
                                self.sendNotifToDisplayResponse( responseValue: "Error during subscribing tags \n  - status code: \(statusCode) \n Error :\(error) \n")
                            }
                        })
                    } else {
                        print( "Error during retrieve tags \(error) ")
                        self.sendNotifToDisplayResponse( responseValue: "Error during retrieve tags \n  - status code: \(statusCode) \n Error :\(error) \n")
                    }
                })
            }
            else{
                print( "Error during device registration \(error) ")
                self.sendNotifToDisplayResponse( responseValue: "Error during device registration \n  - status code: \(statusCode) \n Error :\(error) \n")
            }
        }
    }
    
    // Called if unable to register for APNS

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        let message:String = "Error registering for push notifications: \(error.localizedDescription)"
        self.showAlert(title: "Registering for notifications", message: message)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let payLoad = ((((userInfo as NSDictionary).value(forKey: "aps") as! NSDictionary).value(forKey: "alert") as! NSDictionary).value(forKey: "body") as! String)
        self.showAlert(title: "Recieved Push notifications", message: payLoad)
    }
    
    func sendNotifToDisplayResponse (responseValue:String){
        responseText = responseValue
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "action"), object: self)
    }
    
    func showAlert (title:String , message:String){
        let alert = UIAlertController.init(title: title as String, message: message as String, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.window!.rootViewController!.present(alert, animated: true, completion: nil)
    }

    private func setupAppearance() {
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.systemFont(ofSize: 18.0, weight: UIFontWeightSemibold)]
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }
}

