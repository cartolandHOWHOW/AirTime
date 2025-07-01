//
//  WoodenManView.swift
//  AirTime
//
//  Created by max on 2025/6/26.
//

import SwiftUI

struct WoodenManView: View {
    @State private var userInput: String = ""
    @State private var messages: [ChatMessage] = []

    var body: some View {
        VStack {
            ScrollView {
                ForEach(messages) { msg in
                    HStack {
                        if msg.isUser {
                            Spacer()
                            Text(msg.text)
                                .padding()
                                .background(Color.blue.opacity(0.7))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        } else {
                            Text(msg.text)
                                .padding()
                                .background(Color.gray.opacity(0.3))
                                .cornerRadius(10)
                            Spacer()
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 4)
                }
            }

            Divider()

            HStack {
                TextField("你想說什麼？", text: $userInput)
                    .textFieldStyle(.roundedBorder)

                Button("送出") {
                    sendMessage()
                }
                .disabled(userInput.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            .padding()
        }
        .navigationTitle("Processing")
    }

    func sendMessage() {
        let trimmed = userInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        // 使用者訊息
        messages.append(ChatMessage(text: trimmed, isUser: true))
        userInput = ""

        // 模擬木頭人回覆
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let reply = WoodenManResponder.generateReply(to: trimmed)
            messages.append(ChatMessage(text: reply, isUser: false))
        }
    }
}
