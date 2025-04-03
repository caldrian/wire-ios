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

import Foundation
import WireAuthenticationAPI

package struct LoginViaEmailInteractor: LoginViaEmailInteractorProtocol {

    private let networkStack: NetworkStack
    private let bridge: WireAuthenticationBridge

    package init(
        networkStack: NetworkStack,
        bridge: WireAuthenticationBridge
    ) {
        self.networkStack = networkStack
        self.bridge = bridge
    }

    package func isEmailVaild(
        _ email: String
    ) -> Bool {
        ValidateEmailUseCase().invoke(email: email) == .isValid
    }

    package func submitProxyCredentials(
        _ proxyCredentials: ProxyCredentials
    ) throws {
        try SubmitProxyCredentialsUseCase(
            networkStack: networkStack
        )
        .invoke(
            proxyCredentials: proxyCredentials
        )
    }

    package func login(
        email: String,
        password: String
    ) async throws -> AuthenticationResult {
        try await Task.detached {
            let api = try await networkStack.makeAuthenticationAPI()
            let useCase = LoginViaEmailUseCase(authenticationAPI: api)
            let (cookies, accessToken) = try await useCase.invoke(
                email: email,
                password: password,
                verificationCode: nil
            )
            let emailCredentials = EmailCredentials(
                email: email,
                password: password,
                verificationCode: nil
            )
            let backendEnvironment = try await networkStack.makeBackendEnvironment()
            return AuthenticationResult(
                userID: accessToken.userID,
                cookies: cookies,
                accessToken: accessToken,
                emailCredentials: emailCredentials,
                backendEnvironment: backendEnvironment
            )
        }.value
    }

    package func requestAccountCreation(email: String?) async throws {
        let backendEnvironment = try await networkStack.makeBackendEnvironment()
        bridge.sendOutboundEvent(.accountRegistrationRequested(email: email, backendEnvironment))
    }

}
