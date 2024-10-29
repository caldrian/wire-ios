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
            UserProfileBuilder()
                .build(userDetailsModel: userDetailsModel)
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
