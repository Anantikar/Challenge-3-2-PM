//
//  BlockAppsView.swift
//  Challenge 3 2 PM
//
//  Created by T Krobot on 10/11/25.
//

import SwiftUI
import FamilyControls


struct BlockAppsView: View {
    
    let center = AuthorizationCenter.shared
    
    var body: some View {
        BlockerView()
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
    BlockAppsView()
}
