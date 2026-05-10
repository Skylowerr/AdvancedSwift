//
//  DependencyInjectionExample.swift
//  AdvancedSwift
//
//  Created by Emirhan Gökçe on 9.05.2026.
//

import SwiftUI
/*
 DatabaseManagerProtocol
 DatabaseManager
 DataService
 */

protocol DatabaseManagerProtocol{
    func fetchData() -> [String]
}

//Real Manager
class DatabaseManager : DatabaseManagerProtocol{
    func fetchData() -> [String] {
        return ["real data1", "real data2"]
    }
}

//Mock Manager
class MockDatabaseManager: DatabaseManagerProtocol {
    func fetchData() -> [String] {
        return ["Test Verisi 1", "Test Verisi 2"]
    }
}

//DataService depends on the protocol, not the concrete implementation.
class DataService{
    private let databaseManager : DatabaseManagerProtocol
    init(databaseManager: DatabaseManagerProtocol) {
        self.databaseManager = databaseManager
    }
    func getData() -> [String] {
        return databaseManager.fetchData()
    }
}
//let dbManager = DatabaseManager()
//let dataService = DataService(databaseManager: dbManager)


struct DependencyInjectionExample: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    DependencyInjectionExample()
}
