//
//  HRSwiftUIApp.swift
//  HRSwiftUI
//
//  Created by Esther Elzek on 29/04/2026.
//

import SwiftUI

@main
struct HRSwiftUIApp: App {
    @State private var isLoggedIn = false
    @State private var hasSelectedProtection = false

    var body: some Scene {
        WindowGroup {
            if hasSelectedProtection {
                MainTabView()
            } else if isLoggedIn {
                ChooseProtectionMethod(hasSelectedProtection: $hasSelectedProtection)
            } else {
                ScanAndInfoView(isLoggedIn: $isLoggedIn)
            }
        }
    }
}
