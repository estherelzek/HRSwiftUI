import SwiftUI

import SwiftUI

struct MainTabView: View {
    init() {
        UITabBar.appearance().unselectedItemTintColor = .darkGray
    }

    var body: some View {
        TabView {
            NavigationStack {
                ContentView()
            }
            .tabItem {
                Image(systemName: "clock.badge.checkmark")
                Text("Attendance")
            }

            NavigationStack {
                TimeOffView()
            }
            .tabItem {
                Image(systemName: "calendar")
                Text("Time Off")
            }

            NavigationStack {
                NotificationView()
            }
            .tabItem {
                Image(systemName: "bell")
                Text("Notifications")
            }

            NavigationStack {
                MoreView()
            }
            .tabItem {
                Image(systemName: "ellipsis.circle")
                Text("More")
            }
        }
        .tint(.border)
    }
}


#Preview {
    MainTabView()
}
