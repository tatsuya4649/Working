//
//  Reading.swift
//  Working
//
//  Created by 下川達也 on 2020/05/14.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import AVFoundation

final class Reading{
    var sentences : String!
    var talker : AVSpeechSynthesizer!
    var utterance : AVSpeechUtterance!
    var output : AVAudioFile!
    var pedoElement : PedometerElement!
    var audioFileName : String!
    ///初期化のときに読み上げに使用する文章を受け取る
    init(_ sentences:String,_ pedoElement:PedometerElement) {
        self.sentences = sentences
        self.talker = AVSpeechSynthesizer()
        self.utterance = AVSpeechUtterance(string:self.sentences)
        self.utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
        self.pedoElement = pedoElement
        switch pedoElement {
        case .steps:
            audioFileName = stepsAudioFile
        case .distance:
            audioFileName = distanceAudioFile
        case .time:
            audioFileName = timeAudioFile
        case .calorie:
            audioFileName = calorieAudioFile
        default:
            break
        }
    }
    ///実際に読み上げを実行するメソッド
    public func readingSentences(){
        guard let talker = talker else{return}
        guard let utterance = utterance else{return}
        audioSettingChange()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            talker.speak(utterance)
        }
    }
    private func audioSettingChange(){
        do{
            try AVAudioSession.sharedInstance().setCategory(.ambient,mode: .default)
            do {
                try AVAudioSession.sharedInstance().setActive(true)
            } catch let error as NSError {
                print (error.localizedDescription)
            }
        }catch{
            print(error.localizedDescription)
        }
    }
    ///読み上げ機能を特定のファイルにダウンロードする
    public func readingToAudioFile(){
        audioSettingChange()
        talker.write(utterance) { (buffer: AVAudioBuffer) in
            guard let pcmBuffer = buffer as? AVAudioPCMBuffer else {fatalError("unknown buffer type: \(buffer)")}
            guard pcmBuffer.frameLength != 0 else{return}
            // append buffer to file
            if self.output == nil {
                do{
                    let documentsPath = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
                    let soundDirUrl = documentsPath.appendingPathComponent("Sounds")
                    do{
                        try? FileManager.default.createDirectory(at: soundDirUrl, withIntermediateDirectories: true, attributes: nil)
                    }catch{
                        print("サウンドディレクトリの作成失敗")
                    }
                    guard let audioFileName = self.audioFileName else{return}
                    let url = soundDirUrl.appendingPathComponent(audioFileName)
                    self.output = try AVAudioFile(
                    forWriting: url,
                    settings: pcmBuffer.format.settings,
                    commonFormat: .pcmFormatInt16,
                    interleaved: false)
                    print("ファイル作成には成功")
                    
                }catch{
                    print("これが失敗！")
                }
            }
            do{
                try self.output?.write(from: pcmBuffer)
                print("成功！")
            }catch{
                print("失敗！")
            }
            var fileSize : UInt64
            do {
                //return [FileAttributeKey : Any]
                if let documentsPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first {
                    guard let audioFileName = self.audioFileName else{return}
                    let soundsPath = documentsPath.appending("/Sounds")
                    let path = soundsPath.appending("/\(audioFileName)")
                    let attr = try FileManager.default.attributesOfItem(atPath: path)
                    fileSize = attr[FileAttributeKey.size] as! UInt64

                    //if you convert to NSDictionary, you can get file size old way as well.
                    let dict = attr as NSDictionary
                    fileSize = dict.fileSize()
                    print(fileSize)
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }
}
