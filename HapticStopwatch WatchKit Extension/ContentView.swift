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
    @StateObject var hapticsEngine = HapticsEngine()
    
    var body: some View {
        VStack {
            Text("Time lapsed")
                .font(.system(size: 14))
            HStack(spacing: 2) {
                StopwatchUnitView(timeUnit: self.hapticsEngine.minutes)
                Text(":")
                StopwatchUnitView(timeUnit: self.hapticsEngine.seconds)
            }
                .font(.system(size: 40))
                .onAppear(){
                    self.hapticsEngine.startPlayingTicks(intervalVal: self.intervalVal)
            }
            Text("\(intervalVal) seconds")
                .font(.system(size: 14))
            Text(self.hapticsEngine.historyString)
                .font(.system(size: 20))
            Button(action: {
                self.secondScreenShown = false
                self.hapticsEngine.stopPlayingTicks()
            }) {
                Text("Cancel")
                    .foregroundColor(.red)
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
