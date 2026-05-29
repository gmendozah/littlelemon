import SwiftUI

struct Menu: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Little Lemon")
                .font(.system(size: 40, weight: .bold, design: .serif))
                .foregroundColor(Color(red: 0.286, green: 0.369, blue: 0.341)) // Primary Green #495E57
            
            Text("Chicago")
                .font(.system(size: 24, weight: .semibold, design: .serif))
                .foregroundColor(Color(red: 0.957, green: 0.808, blue: 0.078)) // Primary Yellow #F4CE14
            
            Text("We are a family owned Mediterranean restaurant, focused on traditional recipes served with a modern twist.")
                .font(.system(size: 16))
                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2)) // Charcoal/Dark Neutral #333333
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            List {
                // Empty List for now, to be populated later
            }
        }
        .padding(.top)
    }
}

#Preview {
    Menu()
}
