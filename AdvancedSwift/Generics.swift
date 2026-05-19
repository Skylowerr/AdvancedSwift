//
//  Generics.swift
//  AdvancedSwift
//
//  Created by Emirhan Gökçe on 13.05.2026.
//

import SwiftUI

struct StringModel {
    let info : String?
    
    func removeInfo() -> StringModel{
        StringModel(info: nil)
    }
}

// T = Type
struct GenericModel<T> {
    let info : T?
    
    func removeInfo() -> GenericModel{
        GenericModel(info: nil)
    }
}



@Observable
class GenericsViewModel{
    var stringModel = StringModel(info: "Hello World!")
    var genericModel = GenericModel(info: true)

    func removeData(){
        stringModel = stringModel.removeInfo()
        genericModel = genericModel.removeInfo()
    }
}


struct GenericView<T: View> : View{
    let content : T
    let title : String
    
    var body : some View{
        VStack{
            Text(title)
            content
        }
    }
}

struct Generics: View {
    @State private var vm = GenericsViewModel()
    var body: some View {
        VStack{
            GenericView(content: Text("Hello"), title: "Maan")
            Text(vm.stringModel.info ?? "No data")
            Text(vm.genericModel.info?.description ?? "No data")
        }
        .onTapGesture {
            vm.removeData()
        }

    }
}

#Preview {
    Generics()
}
