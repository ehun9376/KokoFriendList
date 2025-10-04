//
//  RetryPolicy.swift
//  CombineUser
//
//  Created by 陳逸煌 on 2025/9/24.
//

import Combine
import Foundation

struct RetryPolicy {
    let maxRetries: Int
    let initialDelay: TimeInterval
    let retryable: ((APIError) -> Bool)

    func delay(for retryTimes: Int) -> TimeInterval {
        return max(self.initialDelay * Double(retryTimes - 1), self.initialDelay)
    }
    
    static let networkAnd5xx: RetryPolicy = RetryPolicy(maxRetries: 3,
                                                        initialDelay: 0.5,

                                                        retryable: { error in
        switch error {
        case .transport:
            return true
        case .server(let status):
            return (500...599).contains(status)
        default:
            return false
        }
    })
    
    
}

extension Publisher where Failure == APIError {
    func retry(policy: RetryPolicy, scheduler: DispatchQueue = .global()) -> AnyPublisher<Output, Failure> {

        func attempt(_ retryTime: Int) -> AnyPublisher<Output, Failure> {
            return self.catch { error -> AnyPublisher<Output, Failure> in
                guard retryTime < policy.maxRetries, policy.retryable(error) else {
                    return Fail(error: error).eraseToAnyPublisher()
                }
                let delay = policy.delay(for: retryTime + 1)
                return Just(())
                    .delay(for: .seconds(delay), scheduler: scheduler)
                    .setFailureType(to: Failure.self)
                    .flatMap { attempt(retryTime + 1) }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        }

        return attempt(0)
    }
}
