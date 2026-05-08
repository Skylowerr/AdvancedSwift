//
//  Protocols.swift
//  AdvancedSwift
//
//  Created by Emirhan Gökçe on 8.05.2026.
//

import SwiftUI



//MARK: Protocollerde let kullanamayız. Çünkü değişken
//MARK: Ayrıca, program boyunca değişmeyeceği için fetch etmek için get kullanırız
protocol ColorThemeProtocol {
    var primary: Color {get}
    var secondary : Color {get}
    var tertiary : Color {get}
}

struct DefaultColorTheme : ColorThemeProtocol{
    let primary : Color = .blue
    let secondary: Color = .white
    let tertiary : Color = .gray
}

struct AlternativeColorTheme : ColorThemeProtocol {
    let primary: Color = .red
    let secondary: Color = .white
    let tertiary: Color = .yellow
}

//

protocol DataSourceProtocol {
    var buttonText : String {get}
}

protocol ButtonTextProtocol {
    func buttonPressed()

}

//MARK: Protocols can inherit from other protocols. It is ok to be empty
protocol ButtonDataSourceProtocol : ButtonTextProtocol, DataSourceProtocol{}

//Virgül atıp 2 tane inherit etmek yerine böyle de yapabilirsin.
final class DefaultDataSource : ButtonDataSourceProtocol{
    var buttonText : String = "Protocols are awesome!"
    func buttonPressed(){
        print("Hello World.")
    }
    
}

final class AlternativeDataSource : DataSourceProtocol{
    var buttonText : String = "Protocols are lame!"

}

struct Protocols: View {
    let colorTheme: ColorThemeProtocol
    
    let dataSource : ButtonDataSourceProtocol
    
    var body: some View {
        ZStack{
            colorTheme.primary.ignoresSafeArea()
            Text(dataSource.buttonText)
                .font(.headline)
                .foregroundStyle(colorTheme.secondary)
                .padding()
                .background(colorTheme.tertiary)
                .cornerRadius(10)
                .onTapGesture {
                    dataSource.buttonPressed()
                }
            
        }
    }
}


#Preview {
    Protocols(colorTheme: DefaultColorTheme(), dataSource: DefaultDataSource())
}
