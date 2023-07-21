//
//  View+extensions.swift
//  ISS_Journey
//
//  Created by michaell medina on 20/07/23.
//

import Foundation
import SwiftUI

extension View {
    
    func centerHorizontally () -> some View {
        HStack {
            Spacer ()
            self
            Spacer ()
        }
    }
}
