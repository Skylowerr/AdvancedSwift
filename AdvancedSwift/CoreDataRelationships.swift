//
//  CoreDataRelationships.swift
//  AdvancedSwift
//
//  Created by Emirhan Gökçe on 9.09.2026.
//

import SwiftUI
import CoreData
import Combine

//BusinessEntities
//DepartmentEntities
//EmployeeEntities

///Bir business'ın  birden fazla departmanı varsa one to many işaretlemen lazım. Sadece 1 departmansa one to one
///Bir departman fazla da olabilir
class CoreDataManager{
    static let instance = CoreDataManager()
    let container : NSPersistentContainer
    let context : NSManagedObjectContext
    init() {
        container = NSPersistentContainer(name: "CoreDataContainer")
        container.loadPersistentStores { description, error in
            if let error = error{
                print("ERROR LOADING CORE DATA \(error)")
            }
        }
        context = container.viewContext
    }
    
    func save(){
        do {
            try context.save()
        } catch let error {
            print("Error saving core data \(error.localizedDescription)")
        }
    }
}

class CoreDataRelationshipViewModel : ObservableObject{
    let manager = CoreDataManager.instance
    
    @Published var businesses : [BusinessEntity] = []
    @Published var departments : [DepartmentEntity] = []
    @Published var employees : [EmployeeEntity] = []

    init() {
        getBusinesses()
        getDepartments()
        getEmployees()
    }
    
    func addBusiness(){
        let newBusiness = BusinessEntity(context: manager.context)
        newBusiness.name = "Facebook"
        
        //Add existing departments to new business
        newBusiness.departments = [departments[0]]
        
        //Add existing employees to new business
        //newBusiness.employees = [employees[1]]
        
        //Add new business to existing department
        //newBusiness.addToDepartments(<#T##value: DepartmentEntity##DepartmentEntity#>)
        
        //Add new business to existin employee
        //newBusiness.addToEmployees(<#T##value: EmployeeEntity##EmployeeEntity#>)
        
        
        save()
        
    }
    
    func addDepartment(){
        let newDepartment = DepartmentEntity(context: manager.context)
        newDepartment.name = "Finance"
        newDepartment.businesses = [businesses[0], businesses[1]]
        newDepartment.addToEmployees(employees[0])
        
        //newDepartment.employees = [employees[1]] //1. yol
        newDepartment.addToEmployees(employees[1]) //2. yol
        
        save()
    }
    
    func addEmployee(){
        let newEmployee = EmployeeEntity(context: manager.context)
        newEmployee.name = "John"
        newEmployee.age = 22
        newEmployee.dateJoined = Date()
        
        newEmployee.business = businesses[2] //One to one
        newEmployee.department = departments[0]
        save()
    }

    
    func getBusinesses(){
        let request = NSFetchRequest<BusinessEntity>(entityName: "BusinessEntity")
        let sort = NSSortDescriptor(keyPath: \BusinessEntity.name, ascending: true)
        do {
            businesses = try manager.context.fetch(request)
        } catch let error {
            print("Error fetching \(error.localizedDescription)")
        }
        
    }
    
    func getDepartments(){
        let request = NSFetchRequest<DepartmentEntity>(entityName: "DepartmentEntity")
        do {
            departments = try manager.context.fetch(request)
        } catch let error {
            print("Error fetching \(error.localizedDescription)")
        }
    }
    
    func getEmployees(){
        let request = NSFetchRequest<EmployeeEntity>(entityName: "EmployeeEntity")
        do {
            employees = try manager.context.fetch(request)
        } catch let error {
            print("Error fetching \(error.localizedDescription)")
        }
    }
    
    func getEmployees(forBusiness business: BusinessEntity){
        let request = NSFetchRequest<EmployeeEntity>(entityName: "EmployeeEntity")
        let filter = NSPredicate(format : "business == %@" , business)
        request.predicate = filter
        
        do {
            employees = try manager.context.fetch(request)
        } catch let error {
            print("Error fetching \(error.localizedDescription)")
        }
    }


    func updateBusiness(){
        let existingBusiness = businesses[2]
        existingBusiness.addToDepartments(departments[1])
        save()
    }
    
    func save(){
        businesses.removeAll()
        departments.removeAll()
        //employees.removeAll()
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1){
            self.manager.save()
            self.getBusinesses()
            self.getDepartments()
            //self.getEmployees()
        }
    }
    
    //MARK: DELETE RULES
    //Nullify -> Silersen, diğer relationlar kalır. Örn, Finance silsen de Emily kalır
    //Cascade -> Silersen hepsi gider. Emily falan da komple silinir.
    //Deny -> Finance'i silmek için önce Emily'i silmen gerekir
    func deleteDepartment(){
        let department = departments[2]
        manager.context.delete(department)
        save()
    }
    
    
    
}

struct CoreDataRelationships: View {
    @StateObject var vm = CoreDataRelationshipViewModel()
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(spacing:20){
                    Button {
                        vm.deleteDepartment()
                    } label: {
                        Text("Perform Action")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .padding()
                    
                    // ScrollView butonun DIŞINDA olmalı!
                    ScrollView(.horizontal, showsIndicators: true){
                        HStack(alignment: .top){
                            ForEach(vm.businesses){ business in
                                BusinessView(entity: business)
                            }
                        }
                    }
                    
                    ScrollView(.horizontal, showsIndicators: true){
                        HStack(alignment: .top){
                            ForEach(vm.departments){ department in
                                DepartmentView(entity: department)
                            }
                        }
                    }
                    
                    ScrollView(.horizontal, showsIndicators: true){
                        HStack(alignment: .top){
                            ForEach(vm.employees){ employee in
                                EmployeeView(entity: employee)
                            }
                        }
                    }
                    
                }                .navigationTitle("Relationships")

            }
        }
    }
}

#Preview {
    CoreDataRelationships()
}

struct BusinessView : View {
    let entity : BusinessEntity
    var body: some View {
        VStack(alignment: .leading, spacing: 20){
            Text("Name : \(entity.name ?? "")")
                .bold()
            
            if let departments = entity.departments?.allObjects as? [DepartmentEntity] {
                    Text("Departments : ")
                    .bold()
                ForEach(departments){ department in
                    Text(department.name ?? "")
                }
            }
            
            if let employees = entity.employees?.allObjects as? [DepartmentEntity] {
                    Text("Employees : ")
                    .bold()
                ForEach(employees){ employee in
                    Text(employee.name ?? "")
                }
            }
        }
        .padding()
        .frame(maxWidth: 300, alignment: .leading)
        .background(.gray.opacity(0.7))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 10)
    }
}


struct DepartmentView : View {
    let entity : DepartmentEntity
    var body: some View {
        VStack(alignment: .leading, spacing: 20){
            Text("Name : \(entity.name ?? "")")
                .bold()
            
            if let businesses = entity.businesses?.allObjects as? [BusinessEntity] {
                    Text("Businesses : ")
                    .bold()
                ForEach(businesses){ business in
                    Text(business.name ?? "")
                }
            }
            
            if let employees = entity.employees?.allObjects as? [DepartmentEntity] {
                    Text("Employees : ")
                    .bold()
                ForEach(employees){ employee in
                    Text(employee.name ?? "")
                }
            }
        }
        .padding()
        .frame(maxWidth: 300, alignment: .leading)
        .background(.green.opacity(0.7))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 10)
    }
}

struct EmployeeView : View {
    let entity : EmployeeEntity
    var body: some View {
        VStack(alignment: .leading, spacing: 20){
            Text("Name : \(entity.name ?? "")")
                .bold()
            Text("Age : \(entity.age)")
            Text("Date Joined : \(entity.dateJoined ?? Date())" )
            Text("Business : ")
                .bold()
            Text(entity.business?.name ?? "")
            
            Text("Department : ")
                .bold()
            
            Text(entity.department?.name ?? "")
            
        }
        .padding()
        .frame(maxWidth: 300, alignment: .leading)
        .background(.blue.opacity(0.7))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 10)
    }
}
