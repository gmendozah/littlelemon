import SwiftUI

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
