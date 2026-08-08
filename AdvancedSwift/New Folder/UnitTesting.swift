//
//  UnitTesting.swift
//  AdvancedSwift
//
//  Created by Emirhan Gökçe on 10.05.2026.
//

/*
 1. Unit Tests
 - Tests the business logic in app
 
 2. UI Tests
 - Tests the UI of app
 */
import SwiftUI


struct UnitTesting: View {
    @State private var vm : UnitTestingViewModel
    
    //TODO: Neden _vm
    init(isPremium : Bool){
        _vm = State(wrappedValue: UnitTestingViewModel(isPremium: isPremium))
    }
    var body: some View {
        Text(vm.isPremium.description)
    }
}

#Preview {
    UnitTesting(isPremium: true)
}
