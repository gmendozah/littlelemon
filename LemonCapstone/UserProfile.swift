import SwiftUI

struct UserProfile: View {
    @Environment(\.presentationMode) var presentation
    
    let firstName = UserDefaults.standard.string(forKey: kFirstName) ?? ""
    let lastName = UserDefaults.standard.string(forKey: kLastName) ?? ""
    let email = UserDefaults.standard.string(forKey: kEmail) ?? ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Personal information")
                .font(.system(size: 26, weight: .bold, design: .serif))
                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2)) // #333333
                .padding(.top, 24)
            
            Image("profile-image-placeholder")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120, height: 120)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color(red: 0.286, green: 0.369, blue: 0.341), lineWidth: 2)) // #495E57
                .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
                .padding(.bottom, 10)
            
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("First Name")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                    Text(firstName)
                        .font(.body)
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                    Divider()
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Last Name")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                    Text(lastName)
                        .font(.body)
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                    Divider()
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Email")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                    Text(email)
                        .font(.body)
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                }
            }
            .padding(20)
            .background(Color(red: 0.929, green: 0.937, blue: 0.933).opacity(0.4)) // Light Tint
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(red: 0.929, green: 0.937, blue: 0.933), lineWidth: 1)
            )
            .padding(.horizontal, 24)
            
            Button(action: {
                UserDefaults.standard.set(false, forKey: kIsLoggedIn)
                self.presentation.wrappedValue.dismiss()
            }) {
                Text("Logout")
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 0.957, green: 0.808, blue: 0.078)) // #F4CE14
                    .cornerRadius(8)
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            
            Spacer()
        }
        .background(Color.white.ignoresSafeArea())
    }
}

#Preview {
    UserProfile()
}
