import SwiftUI
import CoreData

struct MenuView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel = MenuViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            // Header (Logo & Avatar)
            HStack {
                Spacer()
                Image(systemName: "lemon.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 32, height: 32)
                    .foregroundColor(Color(red: 0.957, green: 0.808, blue: 0.078)) // #F4CE14
                Image("little-lemon-logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 40)
                    .padding(.vertical, 12)
                Spacer()
                AvatarView(image: viewModel.avatarImage, size: 44)
                    .padding(.trailing, 16)
            }
            .padding(.vertical, 8)
            
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
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search menu", text: $viewModel.searchText)
                        .textFieldStyle(.plain)
                        .foregroundColor(.black)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                    
                    if !viewModel.searchText.isEmpty {
                        Button(action: {
                            viewModel.searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(10)
                .background(Color.white)
                .cornerRadius(8)
                .padding(.top, 8)
            }
            .padding(20)
            .background(Color(red: 0.286, green: 0.369, blue: 0.341)) // #495E57
            
            // Order for delivery
            VStack(alignment: .leading, spacing: 8) {
                Text("ORDER FOR DELIVERY!")
                    .font(.system(size: 18, weight: .black))
                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2)) // #333333
                    .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        CategoryButton(title: "Starters", isSelected: viewModel.selectedCategory == "Starters") {
                            viewModel.toggleCategory("Starters")
                        }
                        CategoryButton(title: "Mains", isSelected: viewModel.selectedCategory == "Mains") {
                            viewModel.toggleCategory("Mains")
                        }
                        CategoryButton(title: "Desserts", isSelected: viewModel.selectedCategory == "Desserts") {
                            viewModel.toggleCategory("Desserts")
                        }
                        CategoryButton(title: "Drinks", isSelected: viewModel.selectedCategory == "Drinks") {
                            viewModel.toggleCategory("Drinks")
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical, 8)
            
            Divider()
                .padding(.horizontal)
            
            // List of objects
            FetchedObjects(predicate: viewModel.buildPredicate(), sortDescriptors: viewModel.buildSortDescriptors()) { (dishes: [Dish]) in
                List {
                    ForEach(dishes) { dish in
                        HStack {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("\(dish.title ?? "") - $\(dish.price ?? "")")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                
                                if let description = dish.dishDescription {
                                    Text(description)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .lineLimit(2)
                                }
                            }
                            
                            Spacer()
                            
                            if let title = dish.title, (title.lowercased() == "lemon desert" || title.lowercased() == "lemon dessert") {
                                Image("lemon-dessert")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(8)
                                    .clipped()
                            } else if let title = dish.title, title.lowercased() == "grilled fish" {
                                Image("grilled-fish")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(8)
                                    .clipped()
                            } else if let imageUrlString = dish.image, let url = URL(string: imageUrlString) {
                                CachedAsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 80, height: 80)
                                        .cornerRadius(8)
                                        .clipped()
                                } placeholder: {
                                    ProgressView()
                                        .frame(width: 80, height: 80)
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                .listStyle(.plain)
            }
        }
        .onAppear {
            viewModel.getMenuData(viewContext: viewContext)
            viewModel.loadAvatar()
        }
    }
}

#Preview {
    MenuView()
}
