import SwiftUI
import Combine

class UserProfileViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var phoneNumber: String = ""
    
    // Notification States
    @Published var orderStatuses: Bool = true
    @Published var passwordChanges: Bool = true
    @Published var specialOffers: Bool = true
    @Published var newsletter: Bool = true
    
    // Avatar States
    @Published var tempAvatarImage: UIImage? = nil
    @Published var savedAvatarImage: UIImage? = nil
    @Published var avatarDeleted: Bool = false
    
    @Published var validationErrorMessage: String? = nil
    
    init() {
        loadUserDefaults()
    }
    
    func loadUserDefaults() {
        firstName = UserDefaults.standard.string(forKey: UserDefaultsKeys.firstName) ?? ""
        lastName = UserDefaults.standard.string(forKey: UserDefaultsKeys.lastName) ?? ""
        email = UserDefaults.standard.string(forKey: UserDefaultsKeys.email) ?? ""
        phoneNumber = UserDefaults.standard.string(forKey: UserDefaultsKeys.phoneNumber) ?? ""
        
        orderStatuses = UserDefaults.standard.object(forKey: UserDefaultsKeys.orderStatuses) == nil ? true : UserDefaults.standard.bool(forKey: UserDefaultsKeys.orderStatuses)
        passwordChanges = UserDefaults.standard.object(forKey: UserDefaultsKeys.passwordChanges) == nil ? true : UserDefaults.standard.bool(forKey: UserDefaultsKeys.passwordChanges)
        specialOffers = UserDefaults.standard.object(forKey: UserDefaultsKeys.specialOffers) == nil ? true : UserDefaults.standard.bool(forKey: UserDefaultsKeys.specialOffers)
        newsletter = UserDefaults.standard.object(forKey: UserDefaultsKeys.newsletter) == nil ? true : UserDefaults.standard.bool(forKey: UserDefaultsKeys.newsletter)
        
        if let path = UserDefaults.standard.string(forKey: UserDefaultsKeys.avatarPath),
           let image = loadImageLocally(path: path) {
            tempAvatarImage = image
            savedAvatarImage = image
        } else {
            tempAvatarImage = nil
            savedAvatarImage = nil
        }
        avatarDeleted = false
        validationErrorMessage = nil
    }
    
    func saveChanges() {
        if firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            validationErrorMessage = "First name is required."
        } else if lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            validationErrorMessage = "Last name is required."
        } else if email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            validationErrorMessage = "Email is required."
        } else if !isValidEmail(email) {
            validationErrorMessage = "Please enter a valid email address."
        } else if !isValidPhoneNumber(phoneNumber) {
            validationErrorMessage = "Please enter a valid phone number (7-15 digits)."
        } else {
            validationErrorMessage = nil
            saveUserDefaults()
        }
    }
    
    private func saveUserDefaults() {
        UserDefaults.standard.set(firstName, forKey: UserDefaultsKeys.firstName)
        UserDefaults.standard.set(lastName, forKey: UserDefaultsKeys.lastName)
        UserDefaults.standard.set(email, forKey: UserDefaultsKeys.email)
        UserDefaults.standard.set(phoneNumber, forKey: UserDefaultsKeys.phoneNumber)
        
        UserDefaults.standard.set(orderStatuses, forKey: UserDefaultsKeys.orderStatuses)
        UserDefaults.standard.set(passwordChanges, forKey: UserDefaultsKeys.passwordChanges)
        UserDefaults.standard.set(specialOffers, forKey: UserDefaultsKeys.specialOffers)
        UserDefaults.standard.set(newsletter, forKey: UserDefaultsKeys.newsletter)
        
        if avatarDeleted {
            if let path = UserDefaults.standard.string(forKey: UserDefaultsKeys.avatarPath) {
                try? FileManager.default.removeItem(atPath: path)
            }
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.avatarPath)
            tempAvatarImage = nil
            savedAvatarImage = nil
        } else if let image = tempAvatarImage {
            if let path = saveImageLocally(image: image) {
                UserDefaults.standard.set(path, forKey: UserDefaultsKeys.avatarPath)
            }
            savedAvatarImage = image
        }
        
        avatarDeleted = false
    }
    
    func logout() {
        UserDefaults.standard.set(false, forKey: UserDefaultsKeys.isLoggedIn)
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
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private func isValidPhoneNumber(_ phone: String) -> Bool {
        if phone.isEmpty { return true }
        let digits = phone.filter { "0123456789".contains($0) }
        return digits.count >= 7 && digits.count <= 15
    }
}
