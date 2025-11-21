//
//  BlockerView.swift
//  Challenge 3 2 PM
//
//  Created by Anantika Tiwari on 10/11/25.
//

import SwiftUI
import FamilyControls

struct BlockerView: View {
    @Environment(\.presentationMode) private var
    presentationMode: Binding<PresentationMode>
    @ObservedObject var manager: ShieldManager
    @Binding var wakeUp: Date?
    @State private var showActivityPicker = false
    
    var body: some View {
        NavigationStack{
            Form {
                Button {
                    showActivityPicker = true
                } label: {
                    Label("Choose apps to block", systemImage: "gearshape")
                }
                
                HStack{
                    Text("Block until:")
                        .font(.title3)
                    DatePicker(
                        "Block Until:",
                        selection: Binding(
                            get: { wakeUp ?? Date() },
                            set: { wakeUp = $0 }
                        ),
                        displayedComponents: .hourAndMinute
                    )
                    .labelsHidden()
                }
                
                
                Button(action: {
                    manager.blockUntil = wakeUp
                    manager.isLocked = true
                    manager.shieldActivities(until: wakeUp)

                    presentationMode.wrappedValue.dismiss()
                }) {
                    Label("Confirm", systemImage: "checkmark.circle")
                }
                
            }
            .navigationTitle("Block Apps")
        }
        .familyActivityPicker(isPresented: $showActivityPicker, selection: $manager.discouragedSelections)
    }
}



#Preview {
    BlockerView(manager: ShieldManager(),
                wakeUp: .constant(Date().addingTimeInterval(3600)))
}
