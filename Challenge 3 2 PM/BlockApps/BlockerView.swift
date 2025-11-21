//
//  BlockerView.swift
//  Challenge 3 2 PM
//
//  Created by Anantika Tiwari on 10/11/25.
//

import SwiftUI
import FamilyControls

struct BlockerView: View {
    @ObservedObject var manager: ShieldManager
    @Binding var wakeUp: Date?
    @State private var showActivityPicker = false
    @Binding var showConfig: Bool
    
    var body: some View {
        NavigationStack{
            Form {
                Button {
                    showActivityPicker = true
                } label: {
                    Label("configure apps", systemImage: "gearshape")
                }
                
                HStack{
                    Text("block until")
                        .font(.title3)
                    DatePicker(
                        "block until",
                        selection: Binding(
                            get: { wakeUp ?? Date() },
                            set: { newValue in
                                let now = Date()
                                let calendar = Calendar.current
                                
                                // Build today's date at the selected hour/minute
                                var components = calendar.dateComponents([.year, .month, .day], from: now)
                                components.hour = calendar.component(.hour, from: newValue)
                                components.minute = calendar.component(.minute, from: newValue)
                                let todayTime = calendar.date(from: components)!

                                // Only accept future times
                                if todayTime >= now {
                                    wakeUp = newValue
                                } else {
                                    // Reject invalid selection (optional: show alert)
                                    print("Cannot choose a past time")
                                }
                            }
                        ),
                        displayedComponents: .hourAndMinute
                        
                    )
                    .labelsHidden()
                }
            }
            .toolbar{
                ToolbarItem(placement: .confirmationAction){
                    Button{
                        showConfig.toggle()
                        manager.blockUntil = wakeUp
                        manager.isLocked = true
                        manager.shieldActivities(until: wakeUp)
                    }label:{
                        Image(systemName: "checkmark.circle")
                    }
                }
            }
            .navigationTitle("block apps")
            .familyActivityPicker(isPresented: $showActivityPicker, selection: $manager.discouragedSelections)
        }
    }
}




#Preview {
    BlockerView(
        manager: ShieldManager(),
        wakeUp: .constant(Date().addingTimeInterval(3600)), showConfig: .constant(false)
    )
}
