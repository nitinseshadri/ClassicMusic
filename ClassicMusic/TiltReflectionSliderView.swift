//
//  VolumeSliderView.swift
//  ClassicMusic
//
//  Created by Nitin Seshadri on 4/25/23.
//

import SwiftUI
import UIKit

struct TiltReflectionSliderView: UIViewRepresentable {
    
    enum TiltReflectionSliderSize {
        case small
        case regular
    }
    
    @State var size: TiltReflectionSliderSize
    
    @Binding var value: Float
    
    @State var minimumValue: Float
    
    @Binding var maximumValue: Float
    
    @State var hasContinuousUpdates: Bool = false
    
    @State var animateChanges: Bool = false
    
    func makeUIView(context: Context) -> MTZTiltReflectionSlider {
        let slider = MTZTiltReflectionSlider(frame: .zero)
        slider.size = {
            switch (size) {
            case .regular:
                return MTZTiltReflectionSliderSizeRegular
            case .small:
                return MTZTiltReflectionSliderSizeSmall
            }
        }()
        slider.minimumValue = minimumValue
        slider.maximumValue = maximumValue
        slider.value = value
        slider.isContinuous = hasContinuousUpdates
        slider.addAction(UIAction { _ in
            value = slider.value
        }, for: .valueChanged)
        slider.startMotionDetection()
        return slider
    }
    
    func updateUIView(_ view: MTZTiltReflectionSlider, context: Context) {
        view.minimumValue = minimumValue
        view.maximumValue = maximumValue
        view.setValue(value, animated: animateChanges)
    }
}
