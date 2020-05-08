//
//  CreateNewAccount.swift
//  Owl
//
//  Created by Nhan Cao on 4/27/20.
//  Copyright © 2020 Nhan Cao. All rights reserved.
//

import SwiftUI
import Resolver

struct CreateAccountView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var warning: String = " "
    
    @State var a: Error? = nil
    
    @Injected var authenticationService: AuthenticationService
    
    var body: some View {
        VStack {
            Text("Create an account")
                .font(.title)
            TextField("Email", text: $email)
                .autocapitalization( /*@START_MENU_TOKEN@*/.none /*@END_MENU_TOKEN@*/)
            SecureField("Password", text: $password)
                .autocapitalization(.none)
            Text(warning)
                .foregroundColor(Color.red)
            Button(
                "Create",
                action: {
                    self.authenticationService.signUp(email: self.email, password: self.password, handler: {res,err in
//                        print(res)
//                        print(err)
                        self.a = err
                        self.warning = err?.localizedDescription ?? " "
                    })
            }
            )
            
            Divider()
            
            Text("An account allows to save and access Work Spaces across devices.")
                .font(.footnote)
                .foregroundColor(.gray)
            Spacer()
        }.padding()
    }
}

struct CreateNewAccount_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountView()
    }
}
