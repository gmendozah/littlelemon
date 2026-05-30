import SwiftUI

struct UserProfileView: View {
    @Environment(\.presentationMode) var presentation
    @Binding var selectedTab: Int
    @StateObject private var viewModel = UserProfileViewModel()
    
    // Image Picker UI state (view-only states)
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
                        .background(Color(red: 0.286, green: 0.369, blue: 0.341)) // #495E57
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
                AvatarView(image: viewModel.savedAvatarImage, size: 44)
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
                            AvatarView(image: viewModel.tempAvatarImage, size: 80)
                            
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
                                viewModel.tempAvatarImage = nil
                                viewModel.avatarDeleted = true
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
                        CustomTextField(label: "First name", value: $viewModel.firstName)
                        CustomTextField(label: "Last name", value: $viewModel.lastName)
                        CustomTextField(label: "Email", value: $viewModel.email, keyboardType: .emailAddress)
                        CustomTextField(label: "Phone number", value: $viewModel.phoneNumber, keyboardType: .phonePad)
                    }
                    
                    // Email Notifications Section
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Email notifications")
                            .font(.headline)
                            .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                            .padding(.top, 10)
                        
                        ToggleItem(isChecked: $viewModel.orderStatuses, label: "Order statuses")
                        ToggleItem(isChecked: $viewModel.passwordChanges, label: "Password changes")
                        ToggleItem(isChecked: $viewModel.specialOffers, label: "Special offers")
                        ToggleItem(isChecked: $viewModel.newsletter, label: "Newsletter")
                    }
                    
                    // Log out Button
                    Button(action: {
                        // Perform Logout
                        viewModel.logout()
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
                    
                    if let errorMessage = viewModel.validationErrorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption.bold())
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 8)
                    }
                    
                    // Discard & Save changes buttons
                    HStack(spacing: 20) {
                        Button(action: {
                            viewModel.loadUserDefaults()
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
                            viewModel.saveChanges()
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
            viewModel.loadUserDefaults()
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
            ImagePicker(image: $viewModel.tempAvatarImage, sourceType: pickerSourceType)
        }
        .onChange(of: viewModel.phoneNumber) { newValue in
            let filtered = newValue.filter { "0123456789 -()+".contains($0) }
            if filtered != newValue {
                viewModel.phoneNumber = filtered
            }
        }
    }
}

#Preview {
    UserProfileView(selectedTab: .constant(1))
}
