import SwiftUI
import CoreData

struct Home: View {
    let persistence = PersistenceController.shared
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Menu()
                .environment(\.managedObjectContext, persistence.container.viewContext)
                .tabItem {
                    Label("Menu", systemImage: "list.dash")
                }
                .tag(0)
            
            UserProfile(selectedTab: $selectedTab)
                .tabItem {
                    Label("Profile", systemImage: "square.and.pencil")
                }
                .tag(1)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    Home()
}
