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

/// An event concerning conversations.

enum ConversationEvent: Equatable, Codable, Sendable {

    /// A conversation's access settings were updated.

    case accessUpdate(StorableConversationAccessUpdateEvent)

    /// A conversation's guest link code was updated.

    case codeUpdate(StorableConversationCodeUpdateEvent)

    /// A new conversation was created.

    case create(StorableConversationCreateEvent)

    /// An existing conversation was deleted.

    case delete(StorableConversationDeleteEvent)

    /// One or more users were added to a conversation.

    case memberJoin(StorableConversationMemberJoinEvent)

    /// One or more users were removed from a conversation.

    case memberLeave(ConversationMemberLeaveEvent)

    /// One or more users have updated metadata in a conversation.

    case memberUpdate(ConversationMemberUpdateEvent)

    /// A conversation's self-deleting-message timer was updated.

    case messageTimerUpdate(ConversationMessageTimerUpdateEvent)

    /// An MLS message was added to a conversation.

    case mlsMessageAdd(ConversationMLSMessageAddEvent)

    /// The self user has been added to an MLS group.

    case mlsWelcome(ConversationMLSWelcomeEvent)

    /// An encrypted Proteus message was added to a conversation.

    case proteusMessageAdd(ConversationProteusMessageAddEvent)

    /// A conversation's message protocol was updated.

    case protocolUpdate(StorableConversationProtocolUpdateEvent)

    /// A conversation's read receipt mode was updated.

    case receiptModeUpdate(StorableConversationReceiptModeUpdateEvent)

    /// A conversation's name was updated.

    case rename(StorableConversationRenameEvent)

    /// One or more users are typing in a conversation.

    case typing(StorableConversationTypingEvent)

    /// A permission for a private conversation (aka channel) was updated.

    case permissionUpdate(StorableConversationAddPermissionEvent)

}
