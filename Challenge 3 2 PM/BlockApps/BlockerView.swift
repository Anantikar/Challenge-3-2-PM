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
                            set: { wakeUp = $0 }
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
