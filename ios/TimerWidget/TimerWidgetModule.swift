//
//  TimerWidgetModule.swift
//  FancyTimer
//
//  Created by Raúl Gómez Acuña on 10/01/2024.
//

import Foundation
import ActivityKit
import UIKit


@objc(TimerWidgetModule)
class TimerWidgetModule: NSObject {

  private func areActivitiesEnabled() -> Bool {
    return ActivityAuthorizationInfo().areActivitiesEnabled
  }

  @objc
  func startLiveActivity() -> Void {
    if (!areActivitiesEnabled()) {
      // User disabled Live Activities for the app, nothing to do
      return
    }
    
    // Preparing data for the Live Activity
    let activityAttributes = TimerWidgetAttributes()
    let contentState = TimerWidgetAttributes.ContentState(stopNumber: 1, driverName: "John", totalStops: 10)
    let activityContent = ActivityContent(state: contentState,  staleDate: nil)
    do {
      // Request to start a new Live Activity with the content defined above
      let activity = try Activity.request(attributes: activityAttributes, content: activityContent, pushType: .token)
      
      Task {
        for await pushToken in activity.pushTokenUpdates {
          let pushTokenString = pushToken.reduce("") {
            $0 + String(format: "%02x", $1)
          }
          
          print("Push token for started activity: \(pushTokenString)")
        }
      }
    } catch {
      // Handle errors, skipped for simplicity
    }
  }

  @objc
  func stopLiveActivity() -> Void {
    // A task is a unit of work that can run concurrently in a lightweight thread, managed by the Swift runtime
    // It helps to avoid blocking the main thread
    Task {
      for activity in Activity<TimerWidgetAttributes>.activities {
        await activity.end(nil, dismissalPolicy: .immediate)
      }
    }
  }
  
  @objc
  func observePushToStartToken(_ consumerId: NSString) -> Void {
    Task {
      for await data in Activity<TimerWidgetAttributes>.pushToStartTokenUpdates {
        let token = data.map {String(format: "%02x", $0)}.joined()
        print("Observe PushToStart Token: \(token)")
        print("consumer id: \(consumerId)")
        //send this token to your notification server
      }
    }
  }
  
  @objc
  func getPushToStartToken(_ consumerId: NSString) -> Void {
        let tokenData = Activity<TimerWidgetAttributes>.pushToStartToken
        
    if let token = tokenData {
      let tokenString = token.map { String(format: "%02.2hhx", $0) }.joined()
      print("Token data: \(tokenString)")
      print("consumer id: \(consumerId)")
      
      
      //Post request to server
      let url = URL(string: "https://a961-145-224-65-87.ngrok-free.app/saveToken")!
      var request = URLRequest(url: url)
      request.httpMethod = "POST"
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")

      // Create the request body
      let body = ["token": tokenString, "consumerId": consumerId] as [String: Any]
      let bodyData = try? JSONSerialization.data(withJSONObject: body, options: [])
      request.httpBody = bodyData
      
      // Send the POST request
      let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
          if let error = error {
              print("Error: \(error.localizedDescription)")
          } else if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
              print("POST request successful with status code: \(httpResponse.statusCode)")
              // Handle the successful response
          } else {
              print("POST request failed with status code: \(response?.description ?? "Unknown")")
              // Handle the failure response
          }
      }
      task.resume()
      
    } else {
       print("No token data available.")
      print("consumer id: \(consumerId)")
    }
  }
  
  @objc
  func observeActivityPushToken() {
      Task {
          for await activityData in Activity<TimerWidgetAttributes>.activityUpdates {
              Task {
                for await tokenData in activityData.pushTokenUpdates {
                  let token = tokenData.map {String(format: "%02x", $0)}.joined()
                  print("Push token updates: \(token)")
                  // Get consumerId from live activity & send post to server with token
                  print("Live activity data: \(activityData.content)")
                }
              }
          }
      }
  }
  
}
