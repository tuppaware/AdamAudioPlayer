//
//  AdamAudioPlayer.swift
//  
//
//  Created by Adam Ware on 27/8/18.
//  Copyright © 2018 Adam Ware. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.


import Foundation
import AVFoundation


 @objc class AdamAudioPlayer: NSObject, AVAudioPlayerDelegate {
    private var container = [String : AVAudioPlayer]()

    // MARK: - Shared Instantce
     @objc static let shared = AdamAudioPlayer()
    

    private override init() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback)
            try session.setActive(true)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    private func returnAudioFile(fileName: String, inDocuments: Bool = false)-> String? {
        let fixedFileName = fileName.trimmingCharacters(in: .whitespacesAndNewlines)
        var soundFileComponents = fixedFileName.components(separatedBy: ".")
        if soundFileComponents.count == 1 {
            print("error")
        }
        if (inDocuments) {
            let caches = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0])
            let myurl = "\(caches)/\(fileName)"
            return myurl
        } else {
            guard let path = Bundle.main.path(forResource: soundFileComponents[0], ofType: soundFileComponents[1]) else {
                return nil
            }
            return path
        }
    }
    
    @objc public func play(identifier: String, fileName: String?, inDocuments: Bool = false) {
        if (!UserDefaults.standard.contains(key: identifier) && (fileName != nil)){
            // We havent stored this sound so we can go ahead and call it
            var player: AVAudioPlayer?
            if player == nil {
                do {
                    let resource = self.returnAudioFile(fileName: fileName!, inDocuments: inDocuments)
                    if (resource != nil) {
                        player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: resource!))
                        container[identifier] = player
                        guard let player = player else { return }
                        player.delegate = self
                        player.numberOfLoops = -1
                        player.play()
                        print("adamPlayer playing \(identifier)")
                        container[identifier] = player
                        UserDefaults.standard.set(1, forKey: identifier)
                    } else {
                        print("adamPlayer error file not found")
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        } else {
            // we have it already so play it from stored
            if let player = container[identifier] {
                player.play()
                print("adamPlayer playing \(identifier)")
            } else {
                UserDefaults.standard.removeObject(forKey: identifier)
                self.play(identifier: identifier, fileName: fileName)
                print("adamPlayer playing \(identifier)")
            }
        }
    }
    
    // This kills the object fyi
    @objc public func stopSound(identifier: String) {
        if (UserDefaults.standard.contains(key: identifier)){
            if let player = container[identifier] {
                player.stop()
                print("adamPlayer stoped \(identifier)")
                UserDefaults.standard.removeObject(forKey: identifier)
                container.removeValue(forKey: identifier)
            }
        }
    }
    
    
    // this just pauses the sound but keeps the object
    @objc public func pauseSound(identifier: String) {
        if (UserDefaults.standard.contains(key: identifier)){
            if let player = container[identifier] {
                player.pause()
                print("adamPlayer Paused \(identifier)")
            }
        }
    }
    
    // this just pauses the sound but keeps the object
   @objc public func pauseAll() {
        for (_, players) in container {
            players.pause()
        }
        print("adamPlayer Paused all")
    }
    
    // this just pauses the sound but keeps the object
    @objc public func resumeAll() {
        for (_, players) in container {
            players.play()
        }
        print("adamPlayer resumed all")
    }
    
     // This kills all the players
   @objc public func stopAll() {
        for (key, players) in container {
            players.stop()
            UserDefaults.standard.removeObject(forKey: key)
            container.removeValue(forKey: key)
        }
    print("adamPlayer stopped all")
    }
    
    @objc public func whatsPlaying()-> Array<String>  {
        let componentArray = Array(container.keys)
        return componentArray
    }
    
    @objc public func changeVolumeOfAll(volume: Float) {
        for (_, players) in container {
            players.setVolume(volume, fadeDuration: 0)
        }
    }
    
   @objc public func changeVolumeOf(identifier: String, volume: Float) {
        if (UserDefaults.standard.contains(key: identifier)){
            if let player = container[identifier] {
                player.setVolume(volume, fadeDuration: 0)
            }
        }
    }
    
    @objc public func isPlayingWith(identifier: String)->Bool {
        var thisIsPlaying = false
        if (UserDefaults.standard.contains(key: identifier)){
            if let player = container[identifier] {
                thisIsPlaying = player.isPlaying
            }
        }
        return thisIsPlaying
    }
}

extension UserDefaults {
    func contains(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
}
