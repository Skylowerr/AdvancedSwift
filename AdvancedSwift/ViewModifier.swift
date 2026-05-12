//
//  ViewModifier.swift
//  AdvancedSwift
//
//  Created by Emirhan Gökçe on 12.05.2026.
//

import SwiftUI


//MARK: .modifier(DefaultButtonViewModifier()) diyerek kullanabilirsin
struct DefaultButtonViewModifier : ViewModifier{
    let backgroundColor : Color
    func body(content : Content) -> some View {
        content
            .foregroundStyle(.white)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 10).fill(backgroundColor))
            .shadow(radius: 10)
    }
}


//MARK: .withDefaultButtonFormatting() diyerek kullanabilrisn
extension View{
    //Dışarıdan değer girmezsek yeşil arkaplan olacak
    func withDefaultButtonFormatting(backgroundColor : Color = .green) -> some View{
        modifier(DefaultButtonViewModifier(backgroundColor: backgroundColor))
    }
}


struct ViewModifierBootcamp: View {
    var body: some View {
        //Varan 1
        Text("Hello, World!")
            .font(.headline)
            .foregroundStyle(.white)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue))
            .shadow(radius: 10)
            .padding()
        
        //Varan 2
        Text("Hello, World!")
            .font(.headline)
            .modifier(DefaultButtonViewModifier(backgroundColor: .blue))
            .padding()

        //Varan 3
        Text("Hello, World!")
            .font(.title)
            .withDefaultButtonFormatting(backgroundColor: .orange)
            .padding()
        
        //Varan 4
        Text("Hello, World!")
            .font(.title)
            .withDefaultButtonFormatting()
            .padding()



    }
}



#Preview {
    ViewModifierBootcamp()
}
