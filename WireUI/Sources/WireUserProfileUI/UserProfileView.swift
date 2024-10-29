//
// Wire
// Copyright (C) 2024 Wire Swiss GmbH
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see http://www.gnu.org/licenses/.
//

import SwiftUI

public struct UserProfileBuilder<Action: UserDetailsAction> {

    public init() {}

    @MainActor @ViewBuilder
    public func build(
        userDetailsModel: UserDetailsModel,
        availableActions: [Action],
        triggeredAction: @escaping (Action.ID) -> Void
    ) -> some View {
        UserProfileView(
            userDetailsModel: userDetailsModel,
            availableActions: availableActions,
            triggeredAction: triggeredAction
        )
    }
}

struct UserProfileView<Action: UserDetailsAction>: View {

    @State private var selectedOption = 0

    @ObservedObject var userDetailsModel: UserDetailsModel
    var availableActions: [Action] = []
    var triggeredAction: (Action.ID) -> Void

    var body: some View {
        VStack {
            
            Picker("Options", selection: $selectedOption) {
                Text("Details")
                    .tag(0)
                Text("Devices")
                    .tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())

            switch selectedOption {
            case 0:
                UserDetailsView(model: userDetailsModel)
                    .padding()
            case 1:
                UserDevicesView()
                    .padding()
            default:
                EmptyView()
            }
            Spacer()

            if !availableActions.isEmpty {
                HStack {
                    ForEach(availableActions, id: \.self) { action in
                        Button(action.title) {
                            triggeredAction(action.id)
                        }
                    }
                }
            }
        }
        .padding()
    }
}

struct UserDetailsView: View {

    @ObservedObject var model: UserDetailsModel

    var body: some View {
        VStack {
            Text(model.displayName)
            Text(model.username)
            Image(uiImage: model.accountImage ?? .init())
        }
    }
}

public final class UserDetailsModel: ObservableObject {

    @Published /*private(set)*/ public var displayName = "John Doe"
    @Published /*private(set)*/ public var username = "@john_doe"
    @Published /*private(set)*/ public var accountImage = UIImage(systemName: "gearshape")
    @Published /*private(set)*/ public var accountRole = "admin"

    public init() {}

    public init(
        displayName: String,
        username: String,
        accountImage: UIImage?,
        accountRole: String
    ) {
        self.displayName = displayName
        self.username = username
        self.accountImage = accountImage
        self.accountRole = accountRole
    }
}

public protocol UserDetailsAction: Hashable, Identifiable {
    var id: Int { get }
    var title: String { get }
}

struct UserDevicesView: View {
    var body: some View {
        Text("Hello World")
    }
}

//#Preview {
//    let userDetailsModel = UserDetailsModel()
//    UserProfileView(userDetailsModel: userDetailsModel)
//}
