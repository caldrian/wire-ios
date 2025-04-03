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

import Combine
import SwiftUI
import WireAuthenticationAPI
import WireFoundation
import WireReusableUIComponentsSupport
import WireTestingPackage
import XCTest

@testable import WireAuthenticationAPISupport
@testable import WireAuthenticationUI

class LoginViaEmailViewModelTests: XCTestCase {

    private var router: MockRouter!
    private var sut: LoginViaEmailViewModel!
    private var onCreateAccountCalled = false
    private var isLoadingCalls: [Bool] = []
    private var cancellables: Set<AnyCancellable> = []

    private var mockInteractor: MockLoginViaEmailInteractorProtocol!

    @MainActor
    override func setUp() async throws {
        let mockDependencies = MockDependencies()
        let backendInfo = mockDependencies.backendInfo
        let factory = FakeLoginViaEmailFactory(
            backendInfo: backendInfo,
            canCreateAccount: true,
            didDetectDomainConflict: false
        )
        
        mockInteractor = MockLoginViaEmailInteractorProtocol()
        router = MockRouter()
        sut = LoginViaEmailViewModel(
            factory: factory,
            interactor: mockInteractor,
            router: router,
            email: "mika@example.com",
            backendInfo: backendInfo,
            canCreateAccount: true,
            didDetectDomainConflict: false
        )

        sut.$isLoading.dropFirst().sink { [self] in isLoadingCalls.append($0) }.store(in: &cancellables)
    }

    override func tearDown() {
        mockInteractor = nil
        router = nil
        sut = nil
        onCreateAccountCalled = false
        isLoadingCalls = []
    }

    // MARK: - submitPassword tests

    @MainActor
    func testSubmitPassword_passesCorrectCredentials() async throws {
        // given
        sut.email = " mika@example.com "
        sut.password = " password  "

        let authenticationResult = AuthenticationResult(
            userID: Fixture.someAccessToken.userID,
            cookies: [Fixture.someCookie],
            accessToken: Fixture.someAccessToken,
            emailCredentials: EmailCredentials(
                email: "mika@example.com",
                password: "password",
                verificationCode: nil
            ),
            backendEnvironment: Fixture.backendEnvironment
        )

        // mock
        mockInteractor.loginEmailPassword_MockValue = authenticationResult

        // when
        await sut.submitCredentials()

        // then
        let invocations = mockInteractor.loginEmailPassword_Invocations
        try XCTAssertCount(invocations, count: 1)
        XCTAssertEqual(invocations[0].email, "mika@example.com")
        XCTAssertEqual(invocations[0].password, "password")
    }

    @MainActor
    func testSubmitPassword_whenSuccessful() async throws {
        // given
        sut.email = " mika@example.com "
        sut.password = " password  "

        let authenticationResult = AuthenticationResult(
            userID: Fixture.someAccessToken.userID,
            cookies: [Fixture.someCookie],
            accessToken: Fixture.someAccessToken,
            emailCredentials: EmailCredentials(
                email: "mika@example.com",
                password: "password",
                verificationCode: nil
            ),
            backendEnvironment: Fixture.backendEnvironment
        )

        // mock
        mockInteractor.loginEmailPassword_MockValue = authenticationResult

        // when
        await sut.submitCredentials()

        // then
        XCTAssertNil(sut.alert)
        XCTAssertEqual(isLoadingCalls, [true, false])

        try XCTAssertCount(router.navigate_Invocations, count: 1)
        let actualDestination = try XCTUnwrap(router.navigate_Invocations[0] as? LoginViaEmailDestination)
        XCTAssertEqual(actualDestination, .noHistory(authenticationResult: authenticationResult))
    }

    @MainActor
    func testSubmitPassword_withInvalidCredentials() async {
        // given
        sut.email = " mika@example.com "
        sut.password = " bad password  "

        // mock
        mockInteractor.loginEmailPassword_MockError = LoginViaEmailUseCaseFailure.invalidCredentials

        // when
        await sut.submitCredentials()

        // then
        XCTAssertEqual(sut.alert, .invalidCredentials)
        XCTAssertEqual(isLoadingCalls, [true, false])
    }

    @MainActor
    func testSubmitPassword_when2FARequired() async throws {
        // given
        sut.email = " mika@example.com "
        sut.password = " password  "

        // mock
        mockInteractor.loginEmailPassword_MockError = LoginViaEmailUseCaseFailure.twoFactorAuthenticationRequired

        // when
        await sut.submitCredentials()

        // then
        XCTAssertNil(sut.alert)
        XCTAssertEqual(isLoadingCalls, [true, false])
        try XCTAssertCount(router.navigate_Invocations, count: 1)
        let actualDestination = try XCTUnwrap(router.navigate_Invocations[0] as? LoginViaEmailDestination)
        XCTAssertEqual(
            actualDestination,
            LoginViaEmailDestination
                .verifyLogin(
                    email: "mika@example.com",
                    password: "password",
                    proxyCredentials: nil
                )
        )
    }

    @MainActor
    func testSubmitPassword_whenAccountPendingActivation() async {
        // given
        sut.email = " mika@example.com "
        sut.password = " password  "

        // mock
        mockInteractor.loginEmailPassword_MockError = LoginViaEmailUseCaseFailure.accountPendingActivation

        // when
        await sut.submitCredentials()

        // then
        XCTAssertEqual(sut.alert, .accountPendingActivation)
        XCTAssertEqual(isLoadingCalls, [true, false])
    }

    @MainActor
    func testSubmitPassword_whenAccountSuspended() async {
        // given
        sut.email = " mika@example.com "
        sut.password = " password  "

        // mock
        mockInteractor.loginEmailPassword_MockError = LoginViaEmailUseCaseFailure.accountSuspended

        // when
        await sut.submitCredentials()

        // then
        XCTAssertEqual(sut.alert, .accountSuspended)
        XCTAssertEqual(isLoadingCalls, [true, false])
    }

    @MainActor
    func testSubmitPassword_whenUnknownErrorOccurs() async {
        // given
        sut.email = " mika@example.com "
        sut.password = " password  "

        // mock
        mockInteractor.loginEmailPassword_MockError = URLError(.badURL)

        // when
        await sut.submitCredentials()

        // then
        XCTAssertEqual(router.alert_Invocations, [.unknownError])
        XCTAssertEqual(isLoadingCalls, [true, false])
    }

    // MARK: - isValidPassword tests

    @MainActor
    func testIsValidPassword() {
        XCTAssertTrue(sut.isPasswordValid("p"))
        XCTAssertTrue(sut.isPasswordValid("password"))
        XCTAssertFalse(sut.isPasswordValid(""))
        XCTAssertFalse(sut.isPasswordValid(" "))
    }

}
