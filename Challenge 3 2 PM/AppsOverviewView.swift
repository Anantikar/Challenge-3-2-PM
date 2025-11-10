//
//  AppsOverviewView.swift
//  Challenge 3 2 PM
//
//  Created by Anantika Tiwari on 10/11/25.
//

import SwiftUI
import FamilyControls

struct AppsOverviewView: View {
    @State var dogName = ""
    var body: some View {
        VStack{
            Text("\(dogName) has blocked these apps:")
                .font(.largeTitle)
                .bold()
                .padding()
            Text("P")
            NavigationStack{
                NavigationLink{
                    BlockAppsView()
                }label: {
                    Text("Edit")
                }
            }
        }
    }
}

#Preview {
    AppsOverviewView(dogName: "")
}
