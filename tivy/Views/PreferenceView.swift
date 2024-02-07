//
//  PreferenceView.swift
//  tivy
//
//  Created by Isaac Schiffler on 6/7/23.
//

import SwiftUI

struct PreferenceView: View {
    @Binding var hasPref: Bool
    @Binding var pref: Preference?
    let timeOptions = ["Any",  "Daytime", "Sunrise", "Morning", "Breakfast", "Lunch", "Afternoon", "Dinner", "Sunset", "Night", "Late Night"]
    @State private var tempPref: Preference = Preference(effort: 0, time: 0, cost: 0, distance: 0, physical: 0, timeOfDay: "Any")
    
    
    
    var body: some View {
        ScrollView {
            Text("Sort by:")
                .font(.system(size: 40, weight: .bold))
                .padding(.top, 30)
            VStack {
                VStack {
                    Text(String(format: "Effort Rating: %.1f", tempPref.effort))
                        .font(.footnote)
                        .frame(width: 350, alignment: .leading) // Set a fixed frame width for the label
                    
                    Slider(value: $tempPref.effort, in: 0.0...5.0, step: 0.1)
                        .frame(width: 325)
                }
                .padding([.top, .leading, .trailing], 10)
                VStack {
                    Text(String(format: "Time Commitment Rating: %.1f", tempPref.time))
                        .font(.footnote)
                        .frame(width: 350, alignment: .leading) // Set a fixed frame width for the label
                    
                    Slider(value: $tempPref.time, in: 0.0...5.0, step: 0.1)
                        .frame(width: 325)
                }
                .padding([.top, .leading, .trailing], 10)
                VStack {
                    Text(String(format: "Cost Rating: %.1f", tempPref.cost))
                        .font(.footnote)
                        .frame(width: 350, alignment: .leading) // Set a fixed frame width for the label
                    
                    Slider(value: $tempPref.cost, in: 0.0...5.0, step: 0.1)
                        .frame(width: 325)
                }
                
                .padding([.top, .leading, .trailing], 10)
                VStack {
                    Text(String(format: "Physicality Rating: %.1f", tempPref.physical))
                        .font(.footnote)
                        .frame(width: 350, alignment: .leading) // Set a fixed frame width for the label
                    
                    Slider(value: $tempPref.physical, in: 0.0...5.0, step: 0.1)
                        .frame(width: 325)
                    
                }
                .padding([.top, .leading, .trailing], 10)
                VStack {
                    Text("Ideal time:")
                        .font(.footnote)
                        .padding(.top)
                        .frame(width: 350, alignment: .leading) // Set a fixed frame width for the label
                    
                    Picker("Select an ideal time", selection: $tempPref.timeOfDay) {
                        ForEach(timeOptions, id: \.self) { option in
                            Text(option)
                        }
                    }
                    .padding(.bottom)
                    .offset(y: -20)
                    .pickerStyle(.menu)
                    .accentColor(.mint)
                }
            }
            
            Button {
                pref = tempPref
                hasPref = true
            } label: {
                Text("Add Preferences")
                    .bold()
                    .font(.title)
            }
            .padding(.vertical, 10)
            Button {
                hasPref = true
            } label: {
                Text("Want to explore everything? View activities with no preferences")
                    .bold()
                    .font(.footnote)
            }
            .padding(.all, 10)

            
        }
        .foregroundStyle(.linearGradient(colors: [.green, .mint], startPoint: .topLeading, endPoint: .bottomTrailing))    }
}

struct PreferenceView_Previews: PreviewProvider {
    static var previews: some View {
        PreferenceView(hasPref: .constant(false), pref: .constant(nil))
    }
}
