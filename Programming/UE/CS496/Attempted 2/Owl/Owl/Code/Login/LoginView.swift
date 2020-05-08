//
//  LoginView.swift
//  Owl
//
//  Created by Nhan Cao on 4/26/20.
//  Copyright © 2020 Nhan Cao. All rights reserved.
//

import SwiftUI
import Resolver

struct LoginView: View {
    @State var email: String = ""
    @State var password: String = ""
    
    @State var warning: String = " "
    
//    func doNothing() {}
    
    @Injected var authenticationService: AuthenticationService
    
    var body: some View {
        NavigationView {
//        HStack {
            VStack {
    
                Text("Login")
                    .font(.title)
                TextField("Email", text: $email)
                    .autocapitalization(.none)
                    .textContentType(.username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .autofill
                SecureField("Password", text: $password)
                    .autocapitalization(.none)
                    .textContentType(.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(
                    "Login",
                    action: {
//                        self.doNothing()
                        self.authenticationService.signIn(email: self.email, password: self.password,  handler: {res,err in
//                            print(res)
//                            print(err)
                            
                            self.warning = err?.localizedDescription ?? " "
                            
                        })
                }
                )
                
                
                
                
                Text(warning).foregroundColor(Color.red)
                
                Spacer()
                
                Divider()
                HStack {
                    Text("Don't have an account?").foregroundColor(.gray)
                        .font(.footnote)
                    NavigationLink(destination: CreateAccountView()) {
                        
                        Text("Create an account")
                    }.font(.footnote)
                }
                
//                Spacer()
            }.padding()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
