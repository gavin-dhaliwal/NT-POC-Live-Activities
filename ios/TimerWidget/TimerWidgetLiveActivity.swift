//
//  TimerWidgetLiveActivity.swift
//  TimerWidget
//
//  Created by Raúl Gómez Acuña on 07/01/2024.
//

import ActivityKit
import WidgetKit
import SwiftUI


struct TimerWidgetAttributes: ActivityAttributes {
  public struct ContentState: Codable, Hashable {
    var stopNumber: Int
    var driverName: String
    var totalStops: Int
    
  }
}
struct TimerWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
    ActivityConfiguration(for: TimerWidgetAttributes.self) { context in
      // Lock screen/banner UI goes here
      @Environment(\.colorScheme) var colorScheme
      
      VStack{
        HStack{
          Image("DpdLogo").resizable().frame(width: 38, height: 16)
          Spacer()
        VStack{
          Text("Your delivery").font(.system(size: 14)).fontWeight(.regular).foregroundStyle(Color(red: 0.8352941176470589, green: 0.8431372549019608, blue: 0.8313725490196079))
        }
        }.padding(.horizontal, 22).padding(.top, 14.5)
        
        // Can use to show base64 images
        // Image(uiImage: UIImage(data: Data(base64Encoded: base64String)!)!)
        
      if context.state.stopNumber == context.state.totalStops {
        Text("🎉 Your parcel has been delivered").font(.body).padding(.bottom).padding(.horizontal)
      } else {
        VStack(alignment: .leading){
          Text("Your delivery driver is \(context.state.totalStops - context.state.stopNumber) stops away").font(.system(size: 18)).fontWeight(.regular).padding(.top, 8)
          Text("test regular font").font(.system(size: 18)).fontWeight(.regular)
        HStack{
        GeometryReader { geometry in
          let progressRatio = CGFloat(context.state.stopNumber) / CGFloat(context.state.totalStops)
          let offset = progressRatio * geometry.size.width
          
          ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 5)
              .foregroundColor(Color(red: 0.3568627450980392, green: 0.3568627450980392, blue: 0.3568627450980392))
              .frame(width: geometry.size.width, height: 3)
            
            Capsule()
              .fill(Color(red: 0.3137254901960784, green: 0.6196078431372549, blue: 0.1843137254901961))
              .frame(width: offset, height: 3)
            
              
            Circle().fill(Color(red: 0.3568627450980392, green: 0.3568627450980392, blue: 0.3568627450980392)).frame(width: 14, height: 14).offset(x: geometry.size.width - 7)
          
            
            Image("VanSmall")
              .clipShape(Rectangle()) // Clip to maintain aspect ratio
              .frame(width: 32, height: 13)
              .offset(x: offset)
            
            Image("https://i.stechies.com/684x432/filters:quality(1)/userfiles/images/base64-image-html-1.png").frame(width: 32, height: 13)

            
          }
          .frame(height: 20)
        }
        }
      }.padding(.horizontal, 22).padding(.bottom, 25)
      
      }
      }.activityBackgroundTint(colorScheme == .dark ? Color.white.opacity(0.6) : Color.black.opacity(0.6))

    } dynamicIsland: { context in
      DynamicIsland {
        // Expanded Region
        DynamicIslandExpandedRegion(.center) {}
      } compactLeading: {
//        Image("DpdIcon").resizable().scaledToFit()
      } compactTrailing: {
//        Text("Stop \(context.state.stopNumber) of \(context.state.totalStops)")
      } minimal: {
        Image("DpdIcon").resizable().scaledToFit()
      }
    }
  }
}

extension TimerWidgetAttributes {
  fileprivate static var preview: TimerWidgetAttributes {
    TimerWidgetAttributes()
  }
}

extension TimerWidgetAttributes.ContentState {
  fileprivate static var initState: TimerWidgetAttributes.ContentState {
    TimerWidgetAttributes.ContentState(stopNumber: 1, driverName: "John", totalStops: 10)
  }
  fileprivate static var secondState: TimerWidgetAttributes.ContentState {
    TimerWidgetAttributes.ContentState(stopNumber: 3, driverName: "John", totalStops: 10)
  }
  fileprivate static var thridState: TimerWidgetAttributes.ContentState {
    TimerWidgetAttributes.ContentState(stopNumber: 9, driverName: "John", totalStops: 10)
  }
  fileprivate static var forthState: TimerWidgetAttributes.ContentState {
    TimerWidgetAttributes.ContentState(stopNumber: 10, driverName: "John", totalStops: 10)
  }
}

#Preview("Notification", as: .content, using: TimerWidgetAttributes.preview) {
  TimerWidgetLiveActivity()
} contentStates: {
  TimerWidgetAttributes.ContentState.initState
  TimerWidgetAttributes.ContentState.secondState
  TimerWidgetAttributes.ContentState.thridState
  TimerWidgetAttributes.ContentState.forthState
}
