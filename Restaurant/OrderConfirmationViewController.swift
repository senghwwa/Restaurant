//
//  OrderConfirmationViewController.swift
//  Restaurant
//
//  Created by Seng Hwwa on 21/02/2019.
//  Copyright © 2019 Seng Hwwa. All rights reserved.
//

import UIKit
import UserNotifications

class OrderConfirmationViewController: UIViewController {

    @IBOutlet weak var timeRemainingLabel: UILabel!
    var minutes: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        timeRemainingLabel.text = "Thank you for your order! Your wait time is approximately \(minutes!) minutes"
		
		/*
		let notificationCenter = UNUserNotificationCenter.current()
		// DO NOT DO THIS notificationCenter.removeAllPendingNotificationRequests()
		
		let content = UNMutableNotificationContent()
		content.title = "Order Due For Collection"
		let notficationDelay = minutes - 10
		content.body = "Your order is due in /(notificationDelay) minutes"
		if notificationDelay <= 0 {
			notificationDelay = 0
			content.body = "Your order is due in less than 10 minutes"
		}
		let trigger = UNTimeIntervalNotificationTrigger(timeInterval: (notificationDelay * 60), repeats: false)
		let identifier = "PushNotifierLocalNotification"
		let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
		notificationCenter.add(request, withCompletionHandler: nil)
		*/
		
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
