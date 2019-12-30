//
//  AppDelegate.swift
//  PlanoDeEstudos
//
//  Created by Eric Brito
//  Copyright © 2017 Eric Brito. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var center = UNUserNotificationCenter.current()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window?.tintColor = UIColor(named: "main")
        
        
        center.delegate = self
        
        center.getNotificationSettings { (settings) in
            
            switch settings.authorizationStatus {
                case .notDetermined:
                    let options: UNAuthorizationOptions = [.alert, .sound, .badge, .carPlay]
                    self.center.requestAuthorization(options: options) { (success, error) in
                        if error == nil{
                            print("t;a errrs")
                            print(success)
                        } else {
                            print(error!.localizedDescription)
                            print("filho da mae")
                        }
                    }
                case .denied:
                    print(" Usuário negou a notificação")
                    //alerta para o usuário e leva-lo para para a tela de settings
                case .authorized:
                    print("Já autorizado")
                default:
                print("Nenhuma opção selecionada")
            }
            
        }
        
        let confirmAction = UNNotificationAction(identifier: "Confirm", title: "Já estudei! 👍 ", options: .foreground)
        let cancelAction = UNNotificationAction(identifier: "Cancel", title: "Cancelar", options: [])
        let category = UNNotificationCategory(identifier: "Lembrete", actions: [confirmAction, cancelAction], intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: "", options: [.customDismissAction])
        center.setNotificationCategories([category])
        
        
        
        
        
        
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

}


extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("didReceive response")
        let id = response.notification.request.identifier
        print(id)
        
        
        switch response.actionIdentifier {
            case "Confirm":
                print("Usuário confirmou que estudou a matéria")
            
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Confirmed"), object: nil, userInfo: ["id" : id])
            case "Cancel":
                print("Usuário cancelou")
            case UNNotificationDefaultActionIdentifier:
                print("Tocou na propria notificação")
            case UNNotificationDismissActionIdentifier:
                print("Apenas deslizou anotificação")

            default:
                break
        }
        
        completionHandler()
    }
    
}
