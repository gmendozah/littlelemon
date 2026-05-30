import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                NavigationLink(destination: HomeView(), isActive: $viewModel.isLoggedIn) {
                    EmptyView()
                }
                
                Image("little-lemon-logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 40)
                    .padding(.vertical, 12)
                
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
                            TextField("First Name", text: $viewModel.firstName)
                                .textFieldStyle(.roundedBorder)
                                .textInputAutocapitalization(.words)
                                .disableAutocorrection(true)
                        }
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Last Name *")
                                .font(.caption.bold())
                                .foregroundColor(.gray)
                            TextField("Last Name", text: $viewModel.lastName)
                                .textFieldStyle(.roundedBorder)
                                .textInputAutocapitalization(.words)
                                .disableAutocorrection(true)
                        }
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Email *")
                                .font(.caption.bold())
                                .foregroundColor(.gray)
                            TextField("Email", text: $viewModel.email)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .disableAutocorrection(true)
                        }
                        
                        if viewModel.showValidationError {
                            Text(viewModel.validationErrorMessage)
                                .foregroundColor(.red)
                                .font(.caption)
                                .bold()
                        }
                        
                        // Button
                        Button(action: {
                            viewModel.register()
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
        }
    }
}

#Preview {
    OnboardingView()
}
