//
//  MainView.swift
//  MapPlusApp
//
//  Created by Daeho Kim on 02.03.21.
//

import SwiftUI

struct MainView: View {
    @StateObject var mapCamera = MapCamera()
    @State private var isShowingList = true
    @State var heightSize = UIScreen.main.bounds.size.height
    @State var widthSize = UIScreen.main.bounds.size.width
    
//    @State private var rotation = UIDeviceOrientation.portrait
    
    @ViewBuilder
    private func getMapControls(mapCamera: MapCamera) -> some View {
        Group {
            // Vertical
            //if rotation.isPortrait || rotation.isFlat {
            GeometryReader { geometry in
                if geometry.size.width < 500 {
                    ZStack {
                        if isShowingList {
                            ListVerticalView()
                        }
                        VStack {
                            HStack {
                                Button {
                                    self.isShowingList.toggle()
                                } label: {
                                    Image("Bars")
                                        .frame(width: 38, height: 38)
                                }
                                .background(VisualEffectView())
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .contentShape(RoundedRectangle(cornerRadius: 12))
                                .padding(.top, heightSize / 30)
                                Spacer()
                            }
                            .padding()
                            
                            Spacer()
                            HStack {
                                Spacer()
                                
                                VStack(spacing: 16) {
                                    
                                    ForEach(zoomKey, id: \.self.key) { key in
                                        if key.key == 1 {           // ZoomIn
                                            Button {
                                                mapCamera.zoomIn()
                                            } label: {
                                                Image("\(key.zoomKey)")
                                                    .foregroundColor(Color.highlightColorLinkFontColor)
                                                    .frame(width: 22, height: 22)
                                            }
                                            .buttonStyle(ZoomBtnStyle())
                                        } else if key.key == 2 {    // ZoomOut
                                            Button {
                                                mapCamera.zoomOut()
                                            } label: {
                                                Image(key.zoomKey)
                                                    .foregroundColor(Color.highlightColorLinkFontColor)
                                                    .frame(width: 22, height: 22)
                                            }
                                            .buttonStyle(ZoomBtnStyle())
                                        }
                                    }
                                    .frame(width: 38, height: 38)
                                    //                    .background(VisualEffectView())
                                    //                    .clipShape(Circle())
                                    //                    .contentShape(Circle())
                                }
                                .padding(.bottom, 32)
                                .padding(.trailing, 8)
                            }
                        }
                    }
                }  else {
                    ZStack {
                        if isShowingList {
                            ListHorizontalView()
                        }
                        
                        VStack {
                            HStack {
                                Button {
                                    self.isShowingList.toggle()
                                } label: {
                                    Image("Bars")
                                        .frame(width: 38, height: 38)
                                }
                                .background(VisualEffectView())
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .contentShape(RoundedRectangle(cornerRadius: 12))
                                .padding(.top, heightSize / 30)
                                Spacer()
                            }
                            .padding()
                            
                            Spacer()
                            HStack {
                                Spacer()
                                
                                VStack(spacing: 16) {
                                    
                                    ForEach(zoomKey, id: \.self.key) { key in
                                        if key.key == 1 {           // ZoomIn
                                            Button {
                                                mapCamera.zoomIn()
                                            } label: {
                                                Image("\(key.zoomKey)")
                                                    .foregroundColor(Color.highlightColorLinkFontColor)
                                                    .frame(width: 22, height: 22)
                                            }
                                            .buttonStyle(ZoomBtnStyle())
                                        } else if key.key == 2 {    // ZoomOut
                                            Button {
                                                mapCamera.zoomOut()
                                            } label: {
                                                Image(key.zoomKey)
                                                    .foregroundColor(Color.highlightColorLinkFontColor)
                                                    .frame(width: 22, height: 22)
                                            }
                                            .buttonStyle(ZoomBtnStyle())
                                        }
                                    }
                                    .frame(width: 38, height: 38)
                                    //                    .background(VisualEffectView())
                                }
                                .padding(.bottom, 32)
                                .padding(.trailing, 32)
                            }
                        }
                    }
                }
            }   // Geometry
        }   // Group
//        .onRotate { newRotation in
//            rotation = newRotation
//        }
    }
    
    var body: some View {
        ZStack {
            MetalView(mapCamera: mapCamera)
            
            // Buttons
            getMapControls(mapCamera: mapCamera)
        }
        .ignoresSafeArea()
    }
    
    struct ZoomBtnStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .contentShape(RoundedRectangle(cornerRadius: 12))
                .background(
                    Group {
                        if configuration.isPressed {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.mouseOverPressedFocusedBackgroundColor)
                                .frame(width: 38, height: 38)
                                .clipShape(Circle())
                                .contentShape(Circle())
                        } else {
                            RoundedRectangle(cornerRadius: 12)
                                //.background(VisualEffectView())
                                .fill(Color.headerContainerBackgroundColor)
                                .frame(width: 38, height: 38)
                                .clipShape(Circle())
                                .contentShape(Circle())
                        }
                    }
                )
        }
    }
    
    var zoomKey: [(key: Int, zoomKey: String)] {
        return [(key: 1, zoomKey: "ZoomIn"),
                (key: 2, zoomKey: "ZoomOut")]
    }
}



struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainView()
                .previewDevice(/*@START_MENU_TOKEN@*/"iPhone 11"/*@END_MENU_TOKEN@*/)
                
            MainView()
                .previewDevice("iPad Pro (11-inch) (3rd generation)")
                
        }
    }
}

