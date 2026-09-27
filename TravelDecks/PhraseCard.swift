//
//  PhraseCard.swift
//  TravelDecks
//
//  Created by smallfat on 2026/9/27.
//

import SwiftUI

struct PhraseCard: View {
    let phrase: Phrase
    @ObservedObject var speechManager: SpeechManager
    
    // 接收來自外層的狀態
    @Binding var expandedID: UUID?
    
    @Environment(\.colorScheme) var colorScheme
    
    var isCurrentlySpeaking: Bool {
        speechManager.speakingID == phrase.id
    }
    
    var isExpanded: Bool {
        expandedID == phrase.id
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    // 點擊控制展開/收合
                    if expandedID == phrase.id {
                        expandedID = nil
                    } else {
                        expandedID = phrase.id
                    }
                }
                speechManager.speak(text: phrase.italian, id: phrase.id)
            }) {
                HStack {
                    Text(phrase.chinese)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Image(systemName: isCurrentlySpeaking ? "speaker.wave.3.fill" : "speaker.wave.2.circle.fill")
                        .foregroundColor(isCurrentlySpeaking ? .green : (colorScheme == .dark ? .orange : .blue))
                        .font(.title2)
                }
            }
            
            if isExpanded {
                Text(phrase.italian)
                    .font(.system(size: 19, weight: .semibold))
                    .foregroundColor(colorScheme == .dark ? .yellow : Color(uiColor: .darkGray))
                    .padding(.top, 4)
                    .padding(.bottom, 4)
            }
        }
        .padding(.vertical, 8)
    }
}

// 這個 Preview 是為了讓你可以單獨預覽這個小元件設計的
#Preview {
    PhraseCard(
        phrase: Phrase(chinese: "你好", italian: "Ciao"),
        speechManager: SpeechManager(), // 產生一個臨時的語音管理器給預覽用
        expandedID: .constant(nil)      // 假裝一開始沒有被展開
    )
    .padding()
}
