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
        Text("pick a name for your dog!")
        Form{
            TextField("name", text: $dogManager.name)
            Button("get started") {
                hasSeenFirstTimeSheet = true // Mark as seen
                dismiss() // Dismiss the sheet
            }
            .disabled(dogManager.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
    }
}

#Preview {
    FirstTimeSheetView(hasSeenFirstTimeSheet: .constant(false), dogManager: DogManager())
}
