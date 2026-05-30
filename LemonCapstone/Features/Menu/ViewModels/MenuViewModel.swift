import Foundation
import CoreData
import SwiftUI
import Combine

class MenuViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var selectedCategory: String = ""
    @Published var avatarImage: UIImage? = nil
    
    func loadAvatar() {
        if let path = UserDefaults.standard.string(forKey: UserDefaultsKeys.avatarPath),
           let image = UIImage(contentsOfFile: path) {
            avatarImage = image
        } else {
            avatarImage = nil
        }
    }
    
    func toggleCategory(_ category: String) {
        if selectedCategory == category {
            selectedCategory = ""
        } else {
            selectedCategory = category
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
    
    func getMenuData(viewContext: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<Dish> = Dish.fetchRequest()
        if let count = try? viewContext.count(for: fetchRequest), count > 0 {
            return
        }
        
        PersistenceController.shared.clear()
        viewContext.reset()
        
        let serverURLString = "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json"
        guard let url = URL(string: serverURLString) else { return }
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
