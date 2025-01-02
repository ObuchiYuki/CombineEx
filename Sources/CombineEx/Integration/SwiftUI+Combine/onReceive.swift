//
//  SubscriberView.swift
//  CombineEx
//
//  Created by yuki on 2025/01/02.
//

import SwiftUI
import Combine

extension View {
    public func onReceive<P: Publisher>(
        _ publisher: P,
        perform action: @escaping (Result<P.Output, P.Failure>) -> Void
    ) -> some View {
        modifier(_OnReceiveModifier(publisher: publisher, action: action))
    }
}

private struct _OnReceiveModifier<P: Publisher>: ViewModifier {
    let publisher: P
    let action: (Result<P.Output, P.Failure>) -> Void

    @State private var subscription: AnyCancellable?

    func body(content: Content) -> some View {
        content
            .background(
                SubscriberView(
                    publisher: self.publisher,
                    action: self.action,
                    subscription: self.$subscription
                )
            )
    }

    /// 購読を管理するためだけの小さな View
    private struct SubscriberView: View {
        let publisher: P

        let action: (Result<P.Output, P.Failure>) -> Void

        @Binding var subscription: AnyCancellable?

        var body: some View {
            EmptyView()
                .onAppear {
                    self.subscription = self.publisher
                        .sink(receiveCompletion: { completion in
                            switch completion {
                            case .finished:
                                break
                            case .failure(let error):
                                self.action(.failure(error))
                            }
                        }, receiveValue: { value in
                            self.action(.success(value))
                        })
                }
                .onDisappear {
                    self.subscription?.cancel()
                    self.subscription = nil
                }
        }
    }
}
