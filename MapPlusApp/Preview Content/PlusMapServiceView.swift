//
//  PlusMapServiceView.swift
//  
//
//  Created by Daeho Kim on 09.03.21.
//

import Foundation
import SwiftUI

struct PlusMapServiceView: View {
    //    @State var titleIds: [Int]
    //    @State var digitalMapI d: String = ""
    //    @State var apiKey: String?
    //    @State var customerId: String?
    
    @StateObject var plusMapService = PlusMapService()
    
    var body: some View {
        VStack(spacing: 60) {
            Button(action: {
                plusMapService.updateMapTiles(textInput: "MapTiles?tileIds=432345566760927436;432345566777704652;432345566760927437;432345566777704653;432345566760927435;432345566744150220&digitalMapId=NT-Germany&apiKey=&customerId=")
            }) {
                Text("Maptiles")
            }
            
            Button(action: {
                plusMapService.updateAvailableMap(textInput: "AvailableMap?culture=1031&apiKey=&customerId=")
            }) {
                Text("AvailableMap")
            }
            
        }
    }
}


