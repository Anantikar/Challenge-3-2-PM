//
//  widgetBundle.swift
//  widget
//
//  Created by T Krobot on 17/11/25.
//

import WidgetKit
import SwiftUI

@main
struct widgetBundle: WidgetBundle {
    var body: some Widget {
        DogWidgetExtension()
        widgetControl()
        widgetLiveActivity()
    }
}
