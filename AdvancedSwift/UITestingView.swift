//
//  UITestingView.swift
//  AdvancedSwift
//
//  Created by Emirhan Gökçe on 11.09.2026.
//

import SwiftUI
import Combine

class UITestingViewModel: ObservableObject{
    let placeHolderText : String = "Add your name..."
    @Published var textFieldText : String = ""
    @Published var currentUserIsSignedIn : Bool
    
    init(currentUserIsSignedIn : Bool){
        self.currentUserIsSignedIn = currentUserIsSignedIn
    }
    func signUpButtonPressed(){
        guard !textFieldText.isEmpty else {return}
        currentUserIsSignedIn = true
    }
}

struct UITestingView: View {
    //TODO: CHECK IT OUT.
    @StateObject private var vm : UITestingViewModel
    
    //TODO: _ kullanmanın nedeni, StateObject'i referans göstermen?
    init(currentUserIsSignedIn : Bool){
        _vm = StateObject(wrappedValue: UITestingViewModel(currentUserIsSignedIn: currentUserIsSignedIn))
    }
    
    
    var body: some View {
        ZStack{
            LinearGradient(colors: [.pink, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            ZStack{
                if vm.currentUserIsSignedIn{
                    SignedInHomeView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .transition(.move(edge: .leading))
                }
                if !vm.currentUserIsSignedIn{
                    signUpLayer
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .transition(.move(edge: .leading))
                }
            }
            
        }
    }
}

#Preview {
    UITestingView(currentUserIsSignedIn: true)
}


extension UITestingView{
    private var signUpLayer : some View{
        VStack{
            TextField(vm.placeHolderText, text: $vm.textFieldText)
                .font(.headline)
                .padding()
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .accessibilityIdentifier("SignUpTextField")
            
            Button {
                withAnimation(.spring){
                    vm.signUpButtonPressed()
                }
            } label: {
                Text("Sign Up")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .accessibilityIdentifier("SignUpButton")
            }

        }.padding()
    }
}

struct SignedInHomeView : View {
    @State private var showAlert : Bool = false
    var body: some View {
        NavigationStack{
            VStack(spacing:20){
                Button {
                    showAlert.toggle()
                } label: {
                    Text("Show welcome alert!")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.white)
                        .background(Color.red)
                        .cornerRadius(10)
                        .accessibilityIdentifier("ShowAlertButton")
                }
                .alert(isPresented: $showAlert) {
                    return Alert(title: Text("Welcome to the app"))
                }
                
                NavigationLink {
                    Text("Destination")
                } label: {
                    Text("Navigate")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }.accessibilityIdentifier("NavigationLinkToDestination")


            }
            .padding()
            .navigationTitle("Welcome")
        }
    }
}
