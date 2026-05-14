//
//  Generics.swift
//  AdvancedSwift
//
//  Created by Emirhan Gökçe on 13.05.2026.
//

import SwiftUI

@Observable
class GenericsViewModel{
    var dataArray : [String] = []
    
    init(){
        dataArray = ["one","two","three"]
    }
    
    func removeDataFromDataArray(){
        dataArray.removeAll()
    }
    
    
}

struct Generics: View {
    @State private var vm = GenericsViewModel()
    var body: some View {
        VStack{
            ForEach(vm.dataArray, id: \.self){item in
                Text(item)
                    .onTapGesture {
                        vm.removeDataFromDataArray()
                    }
            }
        }
    }
}

#Preview {
    Generics()
}
