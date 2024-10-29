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
import WireSyncEngine
import WireUserProfileUI

extension ConversationViewController {

    func createUserDetailViewController() -> UIViewController {
        guard let user = (conversation.firstActiveParticipantOtherThanSelf ?? conversation.connectedUser) else {
            fatal("no firstActiveParticipantOtherThanSelf!")
        }

        let userDetailsProvider = UserDetailsProvider(user: user)
        let userProfileBuilder = UserProfileBuilder(userDetailsProvider: userDetailsProvider)
        let viewController = UIHostingController(rootView: userProfileBuilder.build())
        return viewController

        return UserDetailViewControllerFactory.createUserDetailViewController(
            user: user,
            conversation: conversation,
            profileViewControllerDelegate: self,
            viewControllerDismisser: self,
            userSession: userSession,
            mainCoordinator: mainCoordinator
        )
    }
}

extension ConversationViewController: ProfileViewControllerDelegate {
    func profileViewController(_ controller: ProfileViewController?, wantsToNavigateTo conversation: ZMConversation) {
        dismiss(animated: true) {
            self.mainCoordinator.openConversation(conversation, focusOnView: true, animated: true)
        }
    }
}

struct UserDetailsProvider: UserDetailsProviderProtocol {

    var user: ZMUser

    var displayName: String { user.name ?? "?" }
    var username: String { user.handle ?? "?" }
    var accountImage: UIImage { .init() }
    var accountRole: String { "?" }
}
