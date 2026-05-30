import SwiftUI
import CoreData

struct HomeView: View {
    let persistence = PersistenceController.shared
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            MenuView()
                .environment(\.managedObjectContext, persistence.container.viewContext)
                .tabItem {
                    Label("Menu", systemImage: "list.dash")
                }
                .tag(0)
            
            UserProfileView(selectedTab: $selectedTab)
                .tabItem {
                    Label("Profile", systemImage: "square.and.pencil")
                }
                .tag(1)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    HomeView()
}
