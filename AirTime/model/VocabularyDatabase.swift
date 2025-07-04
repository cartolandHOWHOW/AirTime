//
//  VocabularyDatabase.swift
//  AirTime
//
//  Created by max on 2025/7/4.
//

import Foundation
import SQLite3

class VocabularyDatabase {
    static let shared = VocabularyDatabase()
    private var db: OpaquePointer?

    private init() {
        openDatabase()
        createTable()
    }

    private func openDatabase() {
        let fileURL = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("vocabulary.sqlite")

        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("❌ 無法打開資料庫")
        } else {
            print("✅ 資料庫開啟成功：\(fileURL.path)")
        }
    }

    private func createTable() {
        let createTableQuery = """
        CREATE TABLE IF NOT EXISTS Collected (
            id TEXT PRIMARY KEY
        );
        """
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK {
            print("❌ 建立資料表失敗")
        }
    }

    func saveCollected(id: String) {
        let query = "INSERT OR IGNORE INTO Collected (id) VALUES (?);"
        var stmt: OpaquePointer?
        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
            sqlite3_bind_text(stmt, 1, id, -1, nil)
            if sqlite3_step(stmt) == SQLITE_DONE {
                print("✅ 收藏成功")
            }
        }
        sqlite3_finalize(stmt)
    }

    func removeCollected(id: String) {
        let query = "DELETE FROM Collected WHERE id = ?;"
        var stmt: OpaquePointer?
        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
            sqlite3_bind_text(stmt, 1, id, -1, nil)
            if sqlite3_step(stmt) == SQLITE_DONE {
                print("🗑️ 已取消收藏")
            }
        }
        sqlite3_finalize(stmt)
    }

    func loadCollectedIDs() -> Set<String> {
        let query = "SELECT id FROM Collected;"
        var stmt: OpaquePointer?
        var ids = Set<String>()
        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
            while sqlite3_step(stmt) == SQLITE_ROW {
                if let idCString = sqlite3_column_text(stmt, 0) {
                    let id = String(cString: idCString)
                    ids.insert(id)
                }
            }
        }
        sqlite3_finalize(stmt)
        return ids
    }
}
