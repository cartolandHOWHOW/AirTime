//
//  WoodenManResponder.swift
//  AirTime
//
//  Created by max on 2025/6/26.
//

import Foundation

struct WoodenManResponder {
    static func generateReply(to input: String) -> String {
        let lowercased = input.lowercased()

        // 根據關鍵字給特定直男風回覆
        if lowercased.contains("想你") || lowercased.contains("喜歡") {
            return ["喔", "那你要開心", "我也想睡了", "嗯"].randomElement()!
        } else if lowercased.contains("在幹嘛") || lowercased.contains("吃飯了嗎") {
            return ["在忙", "剛剛吃飽", "沒事", "就那樣"].randomElement()!
        } else if lowercased.contains("你怎麼都不回") {
            return ["我不是一直這樣嗎", "有事再說", "沒看到訊息"].randomElement()!
        } else if lowercased.contains("我們是什麼關係") {
            return ["普通朋友", "你想太多了", "我沒想那麼多"].randomElement()!
        } else if lowercased.contains("hi") {
            return ["我英文不太好誒，可以打中文嗎","hi"].randomElement()!
        } else if lowercased.contains("okay") {
            return ["行啊!"].randomElement()!
        } else if lowercased.contains("不好") || lowercased.contains("sad") {
            return ["dont cry dont cry"].randomElement()!
        } else if lowercased.contains("想法") || lowercased.contains("看法") {
            return ["太完美了!","沒有問題"].randomElement()!
        } else if lowercased.contains("怎麼辦") || lowercased.contains("怪") {
            return ["這不是我的鍋"].randomElement()!
        }

        // 預設敷衍式回應
        let defaultReplies = [
            "嗷~","哈哈先這樣"
        ]
        return defaultReplies.randomElement()!
    }
}
