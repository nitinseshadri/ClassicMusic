//
//  ContentView.swift
//  ClassicMusic
//
//  Created by Nitin Seshadri on 6/10/21.
//

import SwiftUI
import UIKit
import MediaPlayer
import CoreTelephony

struct ContentView: View {
    var carrierName: String {
        get {
            #if targetEnvironment(macCatalyst)
            "iPod"
            #else
            if let providers = CTTelephonyNetworkInfo().serviceSubscriberCellularProviders {
                for provider in providers {
                    // Get the first non-null carrier name
                    // This may not be the first provider in the list of providers, so we need to check each one.
                    // An eSIM that is not configured has a null carrier name.
                    if let carrierName = provider.value.carrierName {
                        return carrierName
                    }
                }
                return "No SIM"
            } else {
                return "No SIM"
            }
            #endif
        }
    }
    var networkType: String {
        get {
            #if targetEnvironment(macCatalyst)
            "Wi-Fi"
            #else
            carrierName == "No SIM" ? "" : "3G"
            #endif
        }
    }
    
    var timeFormatter: DateFormatter {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a"
            return formatter
        }
    }
    @State var date: Date = Date()
    
    let systemMusicPlayer = MPMusicPlayerController.systemMusicPlayer
    @State var song: MPMediaItem?
    let formatter = DateComponentsFormatter()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let songPublisher = NotificationCenter.default
            .publisher(for: .MPMusicPlayerControllerNowPlayingItemDidChange)
    let mediaPublisher = NotificationCenter.default
            .publisher(for: .MPMusicPlayerControllerPlaybackStateDidChange) //MPMusicPlayerControllerPlaybackStateDidChange
    
    @State var scaleFactor: Double = 1.0
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.black)
                .frame(width: 320, height: 568)
            
            VStack(spacing: 0)  {
                
                // Status bar
                ZStack {
                    Rectangle()
                        .fill(Color.black.opacity(0.65))
                    HStack {
                        Text(carrierName)
                        if (networkType == "Wi-Fi") {
                            Image(systemName: "wifi")
                        } else {
                            Text(networkType)
                        }
                        Spacer()
                        Text(timeFormatter.string(from: date))
                        Spacer()
                        Text("\(Int(UIDevice.current.batteryLevel * 100))%")
                            .offset(x: 10)
                        BatteryView(battery: UIDevice.current.batteryLevel, charging: UIDevice.current.batteryState != .unplugged)
                            .offset(x: 5)
                    }
                    .font(Font.custom("Helvetica Neue Bold", size: 13))
                    .foregroundColor(Color.init(red: 190/255, green: 190/255, blue: 190/255))
                    .padding([.leading, .trailing], 4)
                }
                .frame(width: 320, height: 20)
                
                // Title bar
                ZStack {
                    Image(uiImage: UIImage(named: "NowPlayingNavBar")!)
                        .resizable()
                    VStack {
                        Image(uiImage: UIImage(named: "NowPlayingTransportHighlight")!)
                        Spacer()
                    }
                    VStack(spacing: 0) {
                        Spacer()
                        Text(song?.artist ?? "").font(.custom("Helvetica Neue Bold", size: 12)).foregroundColor(Color(red: 159/255, green: 159/255, blue: 159/255)).shadow(color: Color.black.opacity(0.8), radius: 0, x: 0.0, y: -1).multilineTextAlignment(.center).lineLimit(1)
                        Text(song?.title ?? "").font(.custom("Helvetica Neue Bold", size: 12)).foregroundColor(.white).shadow(color: Color.black.opacity(0.8), radius: 0, x: 0.0, y: -1).multilineTextAlignment(.center).lineLimit(1)
                        Text(song?.albumTitle ?? "").font(.custom("Helvetica Neue Bold", size: 12)).foregroundColor(Color(red: 159/255, green: 159/255, blue: 159/255)).shadow(color: Color.black.opacity(0.8), radius: 0, x: 0.0, y: -1).multilineTextAlignment(.center).lineLimit(1)
                        Spacer()
                    }
                    .frame(width: 320, height: 44)
                }
                .frame(width: 320, height: 44)
                
                // Transport controls
                ZStack {
                    Image(uiImage: UIImage(named: "NowPlayingNavBar")!)
                        .resizable()
                    VStack {
                        Image(uiImage: UIImage(named: "NowPlayingTransportHighlight")!)
                        Spacer()
                        Image(uiImage: UIImage(named: "NowPlayingTransportHighlight")!)
                    }
                    ZStack {
                        VStack {
                            Spacer()
                            HStack {
                                Button(action: {
                                    if (systemMusicPlayer.repeatMode == .none) {
                                        systemMusicPlayer.repeatMode = .all
                                    } else if (systemMusicPlayer.repeatMode == .all) {
                                        systemMusicPlayer.repeatMode = .one
                                    } else if (systemMusicPlayer.repeatMode == .one) {
                                        systemMusicPlayer.repeatMode = .none
                                    }
                                }) {
                                    if (systemMusicPlayer.repeatMode == .none) {
                                        Image(uiImage: UIImage(named: "RepeatOff")!)
                                    } else if (systemMusicPlayer.repeatMode == .all) {
                                        Image(uiImage: UIImage(named: "RepeatAll")!)
                                    } else if (systemMusicPlayer.repeatMode == .one) {
                                        Image(uiImage: UIImage(named: "RepeatOne")!)
                                    } else {
                                        Image(uiImage: UIImage(named: "RepeatOff")!)
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                                Spacer()
                                Button(action: {
                                    systemMusicPlayer.shuffleMode = systemMusicPlayer.shuffleMode == .off ? .songs : .off
                                }) {
                                    if (systemMusicPlayer.shuffleMode == .off) {
                                        Image(uiImage: UIImage(named: "ShuffleOff")!)
                                    } else if (systemMusicPlayer.shuffleMode == .songs) {
                                        Image(uiImage: UIImage(named: "ShuffleOn")!)
                                    } else if (systemMusicPlayer.shuffleMode == .albums) {
                                        Image(uiImage: UIImage(named: "ShuffleOn")!)
                                    } else {
                                        Image(uiImage: UIImage(named: "ShuffleOff")!)
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .padding(.bottom, 12)
                        }
                        VStack {
                            Spacer()
                            HStack() {
                                Text(formatter.string(from: systemMusicPlayer.currentPlaybackTime)!)
                                    .font(.custom("Helvetica Neue Bold", size: 12).monospacedDigit()).foregroundColor(Color(red: 159/255, green: 159/255, blue: 159/255)).shadow(color: Color.black.opacity(0.8), radius: 0, x: 0.0, y: -1)
                                    .offset(y: -4)
                                TiltReflectionSliderView(size: .small, value: Binding(get: {
                                    Float(systemMusicPlayer.currentPlaybackTime)
                                }, set: { (newValue) in
                                    DispatchQueue.main.async {
                                        systemMusicPlayer.currentPlaybackTime = TimeInterval(newValue)
                                    }
                                }), minimumValue: 0, maximumValue: Binding(get: {
                                    Float((song?.playbackDuration ?? 0))
                                }, set: { (newValue) in
                                    // Nothing to do.
                                }), hasContinuousUpdates: false, animateChanges: false)
                                Text(formatter.string(from: systemMusicPlayer.currentPlaybackTime - (song?.playbackDuration ?? 0))!)
                                    .font(.custom("Helvetica Neue Bold", size: 12).monospacedDigit()).foregroundColor(Color(red: 159/255, green: 159/255, blue: 159/255)).shadow(color: Color.black.opacity(0.8), radius: 0, x: 0.0, y: -1)
                                    .offset(y: -4)
                            }
                            Spacer()
                        }
                    }
                    
                    .padding([.leading, .trailing], 18)
                }
                .frame(width: 320, height: 89)
                
                // Album art
                ZStack {
                    Spacer()
                    AlbumArtView(mediaItem: Binding(get: {
                        song
                    }, set: { (newValue) in
                        
                    }))
                }
                .frame(width: 320, height: 320)
                
                
                // Play/Pause/Rewind/Forward controls
                ZStack {
                    Image(uiImage: UIImage(named: "NowPlayingTransportBG")!)
                        .resizable()
                    VStack {
                        Image(uiImage: UIImage(named: "NowPlayingTransportHighlight")!)
                        Spacer()
                    }
                    Image(uiImage: UIImage(named: "NowPlayingTransportHighlightLeft")!)
                    Image(uiImage: UIImage(named: "NowPlayingTransportHighlightRight")!)
                    HStack(spacing: 0) {
                        Button(action: {
                            if (systemMusicPlayer.currentPlaybackTime < TimeInterval(5)) {
                                systemMusicPlayer.skipToPreviousItem()
                            } else {
                                systemMusicPlayer.skipToBeginning()
                            }
                        }) {
                            Spacer()
                            Image(uiImage: UIImage(named: "Previous")!)
                            Spacer()
                        }
                        .buttonStyle(PlainButtonStyle())
                        Image(uiImage: UIImage(named: "NowPlayingTransportDivider")!)
                        Button(action: {
                            if (systemMusicPlayer.playbackState == .playing) {
                                systemMusicPlayer.pause()
                            } else {
                                systemMusicPlayer.play()
                            }
                        }) {
                            Spacer()
                            Image(uiImage: UIImage(named: systemMusicPlayer.playbackState == .playing ? "Pause" : "Play")!)
                            Spacer()
                        }
                        .buttonStyle(PlainButtonStyle())
                        Image(uiImage: UIImage(named: "NowPlayingTransportDivider")!)
                        Button(action: {
                            systemMusicPlayer.skipToNextItem()
                        }) {
                            Spacer()
                            Image(uiImage: UIImage(named: "Next")!)
                            Spacer()
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .frame(width: 320, height: 46)
                
                // Volume bar
                ZStack {
                    Image(uiImage: UIImage(named: "NowPlayingTransportBG")!)
                        .resizable()
                    VStack {
                        Spacer()
                        VolumeView()
                            .padding([.leading, .trailing], 48)
                        Spacer()
                    }
                }
                .frame(width: 320, height: 49)
                
            }
            .foregroundColor(.white)
            .accentColor(Color.init(red: 208/255, green: 208/255, blue: 208/255))
            .background(Color.black)
            .frame(width: 320, height: 568)
            .statusBar(hidden: true)
            .onAppear {
                // Time formatter
                formatter.unitsStyle = .positional
                formatter.allowedUnits = [ .minute, .second ]
                formatter.zeroFormattingBehavior = [ .pad ]
                
                UIDevice.current.isBatteryMonitoringEnabled = true
                updateUI()
            }
            .onReceive(timer) { _ in
                updateUI()
            }
            .onReceive(songPublisher) { (output) in
                updateUI()
            }
            .onReceive(mediaPublisher) { (output) in
                updateUI()
            }
        }
        .onTapGesture(count: 3) {
            withAnimation(.default) {
                if (scaleFactor == 1.0) {
                    #if targetEnvironment(macCatalyst)
                    // Scale to fit window height
                    let screenHeight = UIScreen.main.bounds.height
                    scaleFactor = screenHeight / 568
                    #else
                    // Scale to fit device's screen width
                    let screenWidth = UIScreen.main.bounds.width
                    scaleFactor = screenWidth / 320
                    #endif
                } else {
                    // Original scale
                    scaleFactor = 1.0
                }
            }
        }
        .scaleEffect(scaleFactor)
    }
    
    func updateUI() {
        DispatchQueue.main.async {
            date = Date()
            song = systemMusicPlayer.nowPlayingItem
        }
    }
}
