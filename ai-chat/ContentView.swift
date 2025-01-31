//
//  ContentView.swift
//  ai-chat
//
//  Created by Nikita Sheludko on 30.01.25.
//

import SwiftUI
import GoogleGenerativeAI

struct ContentView: View {
    @State private var text = ""
    @State private var userMessage = ""
    @State private var aiMessage = ""
    let model = GenerativeModel(name: "gemini-1.5-flash-8b", apiKey: "")
    
    func sendMessage() {
        if (!validate(text)) {
            return
        }
        
        hideKeyboard()
        
        let promt = text
        self.userMessage = promt
        self.text = ""
        
        Task {
            do {
                let responce = try await model.generateContent(promt)
                aiMessage = responce.text ?? "No response"
            }
            catch {
                aiMessage = "Error"
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    if (!userMessage.isEmpty) {
                        HStack {
                            Spacer()
                            
                            VStack {
                                Text(userMessage)
                                    .font(.system(size: 18))
                                    .foregroundStyle(.white)
                                    .padding()
                            }
                            .background(Color.blue)
                            .cornerRadius(15)
                            .frame(minWidth: 50, maxWidth: 250, alignment: .trailing)
                            .padding(.horizontal)
                        }
                    }
                    
                    if (!aiMessage.isEmpty) {
                        HStack {
                            VStack {
                                Text(aiMessage)
                                    .font(.system(size: 18))
                                    .foregroundStyle(.black)
                                    .padding()
                                
                            }
                            .background(Color(red: 216 / 255, green: 216 / 255, blue: 216 / 255))
                            .cornerRadius(15)
                            .frame(minWidth: 50, maxWidth: 250, alignment: .leading)
                            .padding(.horizontal)
                            
                            Spacer()
                        }
                    }
                }
                
                Spacer()
                
                HStack {
                    TextField("Enter your question", text: $text)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.leading, 10)
                        .font(.system(size: 20))
                    Button(action: {
                        sendMessage()
                    }){
                        Image(systemName: "paperplane.circle.fill")
                            .font(.system(size: 30))
                    }
                }
                .padding(.horizontal, 10)
                .padding(.bottom, 10)
            }
            .navigationTitle("AI Chat")
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func validate(_ text: String) -> Bool {
        return !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

#Preview {
    ContentView()
}
