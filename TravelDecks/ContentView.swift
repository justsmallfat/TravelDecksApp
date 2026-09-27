//
//  ContentView.swift
//  TravelDecks
//
//  Created for your Italy Trip 🇮🇹
//

import SwiftUI
import AVFoundation
import Combine

// 1. 定義字卡的資料結構
struct Phrase: Identifiable {
    let id = UUID()
    let chinese: String
    let italian: String
}

// 2. 建立一個語音管理器
class SpeechManager: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    private let synthesizer = AVSpeechSynthesizer()
    
    @Published var speakingID: UUID? = nil
    private var pendingID: UUID? = nil
    
    override init() {
        super.init()
        synthesizer.delegate = self
    }
    
    func speak(text: String, id: UUID) {
        pendingID = id
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "it-IT")
        utterance.rate = 0.45
        
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        
        synthesizer.speak(utterance)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            self.speakingID = self.pendingID
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            self.speakingID = nil
        }
    }
}

// 3. 主要畫面
struct ContentView: View {
    @StateObject private var speechManager = SpeechManager()
    
    // 🌟 核心升級：由主畫面統一記錄「現在是哪一張字卡被展開」
    @State private var expandedID: UUID? = nil
    
    let phrases: [Phrase] = [
        // --- 原本的實用 10 句 ---
        Phrase(chinese: "你好", italian: "Ciao"),
        Phrase(chinese: "謝謝", italian: "Grazie"),
        Phrase(chinese: "請問多少錢？", italian: "Quanto costa?"),
        Phrase(chinese: "我要去這個地址 (給司機看)", italian: "Voglio andare a questo indirizzo."),
        Phrase(chinese: "結帳，謝謝 (買單)", italian: "Il conto, per favore."),
        Phrase(chinese: "請問廁所在哪裡？", italian: "Dov'è il bagno?"),
        Phrase(chinese: "太貴了，可以便宜一點嗎？", italian: "È troppo caro, può fare uno sconto?"),
        Phrase(chinese: "不好意思 (引起注意 / 點餐用)", italian: "Scusi"),
        Phrase(chinese: "我聽不懂", italian: "Non capisco"),
        Phrase(chinese: "救命 / 請幫幫我！", italian: "Aiuto! Ho bisogno di aiuto!"),
        
        // --- 進階實用 10 句 ---
        Phrase(chinese: "請問可以刷卡嗎？", italian: "Posso pagare con la carta?"),
        Phrase(chinese: "兩位，謝謝 (餐廳帶位)", italian: "Un tavolo per due, per favore."),
        Phrase(chinese: "請給我一般礦泉水 (無氣泡)", italian: "Dell'acqua naturale, per favore."),
        Phrase(chinese: "這真的很好吃！(稱讚店員)", italian: "È molto buono!"),
        Phrase(chinese: "請問有英文菜單嗎？", italian: "Avete un menù in inglese?"),
        Phrase(chinese: "我想試穿這個 (購物)", italian: "Posso provarlo?"),
        Phrase(chinese: "請問火車幾點開？", italian: "A che ora parte il treno?"),
        Phrase(chinese: "我要買一張票", italian: "Vorrei comprare un biglietto."),
        Phrase(chinese: "請問你會說英文嗎？", italian: "Parla inglese?"),
        Phrase(chinese: "對不起 (道歉時用)", italian: "Mi dispiace."),
        
        // --- 專屬需求 8 句 ---
        Phrase(chinese: "借過 / 讓一讓 (穿越人群用)", italian: "Permesso."),
        Phrase(chinese: "請稍等一下", italian: "Un attimo, per favore."),
        Phrase(chinese: "請問最近的火車站在哪裡？", italian: "Dov'è la stazione dei treni più vicina?"),
        Phrase(chinese: "我應該在哪一站下車？", italian: "A quale fermata devo scendere?"),
        Phrase(chinese: "請問超市在哪裡？", italian: "Dov'è il supermercato?"),
        Phrase(chinese: "請問可以有兩個人的座位嗎？", italian: "C'è un tavolo per due?"),
        Phrase(chinese: "請問這有牛肉嗎？我不能吃牛肉", italian: "C'è del manzo in questo piatto? Non mangio manzo."),
        Phrase(chinese: "有沒有推薦的餐點？", italian: "Cosa ci consiglia?")
    ]
    
    var body: some View {
        NavigationView {
            List(phrases) { phrase in
                // 將 expandedID 以 Binding 的方式傳給 Row
                PhraseCard(
                    phrase: phrase,
                    speechManager: speechManager,
                    expandedID: $expandedID
                )
            }
            .navigationTitle("TravelDecks 🇮🇹")
        }
    }
}

#Preview {
    ContentView()
}
