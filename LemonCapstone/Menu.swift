import SwiftUI
import CoreData

struct Menu: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var searchText: String = ""
    
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
                
                Text("LITTLE LEMON")
                    .font(.system(size: 24, weight: .black, design: .serif))
                    .foregroundColor(Color(red: 0.286, green: 0.369, blue: 0.341)) // #495E57
                    .tracking(1.5)
                Spacer()
                Image("profile-image-placeholder")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
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
                
                // Search button
                Button(action: {
                    // Action for search
                }) {
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                        .foregroundColor(.black)
                        .padding(12)
                        .background(Color.white.opacity(0.9))
                        .clipShape(Circle())
                }
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
                        CategoryButton(title: "Starters")
                        CategoryButton(title: "Mains")
                        CategoryButton(title: "Desserts")
                        CategoryButton(title: "Drinks")
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical, 8)
            
            Divider()
                .padding(.horizontal)
            
            TextField("Search menu", text: $searchText)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
                .padding(.bottom, 8)
            
            // List of objects
            FetchedObjects(predicate: buildPredicate(), sortDescriptors: buildSortDescriptors()) { (dishes: [Dish]) in
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
                            
                            if let imageUrlString = dish.image, let url = URL(string: imageUrlString) {
                                AsyncImage(url: url) { image in
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
            getMenuData()
        }
    }
    
    func buildSortDescriptors() -> [NSSortDescriptor] {
        return [
            NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.localizedStandardCompare))
        ]
    }
    
    func buildPredicate() -> NSPredicate {
        if searchText.isEmpty {
            return NSPredicate(value: true)
        } else {
            return NSPredicate(format: "title CONTAINS[cd] %@", searchText)
        }
    }
    
    func getMenuData() {
        PersistenceController.shared.clear()
        
        let serverURLString = "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json"
        let url = URL(string: serverURLString)!
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                DispatchQueue.main.async {
                    if let menuList = try? decoder.decode(MenuList.self, from: data) {
                        for item in menuList.menu {
                            let dish = Dish(context: viewContext)
                            dish.title = item.title
                            dish.image = item.image
                            dish.price = item.price
                            dish.dishDescription = item.description
                            dish.category = item.category
                        }
                        try? viewContext.save()
                    }
                }
            }
        }
        task.resume()
    }
}

struct CategoryButton: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.system(size: 15, weight: .bold))
            .foregroundColor(Color(red: 0.286, green: 0.369, blue: 0.341))
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color(red: 0.929, green: 0.937, blue: 0.933)) // #EDEFEE
            .cornerRadius(16)
    }
}

#Preview {
    Menu()
}
