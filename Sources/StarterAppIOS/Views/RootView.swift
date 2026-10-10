import SwiftUI

/// The single navigation root: gates on auth state, and turns whatever
/// `DeepLinkCoordinator` last resolved (from a push tap in any app state)
/// into a pushed `NavigationStack` path entry - the one place push
/// delivery and in-app navigation meet.
struct RootView: View {
    @EnvironmentObject private var session: AppSession
    @EnvironmentObject private var deepLinkCoordinator: DeepLinkCoordinator
    @State private var path: [AppRoute] = []

    var body: some View {
        Group {
            if session.isRestoringSession {
                LoadingView(message: "Restoring session")
            } else if session.isSignedIn {
                NavigationStack(path: $path) {
                    HomeView()
                        .navigationDestination(for: AppRoute.self) { route in
                            destination(for: route)
                        }
                }
                .safeAreaInset(edge: .bottom) {
                    PushStatusBanner()
                }
            } else {
                LoginView()
            }
        }
        .onChange(of: deepLinkCoordinator.pendingRoute) { _ in
            applyPendingRouteIfNeeded()
        }
        .onChange(of: session.isSignedIn) { _ in
            applyPendingRouteIfNeeded()
        }
    }

    @ViewBuilder
    private func destination(for route: AppRoute) -> some View {
        switch route {
        case .home:
            EmptyView()
        case .item(let id):
            ItemPlaceholderView(id: id)
        }
    }

    /// A push can arrive before the user is signed in (e.g. the app was
    /// killed and cold-launched straight from the notification) - in that
    /// case the route is held by `DeepLinkCoordinator` until `isSignedIn`
    /// flips true, then applied here.
    private func applyPendingRouteIfNeeded() {
        guard session.isSignedIn, let route = deepLinkCoordinator.consumePendingRoute() else { return }
        path = [route]
    }
}
