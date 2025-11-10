//
//  BlockerView.swift
//  Challenge 3 2 PM
//
//  Created by Anantika Tiwari on 10/11/25.
//

import SwiftUI
import FamilyControls

struct BlockerView: View {
    
    @StateObject private var manager = ShieldManager()
    @State private var showActivityPicker = false
    @State private var isLocked = false
    @State private var lockButton = "Unlocked"
    @State private var wakeUp = Date.now
    
    let timer = Timer.publish(every:60, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            Text("Block Apps")
                .frame(maxWidth: 500, maxHeight: 50, alignment: .topLeading)
                .padding()
                .bold()
                .font(.largeTitle)
            
            Button {
                showActivityPicker = true
            } label: {
                Label("Choose apps to block", systemImage: "gearshape")
            }
            .buttonStyle(.borderedProminent)
            .padding()
            
            HStack{
                Text("Block until:")
                    .font(.title3)
                DatePicker("Block Until:", selection: $wakeUp, displayedComponents: .hourAndMinute)
                    .labelsHidden()
            }
            
            Button {
                manager.shieldActivities()
                isLocked = true
                lockButton = "Locked"
            }label: {
                Label(lockButton, systemImage: "lock")
            }
            .buttonStyle(.bordered)
            .padding()
        }
        .familyActivityPicker(isPresented: $showActivityPicker, selection: $manager.discouragedSelections)
        .onReceive(timer){ currentTime in
            if currentTime >= wakeUp && isLocked{
                isLocked = false
                lockButton = "Unlocked"
                manager.unshieldActivities()
            }
        
        }
    }
}



#Preview {
    BlockerView()
}
