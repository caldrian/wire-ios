//
// Wire
// Copyright (C) 2025 Wire Swiss GmbH
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
import WireDesign
import WireFoundation
import WireReusableUIComponents

public struct CloudLoginWithoutSSOView: View {
    let email: String

    @State var password: String

    public var body: some View {
        LabeledTextField(
            placeholder: nil,
            title: "Email",
            string: .constant(email)
        )
        .disabled(true)
        LabeledTextField(
            placeholder: "Password",
            title: "Password",
            string: $password
        )
        Button(action: {
            // Login
        }, label: {
            Text("Next")
        })
        .wireButtonStyle(.primary)
        .disabled(password.count < 4)

        Button(action: {
            // Forgot password
        }, label: {
            Text("Forgot password?")
        })
//        .wireButtonStyle(.link)

        Group {
            Text("Don't have a Wire account?")
            Button(action: {
                // Create account
            }, label: {
                Text("Create Personal Account")
            })
//            .wireButtonStyle(.link)
        }
        .padding(.top, 8)
        .padding(.bottom, 8)
        .background() {
            if #available(iOS 17.0, *) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(ColorTheme.Backgrounds.backgroundVariant.color)
                    .stroke(ColorTheme.Strokes.outline.color, lineWidth: 1)
            } else {
                ZStack() {
                    Rectangle()
                        .fill(ColorTheme.Backgrounds.backgroundVariant.color)
                        .cornerRadius(4)
                    Rectangle()
                        .border(ColorTheme.Strokes.outline.color, width: 1)
                }
            }
        }
        .navigationTitle("Enter your password to log in")
    }
}

#Preview {
    CloudLoginWithoutSSOView(email: "example@wire.com", password: "")
}
