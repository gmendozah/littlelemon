let kFirstName = "first name key"
let kLastName = "last name key"
let kEmail = "email key"

import SwiftUI

struct Onboarding: View {
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var email: String = ""
    
    @State private var isLoggedIn = false
    @State private var showValidationError = false
    @State private var validationErrorMessage = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                NavigationLink(destination: Home(), isActive: $isLoggedIn) {
                    EmptyView()
                }
                // Header (Logo)
                HStack(spacing: 8) {
                    Image(systemName: "lemon.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 32, height: 32)
                        .foregroundColor(Color(red: 0.957, green: 0.808, blue: 0.078)) // #F4CE14
                    
                    Text("LITTLE LEMON")
                        .font(.system(size: 24, weight: .black, design: .serif))
                        .foregroundColor(Color(red: 0.286, green: 0.369, blue: 0.341)) // #495E57
                        .tracking(1.5)
                }
                .padding(.vertical, 16)
                
                // Hero Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Little Lemon")
                        .font(.system(size: 40, weight: .bold, design: .serif))
                        .foregroundColor(Color(red: 0.957, green: 0.808, blue: 0.078)) // #F4CE14
                    
                    HStack(alignment: .top, spacing: 16) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Chicago")
                                .font(.system(size: 24, weight: .semibold, design: .serif))
                                .foregroundColor(.white)
                            
                            Text("We are a family owned Mediterranean restaurant, focused on traditional recipes served with a modern twist.")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.9))
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        
                        Image("HeroImage")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 120, height: 120)
                            .cornerRadius(16)
                            .clipped()
                    }
                }
                .padding(20)
                .background(Color(red: 0.286, green: 0.369, blue: 0.341)) // #495E57
                
                // Form Section
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Personal Information")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black.opacity(0.8))
                            .padding(.top, 24)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("First Name *")
                                .font(.caption.bold())
                                .foregroundColor(.gray)
                            TextField("First Name", text: $firstName)
                                .textFieldStyle(.roundedBorder)
                                .textInputAutocapitalization(.words)
                                .disableAutocorrection(true)
                        }
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Last Name *")
                                .font(.caption.bold())
                                .foregroundColor(.gray)
                            TextField("Last Name", text: $lastName)
                                .textFieldStyle(.roundedBorder)
                                .textInputAutocapitalization(.words)
                                .disableAutocorrection(true)
                        }
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Email *")
                                .font(.caption.bold())
                                .foregroundColor(.gray)
                            TextField("Email", text: $email)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .disableAutocorrection(true)
                        }
                        
                        if showValidationError {
                            Text(validationErrorMessage)
                                .foregroundColor(.red)
                                .font(.caption)
                                .bold()
                        }
                        
                        // Button
                        Button(action: {
                            if !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty && isValidEmail(email) {
                                showValidationError = false
                                UserDefaults.standard.set(firstName, forKey: kFirstName)
                                UserDefaults.standard.set(lastName, forKey: kLastName)
                                UserDefaults.standard.set(email, forKey: kEmail)
                                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                                isLoggedIn = true
                            } else {
                                if firstName.isEmpty || lastName.isEmpty || email.isEmpty {
                                    validationErrorMessage = "All fields are required."
                                } else {
                                    validationErrorMessage = "Please enter a valid email address."
                                }
                                showValidationError = true
                            }
                        }) {
                            Text("Register")
                                .font(.headline)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(red: 0.957, green: 0.808, blue: 0.078)) // #F4CE14
                                .cornerRadius(8)
                        }
                        .padding(.top, 16)
                    }
                    .padding(.horizontal, 24)
                }
                .background(Color.white)
            }
            .onAppear {
                if UserDefaults.standard.bool(forKey: "isLoggedIn") {
                    isLoggedIn = true
                }
            }
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}



#Preview {
    Onboarding()
}
