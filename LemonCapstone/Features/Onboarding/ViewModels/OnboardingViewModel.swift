import Foundation
import Combine

class OnboardingViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    
    @Published var isLoggedIn = false
    @Published var showValidationError = false
    @Published var validationErrorMessage = ""
    
    init() {
        if UserDefaults.standard.bool(forKey: UserDefaultsKeys.isLoggedIn) {
            isLoggedIn = true
        }
    }
    
    func register() {
        if !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty && isValidEmail(email) {
            showValidationError = false
            UserDefaults.standard.set(firstName, forKey: UserDefaultsKeys.firstName)
            UserDefaults.standard.set(lastName, forKey: UserDefaultsKeys.lastName)
            UserDefaults.standard.set(email, forKey: UserDefaultsKeys.email)
            UserDefaults.standard.set(true, forKey: UserDefaultsKeys.legacyIsLoggedIn)
            UserDefaults.standard.set(true, forKey: UserDefaultsKeys.isLoggedIn)
            isLoggedIn = true
        } else {
            if firstName.isEmpty || lastName.isEmpty || email.isEmpty {
                validationErrorMessage = "All fields are required."
            } else {
                validationErrorMessage = "Please enter a valid email address."
            }
            showValidationError = true
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
