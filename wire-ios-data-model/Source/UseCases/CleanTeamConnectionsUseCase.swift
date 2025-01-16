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

import CoreData

public class CleanInvalidConnectionUseCase {
    private let context: NSManagedObjectContext

    public init(context: NSManagedObjectContext) {
        self.context = context
    }

    public func invoke(userID: UUID, domain: String?) throws {
        return

        try context.performAndWait { [context] in
            guard let user = ZMUser.fetch(with: userID, domain: domain, in: context) else {
                return // FIXME: Throw error
            }

            guard
                let teamID = ZMUser.selfUser(in: context).teamIdentifier,
                user.teamIdentifier == teamID,
                let connection = user.connection,
                connection.status != .accepted,
                connection.status != .blocked
            else {
                return
            }

            let invalidConversationTypes: [ZMConversationType] = [.invalid, .connection]
            if
                let conversation = connection.to.oneOnOneConversation,
                invalidConversationTypes.contains(conversation.conversationType) {
                    context.delete(conversation)
            }
            context.delete(connection)

            try context.save()
        }
    }
}

public class CleanTeamConnectionsUseCase {
    private let context: NSManagedObjectContext

    public init(context: NSManagedObjectContext) {
        self.context = context
    }

    public func invoke() async throws {
        try await context.perform { [self] in
            guard let teamID = ZMUser.selfUser(in: context).teamIdentifier else { return }

            try removeSameTeamConnections(selfUserTeamID: teamID)
            try createMissingMemberships(selfUserTeamID: teamID)

            try context.save()
        }
    }

    /// Deletes `ZMConnection` from users on the same team as `selfUser` along with associated conversations of type
    /// `invalid` or `connection`. In cases where the connection is `accepted` or `blocked` the existing connection and
    /// conversation is kept.
    private func removeSameTeamConnections(selfUserTeamID: UUID) throws {
        let keepStatuses: [ZMConnectionStatus] = [.accepted, .blocked]

        let fetchRequest = NSFetchRequest<ZMConnection>(entityName: ZMConnection.entityName())
        fetchRequest.predicate = NSPredicate(format: "NOT (status IN %@)", keepStatuses.map { $0.rawValue })

        let removeConversationTypes: [ZMConversationType] = [.invalid, .connection]
        let connections = try context.fetch(fetchRequest)

        for connection in connections where connection.to.teamIdentifier == selfUserTeamID {
            if
                let conversation = connection.to.oneOnOneConversation,
                removeConversationTypes.contains(conversation.conversationType)  {
                    context.delete(conversation)
            }
            context.delete(connection)
        }
    }

    /// Creates `ZMMemberships` for users which belong to `selfUsers` team but have no membership.
    private func createMissingMemberships(selfUserTeamID: UUID) throws {
        let fetchRequest = NSFetchRequest<ZMUser>(entityName: ZMUser.entityName())
        fetchRequest.predicate = NSCompoundPredicate(
            andPredicateWithSubpredicates: [
                NSPredicate(format: "membership == nil"),
                NSPredicate(format: "teamIdentifier_data != nil"),
                NSPredicate(format: "isAccountDeleted == NO"), // Avoid a loop of creating / deleting memberships
            ]
        )

        let users = try context.fetch(fetchRequest)
        for user in users where user.teamIdentifier == selfUserTeamID {
            user.createOrDeleteMembershipIfBelongingToTeam()
        }
    }
}
