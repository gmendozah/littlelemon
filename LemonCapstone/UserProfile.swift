import SwiftUI

let kPhoneNumber = "phone_number_key"
let kOrderStatuses = "order_statuses_key"
let kPasswordChanges = "password_changes_key"
let kSpecialOffers = "special_offers_key"
let kNewsletter = "newsletter_key"
let kAvatarPath = "avatar_path_key"

struct UserProfile: View {
    @Environment(\.presentationMode) var presentation
    @Binding var selectedTab: Int
    
    // Form input States
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    
    // Notification States
    @State private var orderStatuses: Bool = true
    @State private var passwordChanges: Bool = true
    @State private var specialOffers: Bool = true
    @State private var newsletter: Bool = true
    
    // Avatar States
    @State private var tempAvatarImage: UIImage? = nil
    @State private var savedAvatarImage: UIImage? = nil
    @State private var avatarDeleted: Bool = false
    
    // Image Picker States
    @State private var showImagePicker = false
    @State private var pickerSourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var showPhotoSourceOptions = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: {
                    selectedTab = 0 // Navigate back to Menu
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .bold))
                        .padding(10)
                        .background(Color(red: 0.286, green: 0.369, blue: 0.341)) // #495E57 (Primary Green)
                        .clipShape(Circle())
                }
                
                Spacer()
                
                // Little Lemon Logo
                Image("little-lemon-logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 40)
                    .padding(.vertical, 12)
                
                Spacer()
                
                // Small Profile Avatar (Header Right)
                if let headerImg = savedAvatarImage {
                    Image(uiImage: headerImg)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 44, height: 44)
                        .clipShape(Circle())
                } else {
                    Image("profile-image-placeholder")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 44, height: 44)
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
            .background(Color.white)
            
            Divider()
            
            // Scrollable Content Form
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Personal information")
                        .font(.title2.bold())
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                    
                    // Avatar Editing Row
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Avatar")
                            .font(.caption)
                            .bold()
                            .foregroundColor(.gray)
                        
                        HStack(spacing: 20) {
                            if let avatarImg = tempAvatarImage {
                                Image(uiImage: avatarImg)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                            } else {
                                Image("profile-image-placeholder")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                            }
                            
                            Button(action: {
                                showPhotoSourceOptions = true
                            }) {
                                Text("Change")
                                    .font(.subheadline.bold())
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                    .background(Color(red: 0.286, green: 0.369, blue: 0.341)) // #495E57
                                    .cornerRadius(8)
                            }
                            
                            Button(action: {
                                tempAvatarImage = nil
                                avatarDeleted = true
                            }) {
                                Text("Remove")
                                    .font(.subheadline.bold())
                                    .foregroundColor(Color(red: 0.286, green: 0.369, blue: 0.341)) // #495E57
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color(red: 0.286, green: 0.369, blue: 0.341), lineWidth: 1)
                                    )
                            }
                        }
                    }
                    .padding(.vertical, 8)
                    
                    // Input Text Fields
                    VStack(spacing: 16) {
                        CustomTextField(label: "First name", value: $firstName)
                        CustomTextField(label: "Last name", value: $lastName)
                        CustomTextField(label: "Email", value: $email, keyboardType: .emailAddress)
                        CustomTextField(label: "Phone number", value: $phoneNumber, keyboardType: .phonePad)
                    }
                    
                    // Email Notifications Section
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Email notifications")
                            .font(.headline)
                            .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                            .padding(.top, 10)
                        
                        ToggleItem(isChecked: $orderStatuses, label: "Order statuses")
                        ToggleItem(isChecked: $passwordChanges, label: "Password changes")
                        ToggleItem(isChecked: $specialOffers, label: "Special offers")
                        ToggleItem(isChecked: $newsletter, label: "Newsletter")
                    }
                    
                    // Log out Button
                    Button(action: {
                        // Perform Logout
                        UserDefaults.standard.set(false, forKey: kIsLoggedIn)
                        self.presentation.wrappedValue.dismiss()
                    }) {
                        Text("Log out")
                            .font(.headline.bold())
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 0.957, green: 0.808, blue: 0.078)) // #F4CE14
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(red: 0.843, green: 0.694, blue: 0.086), lineWidth: 1)
                            )
                    }
                    .padding(.top, 24)
                    
                    // Discard & Save changes buttons
                    HStack(spacing: 20) {
                        Button(action: {
                            loadUserDefaults()
                        }) {
                            Text("Discard changes")
                                .font(.subheadline.bold())
                                .foregroundColor(Color(red: 0.286, green: 0.369, blue: 0.341)) // #495E57
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color(red: 0.286, green: 0.369, blue: 0.341), lineWidth: 1)
                                )
                        }
                        
                        Button(action: {
                            saveUserDefaults()
                        }) {
                            Text("Save changes")
                                .font(.subheadline.bold())
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(red: 0.286, green: 0.369, blue: 0.341)) // #495E57
                                .cornerRadius(8)
                        }
                    }
                    .padding(.bottom, 20)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
            }
        }
        .background(Color.white.ignoresSafeArea())
        .onAppear {
            loadUserDefaults()
        }
        .confirmationDialog("Select Avatar", isPresented: $showPhotoSourceOptions, titleVisibility: .visible) {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                Button("Camera") {
                    pickerSourceType = .camera
                    showImagePicker = true
                }
            }
            Button("Photo Library") {
                pickerSourceType = .photoLibrary
                showImagePicker = true
            }
            Button("Cancel", role: .cancel) {}
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $tempAvatarImage, sourceType: pickerSourceType)
        }
    }
    
    // MARK: - Persistence Logic
    
    private func loadUserDefaults() {
        firstName = UserDefaults.standard.string(forKey: kFirstName) ?? ""
        lastName = UserDefaults.standard.string(forKey: kLastName) ?? ""
        email = UserDefaults.standard.string(forKey: kEmail) ?? ""
        phoneNumber = UserDefaults.standard.string(forKey: kPhoneNumber) ?? ""
        
        orderStatuses = UserDefaults.standard.object(forKey: kOrderStatuses) == nil ? true : UserDefaults.standard.bool(forKey: kOrderStatuses)
        passwordChanges = UserDefaults.standard.object(forKey: kPasswordChanges) == nil ? true : UserDefaults.standard.bool(forKey: kPasswordChanges)
        specialOffers = UserDefaults.standard.object(forKey: kSpecialOffers) == nil ? true : UserDefaults.standard.bool(forKey: kSpecialOffers)
        newsletter = UserDefaults.standard.object(forKey: kNewsletter) == nil ? true : UserDefaults.standard.bool(forKey: kNewsletter)
        
        if let path = UserDefaults.standard.string(forKey: kAvatarPath),
           let image = loadImageLocally(path: path) {
            tempAvatarImage = image
            savedAvatarImage = image
        } else {
            tempAvatarImage = nil
            savedAvatarImage = nil
        }
        avatarDeleted = false
    }
    
    private func saveUserDefaults() {
        UserDefaults.standard.set(firstName, forKey: kFirstName)
        UserDefaults.standard.set(lastName, forKey: kLastName)
        UserDefaults.standard.set(email, forKey: kEmail)
        UserDefaults.standard.set(phoneNumber, forKey: kPhoneNumber)
        
        UserDefaults.standard.set(orderStatuses, forKey: kOrderStatuses)
        UserDefaults.standard.set(passwordChanges, forKey: kPasswordChanges)
        UserDefaults.standard.set(specialOffers, forKey: kSpecialOffers)
        UserDefaults.standard.set(newsletter, forKey: kNewsletter)
        
        if avatarDeleted {
            if let path = UserDefaults.standard.string(forKey: kAvatarPath) {
                try? FileManager.default.removeItem(atPath: path)
            }
            UserDefaults.standard.removeObject(forKey: kAvatarPath)
            tempAvatarImage = nil
            savedAvatarImage = nil
        } else if let image = tempAvatarImage {
            if let path = saveImageLocally(image: image) {
                UserDefaults.standard.set(path, forKey: kAvatarPath)
            }
            savedAvatarImage = image
        }
        
        avatarDeleted = false
    }
    
    private func saveImageLocally(image: UIImage) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let filename = paths[0].appendingPathComponent("profile_avatar.jpg")
        do {
            try data.write(to: filename)
            return filename.path
        } catch {
            print("Failed to save image locally: \(error)")
            return nil
        }
    }
    
    private func loadImageLocally(path: String) -> UIImage? {
        return UIImage(contentsOfFile: path)
    }
}

// MARK: - Custom Views

struct CustomTextField: View {
    let label: String
    @Binding var value: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.caption)
                .bold()
                .foregroundColor(.gray)
            
            TextField(label, text: $value)
                .keyboardType(keyboardType)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding(10)
                .background(Color.white)
                .cornerRadius(6)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
        }
    }
}

struct ToggleItem: View {
    @Binding var isChecked: Bool
    let label: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                .foregroundColor(isChecked ? Color(red: 0.286, green: 0.369, blue: 0.341) : .gray) // #495E57
                .font(.system(size: 22))
            Text(label)
                .font(.body)
                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
        }
        .contentShape(Rectangle())
        .onTapGesture {
            isChecked.toggle()
        }
    }
}

// MARK: - Image Picker Wrapper

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

// MARK: - Previews

#Preview {
    UserProfile(selectedTab: .constant(1))
}
