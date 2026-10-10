import SwiftUI

/// Placeholder signed-in screen. Replace with your app's home.
struct HomeView: View {
    @EnvironmentObject private var session: AppSession

    var body: some View {
        List {
            if let user = session.currentUser {
                Section("Signed in as") {
                    Text(user.displayName)
                    Text(user.email).foregroundStyle(.secondary)
                }
            } else {
                Section {
                    EmptyStateView(
                        title: "No profile loaded",
                        message: "Your account details will appear here.",
                        systemImage: "person.crop.circle"
                    )
                }
            }
            Section {
                Button("Sign Out", role: .destructive) {
                    session.signOut()
                }
            }
        }
        .navigationTitle("Home")
    }
}

/// Placeholder destination for an `AppRoute.item` deep link.
struct ItemPlaceholderView: View {
    let id: String

    var body: some View {
        Text("Item \(id)")
            .navigationTitle("Item")
    }
}
