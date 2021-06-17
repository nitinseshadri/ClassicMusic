//
//  BatteryView.swift
//  ClassicMusic
//
//  Created by Nitin Seshadri on 6/17/21.
//

import SwiftUI

struct BatteryView: View {
    var battery = Float()
    var charging = Bool()
    let rect = CGRect(x: 0, y: 0, width: 17, height: 6.5)
    var body: some View {
        HStack {
            ZStack {
                Rectangle()
                    .overlay(
                        RoundedRectangle(cornerRadius:0.25)
                            .stroke(Color.init(red: 190/255, green: 190/255, blue: 190/255), lineWidth: 1.25)
                    )
                    .foregroundColor(.clear)
                    .frame(width: 23.0, height: 12.25)
                Rectangle()
                    .frame(width: 18.5*CGFloat(battery), height: 8)
                    .foregroundColor(battery <= 0.20 ? .red : Color.init(red: 190/255, green: 190/255, blue: 190/255))
                    .offset(x:(-18.5/2)+(18.5/2)*CGFloat(battery))
                    .overlay (
                        ZStack {
                            Image(systemName:"bolt.fill")
                                .resizable()
                                .frame(width: 8, height: 7)
                        }
                        .frame(width: 18.5*CGFloat(battery), height: 8)
                        .foregroundColor(.black)
                        .background(Color.white)
                        .compositingGroup()
                        .luminanceToAlpha()
                        .opacity(charging ? 1 : 0)
                    )
            }
            Rectangle().overlay(RoundedRectangle(cornerRadius:0.25).stroke(Color.init(red: 190/255, green: 190/255, blue: 190/255), lineWidth: 1)).foregroundColor(.clear).frame(width: 3, height: 5).offset(x:-7.95)
        }
    }
}

struct BatteryView_Previews: PreviewProvider {
    static var previews: some View {
        BatteryView()
    }
}
