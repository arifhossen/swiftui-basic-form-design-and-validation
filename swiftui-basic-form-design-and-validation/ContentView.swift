//
//  ContentView.swift
//  swiftui-basic-form-design-and-validation-example
//
//  Created by Arif Hossen on 29/5/20.
//  Copyright © 2020 Arif Hossen. All rights reserved.
//

import SwiftUI


//Custom Button Modifer
struct ButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.all, 12)
            .foregroundColor(.black)
            .background(Color.yellow)
            .cornerRadius(12)
        
    }
}

struct CustomTextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .font(.headline)
            .padding()
            .foregroundColor(.black)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 40)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 0.2)
                
        )
            .foregroundColor(.gray)
        
    }
}

struct MultilineTextView: UIViewRepresentable {
    @Binding var text: String
    
    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.isScrollEnabled = true
        view.isEditable = true
        view.isUserInteractionEnabled = true
        return view
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
}

class UserModel: ObservableObject {
    
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var email: String = ""
    @Published var isEmailValid: Bool = false
    
    @Published var birthday: Date = Date()
    @Published var age: String = ""
    @Published var agree_terms: Bool = true
    @Published var selectedGenderIndex: Int = 0
    @Published var about_yourself: String = ""
    
    
    func isUserInformationValid() -> Bool {
        if username.isEmpty {
            print("username \(username)")
            return false
        }
        
        if password.isEmpty {
            return false
        }
        if email.isEmpty{
            return false
        }
        
        if !agree_terms {
            return false
        }
        
        return true
    }
    
    
    func textFieldValidatorEmail(_ string: String) -> Bool {
        if string.count > 100 {
            return false
        }
        let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        //let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: string)
    }
    
}


//Alert Dialog Enum Value
enum CustomActiveAlert {
    case first, second, third
}



struct ContentView: View {
    
    @ObservedObject var model = UserModel()
    
    @State private var showAlert = false
    @State private var activeAlert: CustomActiveAlert = .first
    
    private var genderOptions = ["🙍‍♂️ Male", "🙍‍♀️ Female", "🤖 Other"]
    
    var body: some View {
        
        
        ScrollView{
            
            VStack{
                
                Image("swiftui-logo")
                Text("Basic Form Design and Validation")
                    .foregroundColor(.green)
                    .font(.system(size: 20))
                
                Spacer().frame(height:20)
                
                
                VStack(alignment:.leading){
                    
                    
                    Section{
                        
                        HStack{
                            Text("Username")
                            Text("*").foregroundColor(Color.red)
                        }
                        TextField("Your username", text: $model.username)
                            .modifier(CustomTextFieldModifier())
                        
                        HStack{
                            Text("Password")
                            Text("*").foregroundColor(Color.red)
                        }
                        SecureField("Your password", text: $model.password)
                            .modifier(CustomTextFieldModifier())
                        
                        HStack{
                            Text("Email")
                            Text("*").foregroundColor(Color.red)
                        }
                        TextField("Your email", text: $model.email, onEditingChanged: { (isChanged) in
                            if !isChanged {
                                if self.model.textFieldValidatorEmail(self.model.email) {
                                    self.model.isEmailValid = true
                                } else {
                                    
                                    self.model.isEmailValid = false
                                    self.showAlert = true
                                    self.activeAlert = .second
                                    
                                }
                            }
                        })
                            .modifier(CustomTextFieldModifier())
                        
                    }
                    Section{
                        
                        Text("Your age")
                        TextField("Your age", text: $model.age).keyboardType(.numberPad)
                            .modifier(CustomTextFieldModifier())
                        
                        Text("Gender")
                        Picker("Gender", selection: $model.selectedGenderIndex) {
                            ForEach(0..<genderOptions.count) {
                                Text(self.genderOptions[$0])
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    Text("About Yourself")
                    MultilineTextView(text: $model.about_yourself)
                        .lineLimit(3)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 30)
                        .modifier(CustomTextFieldModifier())
                    
                    Toggle(isOn: $model.agree_terms){
                        
                        HStack{
                            Text("Do you Agree terms & Conditions?")
                                .font(.headline)
                                .foregroundColor(Color.black)
                                
                            Text("*").foregroundColor(Color.red)
                        }
                    }
               
                    
                }
                
                
                Section {
                    Button(action: {
                        
                        if self.model.isUserInformationValid() {
                            
                            print("User information is valid")
                            self.showAlert = true
                            self.activeAlert = .third
                        }
                        else{
                            print("User information requried")
                            self.showAlert = true
                            self.activeAlert = .first
                        }
                        
                    }, label: {
                        Text("Create Account")
                    })
                        .modifier(ButtonModifier())
                    
                }
                
                
            }
            .alert(isPresented: $showAlert) {
                switch activeAlert {
                case .first:
                    return Alert(title: Text("Required Field!"), message: Text("Please Fillup Required Field!"), dismissButton: .default(Text("Ok")))
                case .second:
                    return  Alert(title: Text("Information"), message: Text("Please Enter Valid Email Address"), dismissButton: .default(Text("Ok")))
                case .third:
                    return  Alert(title: Text("Information"), message: Text("Form Fillup and Validated Successfully"), dismissButton: .default(Text("Ok")))
                    
                    
                }
            }
            
            Spacer()
            
        }
        .padding()
        
        
    }
    
    
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
