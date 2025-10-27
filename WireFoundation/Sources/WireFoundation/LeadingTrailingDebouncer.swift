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

public import Foundation

/// A debouncer that triggers the action immediately on the first call (leading)
/// and once more after a delay if additional calls occur (trailing).
/// Useful for responding instantly but also handling final state after other input.
public final class LeadingTrailingDebouncer<ID: Hashable> {

    private struct DebounceState {
        var isCooldown = false
        var pendingCall: (() -> Void)?
    }

    private let cooldownTime: TimeInterval
    private let queue: DispatchQueue
    private var states: [AnyHashable: DebounceState] = [:]

    // Unique key for `nil` ID
    private let nilKey = UUID()

    public init(cooldownTime: TimeInterval, queue: DispatchQueue = .main) {
        self.cooldownTime = cooldownTime
        self.queue = queue
    }

    public func call(id: ID?, block: @escaping () -> Void) {
        precondition(Thread.isMainThread)

        let key: AnyHashable = id.map { AnyHashable($0) } ?? AnyHashable(nilKey)

        if states[key] == nil {
            states[key] = DebounceState()
        }

        var state = states[key]!

        if !state.isCooldown {
            // LEADING: run immediately
            block()
            state.isCooldown = true
            states[key] = state

            queue.asyncAfter(deadline: .now() + cooldownTime) { [weak self] in
                guard let self else { return }

                var updatedState = states[key] ?? DebounceState()
                
                // Execute trailing call if pending
                if let trailing = updatedState.pendingCall {
                    trailing()
                }
                
                // Reset state
                updatedState.isCooldown = false
                updatedState.pendingCall = nil
                states[key] = updatedState
            }
        } else {
            // Store for TRAILING
            state.pendingCall = block
            states[key] = state
        }
    }
}


/// A simple leading-trailing debouncer that calls actions on the leading edge (immediately)
/// and debounces trailing edge calls.
final class SimpleDebouncer {
    private var workItem: DispatchWorkItem?
    private let queue: DispatchQueue
    private let delay: TimeInterval

    /// - Parameters:
    ///   - delay: The debounce delay in seconds
    ///   - queue: The dispatch queue to execute on (default: main)
    init(delay: TimeInterval, queue: DispatchQueue = .main) {
        self.delay = delay
        self.queue = queue
    }

    /// Call the action on the leading edge immediately, then debounce subsequent calls
    func debounce(action: @escaping () -> Void) {
        // Cancel any pending work
        workItem?.cancel()

        // Execute leading edge immediately
        action()

        // Schedule trailing edge debounce
        let item = DispatchWorkItem {
            // Trailing edge action (executed after delay if no new calls)
            action()
        }

        self.workItem = item
        queue.asyncAfter(deadline: .now() + delay, execute: item)
    }

    /// Cancel any pending work
    func cancel() {
        workItem?.cancel()
    }
}

// MARK: - Usage Example

/*
// Example 1: Basic usage
let debouncer = SimpleDebouncer(delay: 0.5)

// First call executes immediately (leading edge)
debouncer.debounce {
    print("Action executed")
}

// Subsequent calls within 0.5 seconds are debounced
// but if called again later, it will fire again

// Example 2: Search text field
class SearchViewController {
    private let debouncer = SimpleDebouncer(delay: 0.3)

    func textDidChange(to text: String) {
        debouncer.debounce {
            self.performSearch(query: text)
        }
    }

    func performSearch(query: String) {
        // Search logic here
        print("Searching for: \(query)")
    }
}

// Example 3: Button tap tracking
let buttonDebouncer = SimpleDebouncer(delay: 1.0)

buttonDebouncer.debounce {
    print("Button tapped at leading edge")
}

// Trailing edge will fire after 1 second if no new calls
*/

