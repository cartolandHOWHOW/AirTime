//
//  VocabularyView.swift
//  AirTime
//
//  Created by max on 2025/7/3.
//
import SwiftUI
import Foundation // Make sure Foundation is imported for Data and JSONDecoder
import AVFoundation





// Define your VocabularyWord struct - crucial for JSON decoding!
// Make sure this is in the same file or accessible to VocabularyView
struct VocabularyWord: Codable, Identifiable, Hashable {
    var id: String { english_word } // 以英文單字作為唯一識別碼
    let english_word: String
    let part_of_speech: String
    let chinese_meaning: String
    let example_sentence: String
}


struct VocabularyView: View {
    @State private var collectedWordIDs: Set<String> = []
    @State private var words: [VocabularyWord] = []
    @State private var errorMessage: String? // Optional: to display error in UI
    
    
    func speak(_ word: String) {
        let utterance = AVSpeechUtterance(string: word)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5 // 語速可調整 0.0 ~ 1.0
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
    
    
    
    func toggleCollection(for word: VocabularyWord) {
        if collectedWordIDs.contains(word.id) {
            VocabularyDatabase.shared.removeCollected(id: word.id)
        } else {
            VocabularyDatabase.shared.saveCollected(id: word.id)
        }

        // 重新載入資料
        collectedWordIDs = VocabularyDatabase.shared.loadCollectedIDs()
    }
    
    
    
    
    
    var body: some View {
        NavigationStack {
            List(words) { word in
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(word.english_word)
                            .font(.headline)
                        Text("\(word.part_of_speech) - \(word.chinese_meaning)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("例句：\(word.example_sentence)")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    

                    Spacer() // 把星星推到右邊
                    
                    Button(action: {
                        speak(word.english_word)
                    }) {
                        Image(systemName: "speaker.wave.2.fill")
                            .foregroundColor(.blue)
                    }
                    .buttonStyle(.plain)
                    
                    
                    Button(action: {
                        toggleCollection(for: word)
                    }) {
                        Image(systemName: collectedWordIDs.contains(word.id) ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.vertical, 4)
            }
            
            //.navigationTitle("英語單字訓練")
            .overlay(
                // Display error message if loading fails
                Group {
                    if let error = errorMessage {
                        VStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.largeTitle)
                                .foregroundColor(.red)
                            Text("載入錯誤！")
                                .font(.title2)
                                .padding(.top, 5)
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                    } else if words.isEmpty {
                        // Optional: Show a loading indicator or empty state if words array is empty
                        Text("載入單字中...")
                            .foregroundColor(.gray)
                    }
                }
            )
        }
        .onAppear {
            loadVocabulary()
            collectedWordIDs = VocabularyDatabase.shared.loadCollectedIDs()
        }
    }

    func loadVocabulary() {
        // Step 1: Check if the file URL can be found
        guard let url = Bundle.main.url(forResource: "Vocab", withExtension: "json") else {
            print("❌ 錯誤：無法找到 Vocab.json 檔案的 URL。請確認檔案名稱和副檔名是否正確，且已加入專案。")
            self.errorMessage = "無法找到 Vocab.json。請檢查檔案名稱和專案設定。"
            return
        }

        print("✅ 找到 Vocab.json 檔案的 URL：\(url.lastPathComponent)")

        // Step 2: Check if data can be loaded from the URL
        guard let data = try? Data(contentsOf: url) else {
            print("❌ 錯誤：無法從 URL 載入資料。檔案可能已損壞或無法存取。")
            self.errorMessage = "無法讀取 Vocab.json 資料。檔案可能損壞。"
            return
        }

        print("✅ 成功載入 Vocab.json 的資料，大小為：\(data.count) 位元組。")

        // Step 3: Attempt to decode the JSON data
        let decoder = JSONDecoder()
        do {
            let decodedWords = try decoder.decode([VocabularyWord].self, from: data)
            self.words = decodedWords
            print("✅ 成功解碼 \(decodedWords.count) 個單字！")
            self.errorMessage = nil // Clear error if successful
        } catch let decodingError as DecodingError {
            // Detailed decoding error handling
            switch decodingError {
            case .keyNotFound(let key, let context):
                print("❌ 解碼失敗：找不到鍵 '\(key.stringValue)'。路徑：\(context.codingPath.map { $0.stringValue }.joined(separator: " -> "))")
                self.errorMessage = "JSON 鍵值不符：找不到 '\(key.stringValue)'。"
            case .valueNotFound(let type, let context):
                print("❌ 解碼失敗：找不到類型 '\(type)' 的值。路徑：\(context.codingPath.map { $0.stringValue }.joined(separator: " -> "))")
                self.errorMessage = "JSON 值遺失：期望 \(type) 但未找到。"
            case .typeMismatch(let type, let context):
                print("❌ 解碼失敗：類型不匹配。期望 '\(type)'，但找到不同的類型。路徑：\(context.codingPath.map { $0.stringValue }.joined(separator: " -> "))")
                self.errorMessage = "JSON 類型不符：期望 \(type)。"
            case .dataCorrupted(let context):
                print("❌ 解碼失敗：資料損壞。\(context.debugDescription)")
                self.errorMessage = "JSON 資料損壞：\(context.debugDescription)。"
            @unknown default:
                print("❌ 未知的解碼錯誤：\(decodingError.localizedDescription)")
                self.errorMessage = "未知的 JSON 解碼錯誤。"
            }
            print("❌ 解碼錯誤的完整描述：\(decodingError)")
        } catch {
            // General error handling for any other potential error during decoding
            print("❌ 一般錯誤：解碼 Vocab.json 時發生未知錯誤：\(error.localizedDescription)")
            self.errorMessage = "載入 Vocab.json 時發生未知錯誤。"
        }
    
    }
}
struct CollectedView: View {
    @State private var collectedWords: [VocabularyWord] = []

    var body: some View {
        List(collectedWords) { word in
            VStack(alignment: .leading) {
                Text(word.english_word)
                    .font(.headline)
                Text("\(word.part_of_speech) - \(word.chinese_meaning)")
                    .font(.subheadline)
                Text("例句：\(word.example_sentence)")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }
        .navigationTitle("📚 收藏清單")
        .onAppear {
            loadCollectedWords()
        }
    }

    func loadCollectedWords() {
        // 載入所有單字
        guard let url = Bundle.main.url(forResource: "Vocab", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let allWords = try? JSONDecoder().decode([VocabularyWord].self, from: data) else {
            return
        }

        // 從 SQLite 載入收藏 ID
        let collectedIDs = VocabularyDatabase.shared.loadCollectedIDs()

        // 過濾出被收藏的單字
        self.collectedWords = allWords.filter { collectedIDs.contains($0.id) }
    }
}
 
