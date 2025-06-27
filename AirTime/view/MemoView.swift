//
//  MemoView.swift
//  AirTime
//
//  Created by max on 2025/6/27.
//
import SwiftUI

struct MemoView: View {
    @State private var memoText: String = ""
    @State private var notes: [MemoNote] = []

    let saveKey = "memo_notes"

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("📓 備忘錄")
                .font(.largeTitle)
                .bold()

            TextEditor(text: $memoText)
                .frame(height: 120)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.5)))
                .background(Color(.systemGray6))
                .cornerRadius(12)

            Button("➕ 新增筆記") {
                addMemo()
            }
            .disabled(memoText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            .buttonStyle(.borderedProminent)

            Divider()

            ScrollView {
                LazyVStack(alignment: .leading, spacing: 10) {
                    ForEach(notes) { note in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(note.content)
                                .font(.body)

                            Text(dateFormatter.string(from: note.date))
                                .font(.caption)
                                .foregroundColor(.gray)

                            Button(role: .destructive) {
                                deleteMemo(id: note.id)
                            } label: {
                                Label("刪除", systemImage: "trash")
                            }
                            .font(.caption)
                            .foregroundColor(.red)
                        }
                        .padding()
                        .background(Color.yellow.opacity(0.2))
                        .cornerRadius(10)
                    }
                }
            }

            Spacer()
        }
        .padding()
        .onAppear {
            loadNotes()
        }
    }

    func addMemo() {
        let newNote = MemoNote(content: memoText, date: Date())
        notes.insert(newNote, at: 0) // 最新的放上面
        memoText = ""
        saveNotes()
    }

    func deleteMemo(id: UUID) {
        notes.removeAll { $0.id == id }
        saveNotes()
    }

    func saveNotes() {
        if let data = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }

    func loadNotes() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([MemoNote].self, from: data) {
            notes = decoded
        }
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter
    }
}

