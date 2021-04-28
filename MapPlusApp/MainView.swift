//
//  MainView.swift
//  MapPlusApp
//
//  Created by Daeho Kim on 02.03.21.
//

import SwiftUI

struct MainView: View {
    @StateObject var mapCamera = MapCamera()
    
    @ViewBuilder
    private func getMapControls(mapCamera: MapCamera) -> some View {
        VStack {
            
            HStack {
                Spacer()
                
                VStack(spacing: 16) {
                    
                    Button {
                        // TODO:
                        
                    } label: {
                        Image(systemName: "ellipsis")
                            .imageScale(.large)
                            .frame(width: 44, height: 44)
                    }
                    
                    .background(VisualEffectView())
                    .clipShape(Circle())
                    .contentShape(Circle())
                    .padding(.top, 64)
                    
                    Spacer()
                    
                    Button {
                        mapCamera.zoomIn()
                    } label: {
                        Image(systemName: "plus")
                            .imageScale(.large)
                            .frame(width: 44, height: 44)
                            
                    }
                    .background(VisualEffectView())
                    .clipShape(Circle())
                    .contentShape(Circle())
                    
                    
                    Button {
                        mapCamera.zoomOut()
                    } label: {
                        Image(systemName: "minus")
                            .imageScale(.large)
                            .frame(width: 44, height: 44)
                    }
                    .background(VisualEffectView())
                    .clipShape(Circle())
                    .contentShape(Circle())
                }
                .padding(.bottom, 32)
                .padding(.trailing, 8)
            }
            
        }
    }
    
    
    var body: some View {
        ZStack {
            MetalView(mapCamera: mapCamera)
            
            // Buttons
            getMapControls(mapCamera: mapCamera)
        }
        .ignoresSafeArea()
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
