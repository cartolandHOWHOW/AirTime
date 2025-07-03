//
//  VocabWord.swift
//  AirTime
//
//  Created by max on 2025/7/3.
//
/*
import Foundation

struct VocabWord: Codable, Identifiable {
    var id: String { english_word } // 用單字作為唯一識別值
    let english_word: String
    let part_of_speech: String
    let chinese_meaning: String
    let example_sentence: String
}
func loadVocabulary() -> [VocabWord] {
    guard let url = Bundle.main.url(forResource: "vocab", withExtension: "json") else {
        print("找不到 vocab.json")
        return []
    }

    do {
        let data = try Data(contentsOf: url)
        let decoded = try JSONDecoder().decode([VocabWord].self, from: data)
        return decoded
    } catch {
        print("解析 JSON 錯誤：\(error)")
        return []
    }
}
*/
