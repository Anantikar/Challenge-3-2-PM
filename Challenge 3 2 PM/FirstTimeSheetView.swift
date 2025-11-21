//
//  FirstTimeSheetView.swift
//  Challenge 3 2 PM
//
//  Created by T Krobot on 21/11/25.
//

import SwiftUI

struct FirstTimeSheetView: View {
    @Binding var hasSeenFirstTimeSheet: Bool
    @ObservedObject var dogManager: DogManager
    @Environment(\.dismiss) var dismiss
    var body: some View {
        DogImageView(dogManager: dogManager)
            .foregroundStyle(.white)
        Text("Pick a name for your dog!")
        Form{
            TextField("Name", text: $dogManager.name)
            Button("Get Started") {
                hasSeenFirstTimeSheet = true // Mark as seen
                dismiss() // Dismiss the sheet
            }
        }
    }
}

#Preview {
    FirstTimeSheetView(hasSeenFirstTimeSheet: .constant(false), dogManager: DogManager())
}
