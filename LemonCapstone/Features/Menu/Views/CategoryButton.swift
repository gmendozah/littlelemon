import SwiftUI

struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(isSelected ? .white : Color(red: 0.286, green: 0.369, blue: 0.341))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color(red: 0.286, green: 0.369, blue: 0.341) : Color(red: 0.929, green: 0.937, blue: 0.933))
                .cornerRadius(16)
        }
    }
}
