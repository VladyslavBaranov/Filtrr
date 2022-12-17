//
//  PaywallVideoView.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 09.05.2022.
//

import SwiftUI
import AVKit

enum PlayerGravity {
    case aspectFill
    case resize
}

class PlayerView: UIView {
    
    var player: AVQueuePlayer? {
        get {
            return playerLayer.player as? AVQueuePlayer
        }
        set {
            playerLayer.player = newValue
        }
    }
    
    let gravity: PlayerGravity
    
    init(player: AVQueuePlayer, gravity: PlayerGravity) {
        self.gravity = gravity
        super.init(frame: .zero)
        self.player = player
        self.backgroundColor = .appDark
        setupLayer()
    }
    
    func setupLayer() {
        playerLayer.backgroundColor = UIColor.appDark.cgColor
        switch gravity {
    
        case .aspectFill:
            playerLayer.contentsGravity = .resizeAspectFill
            playerLayer.videoGravity = .resizeAspectFill
            
        case .resize:
            playerLayer.contentsGravity = .resize
            playerLayer.videoGravity = .resize
            
        }
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    // Override UIView property
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
}

struct PlayerContainerView: UIViewRepresentable {
    typealias UIViewType = PlayerView
    
    let player: AVQueuePlayer
    
    let gravity: PlayerGravity
    
    init(player: AVQueuePlayer, gravity: PlayerGravity) {
        self.player = player
        self.gravity = gravity
    }
    
    func makeUIView(context: Context) -> PlayerView {
        return PlayerView(player: player, gravity: gravity)
    }
    
    func updateUIView(_ uiView: PlayerView, context: Context) { }
} 

class PlayerViewModel: ObservableObject {

    let player: AVQueuePlayer
    var playerLooper: AVPlayerLooper?
    
    init(fileName: String) {
        let url = Bundle.main.url(forResource: fileName, withExtension: "mp4")
        self.player = AVQueuePlayer(playerItem: AVPlayerItem(url: url!))
        playerLooper = AVPlayerLooper(player: player, templateItem: player.items()[0])
        self.play()
    }
    
    func play() {
        let currentItem = player.currentItem
        if currentItem?.currentTime() == currentItem?.duration {
            currentItem?.seek(to: .zero, completionHandler: nil)
        }
        player.play()
    }
    
    func pause() {
        player.pause()
    }
    
}
