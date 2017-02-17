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


    var setRate : Float? = 1

    func playSound() {
        let url = Bundle.main.url(forResource: "TempoFour", withExtension: "mp3")!
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            player.numberOfLoops = -1

            player.prepareToPlay()
            player.enableRate = true
            player.rate = self.setRate!
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }

}
