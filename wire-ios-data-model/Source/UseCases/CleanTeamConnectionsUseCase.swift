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

    // FIXME: Don't pass managed object
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

    public func invoke() throws {
        print(">>>>>> Cleaning team connections")

        try context.performAndWait {
            guard let teamID = ZMUser.selfUser(in: context).teamIdentifier else { return }
            print(">>>>>>> Team ID: ", teamID)

            let notStatus: [Int16] = [ZMConnectionStatus.accepted, ZMConnectionStatus.blocked].map { $0.rawValue }
            let fetchRequest = NSFetchRequest<ZMConnection>(entityName: ZMConnection.entityName())
            fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
//                NSPredicate(format: "to.membership != nil"),
//                NSPredicate(format: "to.membership.team != nil"),
                NSPredicate(format: "NOT (status IN %@)", notStatus),

            ])

            let conversationTypes: [ZMConversationType] = [.invalid, .connection]
            let connections = try context.fetch(fetchRequest)
            print(">>>>>> CONNECTIONS:")
            for connection in connections {
                print(">>>>>>>>", connection.to.name ?? "No name", ": ", connection.to.teamIdentifier ?? "No team", ": status - ", connection.status)
            }

            for connection in connections where connection.to.teamIdentifier == teamID && connection.status != .accepted && connection.status != .blocked {
                print(">>>>>>> Cleaning" )
                if
                    let conversation = connection.to.oneOnOneConversation,
                    conversationTypes.contains(conversation.conversationType)  {
                        context.delete(conversation)
                }
                context.delete(connection)
            }

            try context.save()
        }
    }

    public func invoke2() throws {
        print(">>>>>> Cleaning team connections")
        try context.performAndWait {
            let notStatus: [Int16] = [ZMConnectionStatus.accepted, ZMConnectionStatus.blocked].map { $0.rawValue }
            let fetchRequest = NSFetchRequest<ZMConnection>(entityName: ZMConnection.entityName())
            fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
//                NSPredicate(format: "to.membership != nil"),
//                NSPredicate(format: "to.membership.team != nil"),
                NSPredicate(format: "NOT (status IN %@)", notStatus),

            ])

            let conversationTypes: [ZMConversationType] = [.invalid, .connection]
            let connections = try context.fetch(fetchRequest)
            for connection in connections {
                print(">>>>>>>>", connection.to.name ?? "No name", ": ", connection.to.membership?.team?.name ?? "No team")


//                if
//                    let conversation = connection.to.oneOnOneConversation,
//                    conversationTypes.contains(conversation.conversationType)  {
//                        context.delete(conversation)
//                }
//                context.delete(connection)
            }

            try context.save()
        }
    }
}

// NSPredicate(format: "to.membership != nil AND to.membership.team != nil AND (NOT (status IN %@)) AND to.oneOnOneConversation != nil AND to.oneOnOneConversation", notStatus)
//        NSPredicate(format: "to.oneOnOneConversation != nil"),
//        NSPredicate(format: "to.oneOnOneConversation.conversationType IN %@", conversationTypes),

//
//
//        let c = connections[0]
//        c.to.teamIdentifier




        // Get all connections that are not accepted
        // Filter for those that are team members
        // If connection is pending cancel & delete the conversation
