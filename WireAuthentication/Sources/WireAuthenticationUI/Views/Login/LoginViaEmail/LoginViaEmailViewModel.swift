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
import UIKit
import WireAuthenticationAPI
import WireLogging
import WireReusableUIComponents

@MainActor
package final class LoginViaEmailViewModel: ObservableObject {

    // MARK: - View state

    @Published var email: String
    @Published var password: String = ""

    @Published var proxyUsername: String = ""
    @Published var proxyPassword: String = ""

    @Published private(set) var isLoading = false
    @Published var alert: Alert?

    let backendInfo: BackendInfo
    let isEmailPrefilled: Bool
    let canCreateAccount: Bool

    var areProxyCredentialsRequired: Bool {
        backendInfo.backendConfig.proxySettings?.needsAuthentication == true
    }

    var proxyServer: String {
        backendInfo.backendConfig.endpoints.backendURL.absoluteString
    }

    func isPasswordValid(_ password: String) -> Bool {
        !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var isOnPremiseBackend: Bool {
        backendInfo.environmentType != .production
    }

    var canSubmitCredentials: Bool {
        if areProxyCredentialsRequired {
            areAccountCredentialsValid && areProxyCredentialsValid
        } else {
            areAccountCredentialsValid
        }
    }

    // MARK: - Dependencies

    package let factory: any LoginViaEmailFactory
    private let interactor: any LoginViaEmailInteractorProtocol
    private let router: any Router
    private let didDetectDomainConflict: Bool

    // MARK: - Life cycle

    package init(
        factory: any LoginViaEmailFactory,
        interactor: any LoginViaEmailInteractorProtocol,
        router: any Router,
        email: String?,
        backendInfo: BackendInfo,
        canCreateAccount: Bool,
        didDetectDomainConflict: Bool
    ) {
        self.factory = factory
        self.interactor = interactor
        self.router = router
        self.email = email ?? ""
        self.backendInfo = backendInfo
        self.canCreateAccount = canCreateAccount
        self.didDetectDomainConflict = didDetectDomainConflict
        self.isEmailPrefilled = email != nil
    }

    // MARK: - Actions

    func submitCredentials() async {
        isLoading = true

        let sanitizedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let sanitizedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)

        do {
            if let proxyCredentials {
                try submitProxyCredentials(proxyCredentials)
            }

            let authenticationResult = try await interactor.login(
                email: sanitizedEmail,
                password: sanitizedPassword
            )

            WireLogger.authentication.info("Login via email succeeded")

            router.navigate(
                to: LoginViaEmailDestination.noHistory(authenticationResult: authenticationResult)
            )
        } catch {
            WireLogger.authentication.error("Login via email failed: \(error)")

            switch error {
            case LoginViaEmailUseCaseFailure.invalidCredentials:
                alert = .invalidCredentials
            case LoginViaEmailUseCaseFailure.twoFactorAuthenticationRequired:
                router.navigate(
                    to: LoginViaEmailDestination
                        .verifyLogin(
                            email: sanitizedEmail,
                            password: sanitizedPassword,
                            proxyCredentials: proxyCredentials
                        )
                )
            case LoginViaEmailUseCaseFailure.accountPendingActivation:
                alert = .accountPendingActivation
            case LoginViaEmailUseCaseFailure.accountSuspended:
                alert = .accountSuspended
            default:
                router.presentAlert(for: error)
            }
        }

        isLoading = false
    }

    func recoverPassword() {
        UIApplication.shared.open(
            backendInfo.backendConfig.endpoints.accountsURL.appendingPathComponent("forgot")
        )
    }

    func createAccount() async {
        do {
            try await interactor.requestAccountCreation(email: email)
            router.dismissSheet()
        } catch {
            router.presentAlert(for: error)
        }
    }

    // MARK: - Private

    private var proxyCredentials: ProxyCredentials? {
        guard areProxyCredentialsRequired else {
            return nil
        }

        return ProxyCredentials(
            username: proxyUsername.trimmingCharacters(in: .whitespacesAndNewlines),
            password: proxyPassword.trimmingCharacters(in: .whitespacesAndNewlines)
        )
    }

    private var areAccountCredentialsValid: Bool {
        let isEmailValid = interactor.isEmailVaild(email)
        let isPasswordValid = isPasswordValid(password)
        return isEmailValid && isPasswordValid
    }

    private var areProxyCredentialsValid: Bool {
        let isUsernameValid = !proxyUsername.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let isPasswordValid = isPasswordValid(proxyPassword)
        return isUsernameValid && isPasswordValid
    }

    private func submitProxyCredentials(_ proxyCredentials: ProxyCredentials) throws {
        try interactor.submitProxyCredentials(proxyCredentials)
    }

}
