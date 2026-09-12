//
//  AdvancedSwiftApp.swift
//  AdvancedSwift
//
//  Created by Emirhan Gökçe on 8.05.2026.
//

import SwiftUI

@main
struct AdvancedSwiftApp: App {
    
    let currentUserIsSignedIn : Bool
    init() {
        let userIsSignedIn : Bool = CommandLine.arguments.contains("-UITest_startSignedIn") ? true : false
        //Argumentsleri çalıştır
        self.currentUserIsSignedIn = userIsSignedIn
        
    }
    var body: some Scene {
        WindowGroup {
            UITestingView(currentUserIsSignedIn : currentUserIsSignedIn)
        }
    }
}
