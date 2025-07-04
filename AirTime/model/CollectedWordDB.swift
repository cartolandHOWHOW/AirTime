//
//  CollectedWordDB.swift
//  AirTime
//
//  Created by max on 2025/7/4.
//

//import SQLite
//
//struct CollectedWordDB {
//    static let table = Table("collected_words")
//
//    static let id = Expression<String>("id") // 對應 english_word 當作主鍵
//    static let english_word = Expression<String>("english_word")
//    static let part_of_speech = Expression<String>("part_of_speech")
//    static let chinese_meaning = Expression<String>("chinese_meaning")
//    static let example_sentence = Expression<String>("example_sentence")
//}
import SQLite

struct CollectedWordDB {
    static let table = Table("collected_words")
    
    static let id = Expression<String>("id")
    static let english_word = Expression<String>("english_word")
    static let part_of_speech = Expression<String>("part_of_speech")
    static let chinese_meaning = Expression<String>("chinese_meaning")
    static let example_sentence = Expression<String>("example_sentence")
}
