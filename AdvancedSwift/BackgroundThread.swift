//
//  BackgroundThread.swift
//  AdvancedSwift
//
//  Created by Emirhan Gökçe on 26.08.2026.
//

import SwiftUI
import Combine

 final class BackgroundThreadViewModel: ObservableObject{
    @Published var dataArray: [String] = []
    
     func fetchData(){
         //MARK: Background Threadde çalıştırıyoruz ağır işi
         //MARK: Yeni thread'e geçtiğimiz için halen daha bu class'ı kullanmak istediğimiz için self(strong reference) veriyoruz
         DispatchQueue.global(qos: .background).async {
             let newData = self.downloadData()
             
             //TODO: Thread Debug. Hangi Kod Hangi Thread'de Çalışıyor
             print("CHECK 1 : \(Thread.isMainThread)") //false. global dediğimiz için Background Threaddeyiz
             print("CHECK 1 : \(Thread.current)") //1 hariç herhangi bir sayı
             
             //MARK: View'ı etkileyecek olan kodu main thread içine atmamız ŞART
             DispatchQueue.main.async {
                 self.dataArray = newData
                 print("CHECK 1 : \(Thread.isMainThread)") //True. Main Threaddeyiz çünkü UI Update ediyoruz
                 print("CHECK 1 : \(Thread.current)") // Main thread = Thread 1

             }
         }
    }
    
    private func downloadData() -> [String]{
        var data : [String] = []
        
        for x in 0..<100{
            data.append("\(x)")
            print(x)
        }
        return data
    }
}



struct BackgroundThread: View {
    @StateObject private var vm = BackgroundThreadViewModel()
    var body: some View {
        ScrollView{
            VStack(spacing:10){
                Text("LOAD DATA")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .onTapGesture {
                        vm.fetchData()
                    }
                ForEach(vm.dataArray, id: \.self) { item in
                    Text(item)
                        .font(.headline)
                        .foregroundStyle(.red)
                }
            }
        }
    }
}

#Preview {
    BackgroundThread()
}
