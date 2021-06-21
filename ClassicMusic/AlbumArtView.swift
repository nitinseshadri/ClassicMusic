//
//  AlbumArtView.swift
//  ClassicMusic
//
//  Created by Nitin Seshadri on 6/17/21.
//

import SwiftUI
import UIKit
import MediaPlayer

struct AlbumArtView: UIViewRepresentable {
    
    @Binding var mediaItem: MPMediaItem?
    
    func makeUIView(context: Context) -> NSXAlbumArtView {
        let albumArtView = NSXAlbumArtView(frame: .zero, defaultFrontImage: UIImage(named: "MusicNoArtPlaceholder")!, defaultBackImage: UIImage(named: "NowPlayingTableBackground")!)
        albumArtView.transitionDuration = 0.75
        albumArtView.mediaItem = mediaItem
        return albumArtView
    }
    
    func updateUIView(_ view: NSXAlbumArtView, context: Context) {
        view.mediaItem = mediaItem
    }
}

class NSXAlbumArtView: UIView {
    
    private let systemMusicPlayer = MPMusicPlayerController.systemMusicPlayer
    
    private var frontView: UIImageView!
    private var defaultFrontImage: UIImage!
    private var backView: UIImageView!
    private var defaultBackImage: UIImage!
    
    public var transitionDuration = 0.75
    public var mediaItem: MPMediaItem? {
        didSet {
            frontView.image = mediaItem?.artwork?.image(at: CGSize(width: 400, height: 400)) ?? defaultFrontImage
        }
    }
    
    // MARK: Init methods
    
    init(frame: CGRect, defaultFrontImage: UIImage, defaultBackImage: UIImage) {
        super.init(frame: frame)
        self.defaultFrontImage = defaultFrontImage
        self.defaultBackImage = defaultBackImage
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSXAlbumArtView cannot be initialized with initWithCoder. Use initWithFrame instead.")
    }
    
    // MARK: Custom view methods
    
    @objc public func flipToBack() {
        let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
        
        UIView.transition(from: frontView, to: backView, duration: transitionDuration, options: transitionOptions, completion: nil)
    }
    
    @objc public func flipToFront() {
        let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromLeft, .showHideTransitionViews]
        
        UIView.transition(from: backView, to: frontView, duration: transitionDuration, options: transitionOptions, completion: nil)
    }
    
    private func setupView() {
        self.frontView = UIImageView(image: defaultFrontImage)
        frontView.frame = CGRect(x: 0, y: 0, width: 320, height: 320)
        
        self.backView = UIImageView(image: defaultBackImage)
        backView.frame = CGRect(x: 0, y: 0, width: 320, height: 320)
        
        frontView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(flipToBack)))
        frontView.isUserInteractionEnabled = true
        backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(flipToFront)))
        backView.isUserInteractionEnabled = true
        
        backView.isHidden = true
        
        self.addSubview(frontView)
        self.addSubview(backView)
    }
}

struct AlbumArtView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumArtView(mediaItem: Binding(get: {
            MPMusicPlayerController.systemMusicPlayer.nowPlayingItem
        }, set: { (newValue) in
            
        }))
    }
}
