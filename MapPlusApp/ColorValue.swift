//
//  ColorValue.swift
//  MapPlusApp
//
//  Created by Daeho Kim on 30.04.21.
//

import SwiftUI
import Foundation

// Update 5 (28.01.2021)
extension Color {
    static let Black = Color(red: 0 / 255, green: 0 / 255, blue: 0 / 255)     // 000000
    static let BlueCharcoal = Color(red: 0 / 255, green: 9 / 255, blue: 26 / 255)   // 00091A
    static let Scorpion = Color(red: 94 / 255, green: 94 / 255, blue: 94 / 255)     // #5E5E5E
    static let Raven = Color(red: 116 / 255, green: 124 / 255, blue: 140 / 255)     // #747C8C
    static let Silver = Color(red: 204 / 255, green: 204 / 255, blue: 204 / 255)    // #CCCCCC
    static let Pampas = Color(red: 244 / 255, green: 242 / 255, blue: 240 / 255)    // #F4F2F0
    static let CatskillWhite = Color(red: 245 / 255, green: 247 / 255, blue: 250 / 255) // #F5F7FA
    static let White = Color(red: 255 / 255, green: 255 / 255, blue: 255 / 255)     // #FFFFFF
    static let BayOfMany = Color(red: 33 / 255, green: 66 / 255, blue: 133 / 255)   //#214285
    static let CeruleanBlue = Color(red: 43 / 255, green: 87 / 255, blue: 173 / 255) // #2B57AD
    static let Mariner = Color(red: 51 / 255, green: 102 / 255, blue: 204 / 255)    // #3366CC
    static let LinkWater = Color(red: 235 / 255, green: 240 / 255, blue: 250 / 255) // #EBF0FA
    static let FunGreen = Color(red: 0 / 255, green: 140 / 255, blue: 24 / 255)     // #008C18
    static let FunGreen2 = Color(red: 0 / 255, green: 166 / 255, blue: 28 / 255)    // #00A61C
    static let Malachite = Color(red: 19 / 255, green: 191 / 255, blue: 48 / 255)   // #13BF30
    static let Tara = Color(red: 223 / 255, green: 247 / 255, blue: 227 / 255)      // #DFF7E3
    static let BrightRed = Color(red: 179 / 255, green: 0 / 255, blue: 0 / 255)     // #B30000
    static let GuardsmanRed = Color(red: 217 / 255, green: 0 / 255, blue: 0 / 255)  // #D90000
    static let Red = Color(red: 255 / 255, green: 0 / 255, blue: 0 / 255)           // #FF0000
    static let Pippin = Color(red: 255 / 255, green: 229 / 255, blue: 229 / 255)    // #FFE5E5
    static let Turbo = Color(red: 255 / 255, green: 225 / 255, blue: 0 / 255)       // #FFE100
    static let Picasso = Color(red: 255 / 255, green: 243 / 255, blue: 153 / 255)   // #FFF399
    static let EbonyClay = Color(red: 35 / 255, green: 40 / 255, blue: 51 / 255)    // #232833
    static let Charade = Color(red: 44 / 255, green: 49 / 255, blue: 59 / 255)      // #2C313B
    static let Mako = Color(red: 58 / 255, green: 65 / 255, blue: 79 / 255)         // #3A414F
    static let BrightGray = Color(red: 57 / 255, green: 64 / 255, blue: 77 / 255)   // #39404D
    static let Abbey = Color(red: 85 / 255, green: 89 / 255, blue: 94 / 255)        // #55595E
    static let Trout = Color(red: 82 / 255, green: 88 / 255, blue: 102 / 255)       // #525866
    static let Casper = Color(red: 173 / 255, green: 188 / 255, blue: 204 / 255)    // #ADBCCC
    static let Azure = Color(red: 46 / 255, green: 101 / 255, blue: 163 / 255)      // #2E65A3
    static let RoyalBlue = Color(red: 64 / 255, green: 140 / 255, blue: 225 / 255)  // #408CE1
    static let DodgerBlue = Color(red: 71 / 255, green: 155 / 255, blue: 250 / 255) // #479BFA
    static let OuterSpace = Color(red: 42 / 255, green: 63 / 255, blue: 58 / 255)   // #2A3F3A
    static let MediumCarmine = Color(red: 171 / 255, green: 54 / 255, blue: 54 / 255) // #AB3636
    static let FlushMahogany = Color(red: 207 / 255, green: 65 / 255, blue: 65 / 255) // #CF4141
    static let SunsetOrange = Color(red: 255 / 255, green: 77 / 255, blue: 77 / 255)    // #FF4D4D
    static let CongoBrown = Color(red: 84 / 255, green: 54 / 255, blue: 62 / 255)   // #54363E
    static let Hemlock  = Color(red: 85 / 255, green: 85 / 255, blue: 61 / 255)     // #55553D
    
    static var borderColor: Color {
        return Color("BorderColor")
    }
    
    static var contentContainer: Color {
        return Color("ContentContainer, InputFields")
    }
    
    static var criticalBackgroundColor: Color {
        return Color("CriticalBackgroundColor")
    }
    
    static var criticalColorNotificationColor: Color {
        return Color("CriticalColor, NotificationColor")
    }
    
    static var headerContainerBackgroundColor: Color {
        return Color("HeaderContainer-BackgroundColor")
    }
    
    static var highlightColorLinkFontColor: Color {
        return Color("HighlightColor, Link-FontColor")
    }
    
    static var labelFontColor: Color {
        return Color("Label-FontColor")
    }
    
    static var linkFontColor: Color {
        return Color("Link-FontColor")
    }
    
    static var linkFontColor2: Color {
        return Color("Link-FontColor2")
    }
    
    static var mouseOverPressedFocusedBackgroundColor: Color {
        return Color("MouseOver,Pressed,Focused-BackgroundColor")
    }
    
    static var noCriticalbackgroundColor: Color {
        return Color("NoCriticalBackgroundColor")
    }
    
    static var notificationColor: Color {
        return Color("NotificationColor")
    }
    
    static var notificationColor2: Color {
        return Color("NotificationColor2")
    }
    
    static var valueFontColor: Color {
        return Color("Value-FontColor")
    }
}
