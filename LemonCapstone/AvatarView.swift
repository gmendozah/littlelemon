import SwiftUI

struct AvatarView: View {
    let image: UIImage?
    let size: CGFloat
    
    var body: some View {
        if let image = image {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size, height: size)
                .clipShape(Circle())
        } else {
            Image("profile-image-placeholder")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size, height: size)
                .clipShape(Circle())
        }
    }
}

#Preview {
    AvatarView(image: nil, size: 80)
}
