//
//  SharedDogDefaults.swift
//  Challenge 3 2 PM
//
//  Created by T Krobot on 17/11/25.
//

import Foundation

struct SharedDogDefaults {
    static let groupID = "group.2pm.widget"
    static var shared: UserDefaults {
        return UserDefaults(suiteName: groupID)!
    }
}
