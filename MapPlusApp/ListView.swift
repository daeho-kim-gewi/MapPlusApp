//
//  ListView.swift
//  MapPlusApp
//
//  Created by Daeho Kim on 05.05.21.
//

import SwiftUI

struct ListVerticalView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack {    // VStack list
                HStack {     // Top Button HStack
                    Button(action: {}, label: {
                        Image("ChevronLeft")
                            .foregroundColor(Color.highlightColorLinkFontColor)
                            .frame(width: 22, height: 22)
                    })
                    .buttonStyle(ListBtnStyle())
                    Spacer()
                    
                    HStack (alignment: .bottom, spacing: 20) {
                        Button(action: {}, label: {
                            Image("Plus")
                                .foregroundColor(Color.highlightColorLinkFontColor)
                                .frame(width: 22, height: 22)
                        })
                        .buttonStyle(ListBtnStyle())
                        
                        Button(action: {}, label: {
                            Image("EllipsisH")
                                .foregroundColor(Color.highlightColorLinkFontColor)
                                .frame(width: 22, height: 22)
                        })
                        .buttonStyle(ListBtnStyle())
                    }
                }   // Top Button HStack
                .padding(.top, 20)
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .padding(.bottom, 10)
                
                ListItemVerticalView()
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                    
            }   // VStack list
            .frame(width: geometry.size.width * 0.95, height: geometry.size.height * 0.45)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous).fill(Color.contentContainer)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(Color.borderColor, lineWidth: 1)
            )
            .position(x: geometry.size.width / 2, y: geometry.size.height / 3)
        }   // Geometry
    }   // listView
}

struct ListBtnStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .contentShape(RoundedRectangle(cornerRadius: 8))
            .background(
                Group {
                    if configuration.isPressed {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.mouseOverPressedFocusedBackgroundColor)
                            .frame(width: 38, height: 38)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .contentShape(RoundedRectangle(cornerRadius: 8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .strokeBorder(Color.borderColor, lineWidth: 1)
                            )
                    } else {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.headerContainerBackgroundColor)
                            .frame(width: 38, height: 38)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .contentShape(RoundedRectangle(cornerRadius: 8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .strokeBorder(Color.borderColor, lineWidth: 1)
                            )
                    }
                }
            )
    }
}

struct ListHorizontalView: View {
    var body: some View {
        GeometryReader { geometry in
            HStack {
                VStack {    // VStack list
                    
                    // Top button
                    HStack {     // Top Button HStack
                        Button(action: {}, label: {
                            Image("ChevronLeft")
                                .foregroundColor(Color.highlightColorLinkFontColor)
                                .frame(width: 22, height: 22)
                        })
                        .buttonStyle(ListBtnStyle())
                        Spacer()
                        
                        HStack (alignment: .bottom, spacing: 10) {
                            Button(action: {}, label: {
                                Image("Plus")
                                    .foregroundColor(Color.highlightColorLinkFontColor)
                                    .frame(width: 22, height: 22)
                            })
                            .padding(4)
                            .buttonStyle(ListBtnStyle())
                            
                            Button(action: {}, label: {
                                Image("EllipsisH")
                                    .foregroundColor(Color.highlightColorLinkFontColor)
                                    .frame(width: 22, height: 22)
                            })
                            .padding(4)
                            .buttonStyle(ListBtnStyle())
                        }
                    }       // Top Button HStack
                    .padding(.top, 20)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    .padding(.bottom, 10)
                    
                    ListItemHorizontalView()
                        .padding(.bottom, 20)
                    
                }   // VStack list
                .frame(width: geometry.size.width * 0.45, height: geometry.size.height * 0.95)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous).fill(Color.contentContainer)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .strokeBorder(Color.borderColor, lineWidth: 1)
                )
                .position(x: geometry.size.width / 4 , y: geometry.size.height / 2)
            }   // HStack
            .padding(.leading, 45)
            
        }   // Geometry
    }   // listView
}

struct ListViewPreview: PreviewProvider {
    static var previews: some View {
        Group {
            ListVerticalView()
                .previewDevice("iPhone 12 mini")
            ListVerticalView()
                .previewDevice("iPad Pro (11-inch) (3rd generation)")
        }
    }
}
