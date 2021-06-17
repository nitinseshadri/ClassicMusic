//
//  VolumeView.swift
//  ClassicMusic
//
//  Created by Nitin Seshadri on 6/17/21.
//

import SwiftUI
import UIKit
import MediaPlayer

struct VolumeView: UIViewRepresentable {
    
    static private let tiltSlider = TLTiltSlider(frame: .zero)
    
    func makeUIView(context: Context) -> MPVolumeView {
        let volumeView = MPVolumeView(frame: .zero)
        volumeView.setMinimumVolumeSliderImage(UIImage(named: "highlightedBarBackground")!.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)), for: .normal)
        volumeView.setMaximumVolumeSliderImage(UIImage(named: "trackBackground")!.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 4)), for: .normal)
        volumeView.setVolumeThumbImage(VolumeView.tiltSlider.currentThumbImage, for: .normal)
        volumeView.setRouteButtonImage(UIImage(named: "AirPlayOff")!, for: .normal)
        volumeView.setRouteButtonImage(UIImage(named: "AirPlayOn")!, for: .selected)
        return volumeView
    }
    
    func updateUIView(_ view: MPVolumeView, context: Context) {
        view.setVolumeThumbImage(VolumeView.tiltSlider.currentThumbImage, for: .normal)
    }
}


struct VolumeView_Previews: PreviewProvider {
    static var previews: some View {
        VolumeView()
    }
}
