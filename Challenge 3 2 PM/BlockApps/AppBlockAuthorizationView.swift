//
//  AppBlockView.swift
//  Challenge 3 2 PM
//
//  Created by Anantika Tiwari on 10/11/25.
//

import SwiftUI
import FamilyControls

struct AppBlockView: View {
    
    let center = AuthorizationCenter.shared
    
    var body: some View {
        ContentView()
            .task{
                do{
                    try await center.requestAuthorization(for: .individual)
                }catch{
                    print("Failed to get authorization: \(error)")
                }
            }
    }
}


#Preview {
    AppBlockView()
}
