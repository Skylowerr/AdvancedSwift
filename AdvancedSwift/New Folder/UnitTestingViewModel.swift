//
//  UnitTestingViewModel.swift
//  AdvancedSwift
//
//  Created by Emirhan Gökçe on 12.05.2026.
//

import Foundation
import SwiftUI
import Combine



final class UnitTestingViewModel: ObservableObject {
    var isPremium : Bool
    @Published var dataArray : [String] = []
    @Published var selectedItem: String? = nil
    let dataService : NewDataServiceProtocol
    var cancellables = Set<AnyCancellable>()
    
    init(isPremium: Bool, dataService: NewDataServiceProtocol = NewMockDataService(items: nil)) {
        self.isPremium = isPremium
        self.dataService = dataService
    }
    
    func addItem(item : String){
        guard !item.isEmpty else {return} //Blank string girilmesin ""
        self.dataArray.append(item)
    }
    
    func selectItem(item : String){
        if let x = dataArray.first(where: {$0 == item}){
            self.selectedItem = x
        }else{
            self.selectedItem = nil //MARK: EDGE CASE IDI
        }
    }
    
    func saveItem(item : String) throws {
        guard !item.isEmpty else {
            throw DataError.noData
        }
        
        if let x = dataArray.first(where: {$0 == item}){
            print("Save item here!! \(x)")
        }else{
            throw DataError.itemNotFound
        }
    }
    
    enum DataError : LocalizedError{
        case noData //item "" ise
        case itemNotFound //dataArray içerisinde yoksa
    }
    
    func downloadWithEscaping(){
        dataService.downloadWithEscaping {[weak self] returnedItems in
            self?.dataArray = returnedItems
        }
    }
    
    func downloadWithCombine(){
        dataService.downloadWithCombine()
            .sink { _ in
                
            } receiveValue: {[weak self] returnedItems in
                self?.dataArray = returnedItems
            }
            .store(in: &cancellables)

    }
    
    
    
}

