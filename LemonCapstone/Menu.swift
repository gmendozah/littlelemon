import SwiftUI
import CoreData

struct Menu: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var searchText: String = ""
    @State var selectedCategory: String = ""
    @State private var avatarImage: UIImage? = nil
    
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
                if let avatar = avatarImage {
                    Image(uiImage: avatar)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 44, height: 44)
                        .clipShape(Circle())
                        .padding(.trailing, 16)
                } else {
                    Image("profile-image-placeholder")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 44, height: 44)
                        .clipShape(Circle())
                        .padding(.trailing, 16)
                }
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
                    TextField("Search menu", text: $searchText)
                        .textFieldStyle(.plain)
                        .foregroundColor(.black)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
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
                        CategoryButton(title: "Starters", isSelected: selectedCategory == "Starters") {
                            toggleCategory("Starters")
                        }
                        CategoryButton(title: "Mains", isSelected: selectedCategory == "Mains") {
                            toggleCategory("Mains")
                        }
                        CategoryButton(title: "Desserts", isSelected: selectedCategory == "Desserts") {
                            toggleCategory("Desserts")
                        }
                        CategoryButton(title: "Drinks", isSelected: selectedCategory == "Drinks") {
                            toggleCategory("Drinks")
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical, 8)
            
            Divider()
                .padding(.horizontal)
            
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
            getMenuData()
            loadAvatar()
        }
    }
    
    private func loadAvatar() {
        if let path = UserDefaults.standard.string(forKey: kAvatarPath),
           let image = UIImage(contentsOfFile: path) {
            avatarImage = image
        } else {
            avatarImage = nil
        }
    }
    
    func buildSortDescriptors() -> [NSSortDescriptor] {
        return [
            NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.localizedStandardCompare))
        ]
    }
    
    func buildPredicate() -> NSPredicate {
        if searchText.isEmpty && selectedCategory.isEmpty {
            return NSPredicate(value: true)
        } else if !searchText.isEmpty && selectedCategory.isEmpty {
            return NSPredicate(format: "title CONTAINS[cd] %@", searchText)
        } else if searchText.isEmpty && !selectedCategory.isEmpty {
            return NSPredicate(format: "category == %@", selectedCategory.lowercased())
        } else {
            return NSPredicate(format: "title CONTAINS[cd] %@ AND category == %@", searchText, selectedCategory.lowercased())
        }
    }
    
    private func toggleCategory(_ category: String) {
        if selectedCategory == category {
            selectedCategory = ""
        } else {
            selectedCategory = category
        }
    }
    
    func getMenuData() {
        let fetchRequest: NSFetchRequest<Dish> = Dish.fetchRequest()
        if let count = try? viewContext.count(for: fetchRequest), count > 0 {
            return
        }
        
        PersistenceController.shared.clear()
        viewContext.reset()
        
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

class ImageCache {
    static let shared = ImageCache()
    private var cache = NSCache<NSURL, UIImage>()
    
    func get(for url: URL) -> UIImage? {
        return cache.object(forKey: url as NSURL)
    }
    
    func set(_ image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url as NSURL)
    }
}

struct CachedAsyncImage<Content: View, Placeholder: View>: View {
    let url: URL
    let content: (Image) -> Content
    let placeholder: () -> Placeholder
    
    @State private var image: UIImage? = nil
    @State private var isLoading = false
    
    var body: some View {
        Group {
            if let image = image {
                content(Image(uiImage: image))
            } else {
                placeholder()
                    .onAppear {
                        loadImage()
                    }
            }
        }
    }
    
    private func loadImage() {
        if let cachedImage = ImageCache.shared.get(for: url) {
            self.image = cachedImage
            return
        }
        
        guard !isLoading else { return }
        isLoading = true
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            isLoading = false
            guard let data = data, let downloadedImage = UIImage(data: data) else { return }
            
            ImageCache.shared.set(downloadedImage, for: url)
            
            DispatchQueue.main.async {
                self.image = downloadedImage
            }
        }.resume()
    }
}

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

#Preview {
    Menu()
}
