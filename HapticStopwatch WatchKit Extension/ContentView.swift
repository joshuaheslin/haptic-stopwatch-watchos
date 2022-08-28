//
//  ContentView.swift
//  HapticStopwatch WatchKit Extension
//
//  Created by Josh Heslin on 28/8/2022.
//

import Foundation
import SwiftUI

struct ContentView: View {
    @State var secondScreenShown = false
    @State var intervalVal = 5
    
    var body: some View {
        VStack{
            Text("Start haptic interval for \(intervalVal) seconds")
                .font(.system(size: 14))
            Picker(selection: $intervalVal, label: Text("")) {
                Text("5").tag(5)
                Text("10").tag(10)
                Text("20").tag(20)
                Text("30").tag(30)
                Text("45").tag(45)
                Text("60").tag(60)
                Text("120").tag(120)
            }
            NavigationLink(destination: SecondView(secondScreenShown: $secondScreenShown, intervalVal: $intervalVal), isActive: $secondScreenShown, label: {Text("Go")})
        }
    }
}

struct SecondView: View{
    @Binding var secondScreenShown: Bool
    @Binding var intervalVal: Int
    @State var timerTest : Timer?
    @State var historyString : String = ""
    @StateObject var hapticsEngine = HapticsEngine()
    @State var timerVal: Int = 0
    
    var hours: Int {
        self.timerVal / 3600
    }

//    var minutes: Int {
//        (self.timerVal % 3600) / 60
//    }
//
//    var seconds: Int {
//        self.timerVal % 60
//    }
    
    var body: some View {
        VStack {
            if timerVal >= 0 {
                Text("Time lapsed")
                    .font(.system(size: 14))
                HStack(spacing: 2) {
                    StopwatchUnitView(timeUnit: self.hapticsEngine.minutes)
                    Text(":")
                    StopwatchUnitView(timeUnit: self.hapticsEngine.seconds)
                }
                    .font(.system(size: 40))
                    .onAppear(){
                        self.hapticsEngine.startPlayinTicks(intervalVal: self.intervalVal)

//                        timerTest = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
//                            self.timerVal += 1
//
//                            print("\(self.timerVal) / \(self.intervalVal)")
//                            if ((self.timerVal % self.intervalVal) == 0) {
//                                print("buzz")
//                                WKInterfaceDevice.current().play(.success)
//                                self.historyString += "*"
//                            }
//                        }
                }
                Text("\(intervalVal) seconds")
                    .font(.system(size: 14))
//                Text("\(self.hapticsEngine.timerValue) seconds")
//                    .font(.system(size: 14))
                Text(self.hapticsEngine.historyString)
                Button(action: {
                    self.secondScreenShown = false
                    self.timerTest?.invalidate()
                    self.timerTest = nil
                    self.timerVal = 0
                    self.historyString = ""
                    self.hapticsEngine.stopPlayingTicks()
                }) {
                    Text("Cancel")
                        .foregroundColor(.red)
                }
            } else {
                Button(action: {
                    self.secondScreenShown = false
                }) {
                    Text("Done")
                        .foregroundColor(.green)
                }
            }
            
        }
    }
}


struct StopwatchUnitView: View {

    var timeUnit: Int

    /// Time unit expressed as String.
    /// - Includes "0" as prefix if this is less than 10
    var timeUnitStr: String {
        let timeUnitStr = String(timeUnit)
        return timeUnit < 10 ? "0" + timeUnitStr : timeUnitStr
    }

    var body: some View {
        HStack (spacing: 2) {
            Text(timeUnitStr.substring(index: 0)).frame(width: 25)
            Text(timeUnitStr.substring(index: 1)).frame(width: 25)
        }
    }
}

extension String {
    func substring(index: Int) -> String {
        let arrayString = Array(self)
        return String(arrayString[index])
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
