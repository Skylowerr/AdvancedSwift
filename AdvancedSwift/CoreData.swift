//
//  CoreData.swift
//  AdvancedSwift
//
//  Created by Emirhan Gökçe on 9.09.2026.
//

import SwiftUI
import CoreData
import Combine


//save, delete, fetch işlemlerini doğrudan container üzerinden yapıyoruz
class CoreDataViewModel : ObservableObject{
    let container : NSPersistentContainer
    @Published var savedEntities : [FruitEntity] = []
    
    init() {
        container = NSPersistentContainer(name: "FruitsContainer")
        container.loadPersistentStores { (description, error) in
            if let error = error{
                print("ERROR LOADING CORE DATA. \(error)")
            }else{
                print("Successfully loaded core data")
            }
        }
        fetchFruits()
    }
    
    func fetchFruits(){
        let request = NSFetchRequest<FruitEntity>(entityName: "FruitEntity")
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching \(error)")
        }
    }
    
    func addFruit(text : String){
        let newFruit = FruitEntity(context: container.viewContext)
        newFruit.name = text
        
        saveData()
    }
    
    func updateFruit(entity: FruitEntity){
        let currentName = entity.name ?? ""
        let newName = currentName + "!"
        entity.name = newName
        saveData()
    }
    
    func deleteFruit(indexSet : IndexSet){
        guard let index = indexSet.first else {return}
        let entity = savedEntities[index]
        container.viewContext.delete(entity)
        saveData()
    }
    
    func saveData(){
        try? container.viewContext.save()
        fetchFruits()
    }
}

struct CoreData: View {
    @StateObject var vm = CoreDataViewModel()
    @State var textFieldText = ""
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 20){
                TextField("Add Item here...", text: $textFieldText)
                    .font(.headline)
                    .padding(.leading)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color(.gray))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal)
                
                Button {
                    guard !textFieldText.isEmpty else {return}
                    vm.addFruit(text: textFieldText)
                    textFieldText = ""
                } label: {
                    Text("Submit")
                        .font(.headline)
                        .foregroundStyle(.pink)
                        .padding(.leading)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color(.gray))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding(.horizontal)
                List{
                    ForEach(vm.savedEntities){entity in
                        Text(entity.name ?? "NO NAME")
                            .onTapGesture {
                                vm.updateFruit(entity: entity)
                            }
                    }
                    .onDelete(perform: vm.deleteFruit)
                }
                .listStyle(.plain)
                
            }.navigationTitle("Fruits")
        }
    }
}

#Preview {
    CoreData()
}
