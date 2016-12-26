//
//  TempoManager.swift
//  PACRun
//
//  Created by 馮仰靚 on 26/12/2016.
//  Copyright © 2016 YC. All rights reserved.
//

import Foundation

import AVFoundation

var player: AVAudioPlayer?

class TempoManager{
    func playSound() {
        let url = Bundle.main.url(forResource: "TempoOne", withExtension: "aif")!
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            player.numberOfLoops = -1

            player.prepareToPlay()
            player.enableRate = true
            player.rate = 1.5
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }

}
