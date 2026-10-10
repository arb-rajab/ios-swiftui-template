import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var session: AppSession
    @State private var email = ""
    @State private var password = ""
    @State private var isSubmitting = false
    @State private var showRegister = false

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Email", text: $email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                    SecureField("Password", text: $password)
                        .textContentType(.password)
                }

                if let message = session.lastErrorMessage {
                    Section {
                        Text(message).foregroundStyle(.red)
                    }
                }

                Section {
                    Button(isSubmitting ? "Signing in..." : "Sign In") {
                        Task {
                            isSubmitting = true
                            await session.login(email: email, password: password)
                            isSubmitting = false
                        }
                    }
                    .buttonStyle(.primary)
                    .disabled(isSubmitting || email.isEmpty || password.isEmpty)
                }
                .listRowBackground(Color.clear)
            }
            .navigationTitle("Starter App")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Create Account") { showRegister = true }
                }
            }
            .sheet(isPresented: $showRegister) {
                RegisterView()
            }
        }
    }
}

#Preview {
    LoginView().environmentObject(AppSession())
}
