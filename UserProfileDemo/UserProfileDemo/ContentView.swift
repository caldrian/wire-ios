//
//  ContentView.swift
//  UserProfileDemo
//
//  Created by Christoph Aldrian on 29.10.24.
//

import SwiftUI
import WireUserProfileUI

struct ContentView: View {

    @State private var isUserProfilePresented = false
    @StateObject private var userDetailsModel = UserDetailsModel()

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")

            Button("Open Profile") {
                isUserProfilePresented.toggle()
            }.padding()
        }
        .padding()
        .sheet(isPresented: $isUserProfilePresented) {
            let userDetailsView = UserProfileBuilder<UserProfileAction>()
                .build(
                    userDetailsModel: userDetailsModel,
                    availableActions: [.createGroup],
                    triggeredAction: { id in
                        print("triggered action: \(id)")
                    }
                )
            userDetailsView
                .task { @MainActor in
                    try! await Task.sleep(nanoseconds: 2_000_000_000)
                    userDetailsModel.username = "efgh"
                }
        }
    }
}

#Preview {
    ContentView()
}

enum UserProfileAction: Int, UserDetailsAction {
    case createGroup

    var id: Int {
        switch self {
        case .createGroup:
            rawValue
        }
    }

    var title: String {
        switch self {
        case .createGroup:
            "Create Group"
        }
    }
}
