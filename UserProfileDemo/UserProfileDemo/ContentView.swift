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
    @State private var someInfo = "abc"

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
            let provider = UserDetailsProvider()
            VStack {
                Text(someInfo)
                UserProfileBuilder(userDetailsProvider: provider)
                    .build()
            }
        }
        .task { @MainActor in
            try! await Task.sleep(nanoseconds: 5_000_000_000)
            someInfo = "efgh"
        }
    }
}

#Preview {
    ContentView()
}

struct UserDetailsProvider: UserDetailsProviderProtocol {

    var displayName: String { "name" }
    var username: String { "username" }
    var accountImage: UIImage { .init() }
    var accountRole: String { "admin" }
}
