//
//  ListItemView.swift
//  MapPlusApp
//
//  Created by Daeho Kim on 05.05.21.
//

import SwiftUI

public class SelectedItem: ObservableObject {
    @Published var seletedItem = 0
}


struct ListItemVerticalView: View {
    @StateObject var selectedItem = SelectedItem()
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                LazyVStack {    // total Item LazyVStack
                    ForEach(testData, id: \.self.key) { key in
                        Group {
                            if selectedItem.seletedItem != key.key {
                                
                                HStack(alignment: .center) { // One Item HStack
                                    VStack(alignment: .leading) {
                                        Text(key.title).bold()
                                            .font(Font.subheadline)
                                            .padding(.bottom, 2)
                                        
                                        Text(key.content).font(Font.caption2)
                                    }
                                    .frame(height: 76)
                                    .padding(8)
                                    
                                    Image("Empty")
                                        .frame(width: 38)
                                }
                                .frame(width: geometry.size.width, height: 76)
                                .background(RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                .fill(Color.headerContainerBackgroundColor)
                                                .shadow(color: Color.black.opacity(0.12), radius: 2, x: 0, y: 2))
                                .onTapGesture(count: 1, perform: {
                                    selectedItem.seletedItem = key.key
                                })
                                
                            } else {
                                
                                HStack(alignment: .center) { // One Item HStack
                                    VStack(alignment: .leading) {
                                        Text(key.title).bold()
                                            .font(Font.subheadline)
                                            .padding(.bottom, 2)
                                        
                                        Text(key.content).font(Font.caption2)
                                    }
                                    .frame(height: 76)
                                    .padding(8)
                                    
                                    VStack(alignment: .trailing) {  // Right two button VStack
                                        Button(action: {}, label: {
                                            Image("ChevronRight")
                                                .foregroundColor(Color.highlightColorLinkFontColor)
                                                .frame(width: 22, height: 22)
                                        })
                                        .frame(width: 38)
                                        .padding(.bottom, 4)
                                        .border(width: 1, edges: [.bottom], color: Color.borderColor)
                                        
                                        Button(action: {}, label: {
                                            Image("EllipsisH")
                                                .foregroundColor(Color.highlightColorLinkFontColor)
                                                .frame(width: 22, height: 22)
                                        })
                                        .frame(width: 38)
                                    }
                                    .frame(width: 38, height: 76)
                                    .border(width: 1, edges: [.leading], color: Color.borderColor)
                                
                                }
                                .frame(width: geometry.size.width, height: 76)
                                .background(RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                .fill(Color.mouseOverPressedFocusedBackgroundColor)
                                                .shadow(color: Color.black.opacity(0.12), radius: 2, x: 0, y: 2))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                        .strokeBorder(Color.borderColor, lineWidth: 1)
                                )
                                
                            }   // else
                        }   // Group
                    }   // ForEach
                }   // total Item LazyVStack
                .padding(.bottom, 10)
            } // ScrollView
        } // GeometryReader
    }
}

struct ListItemBtnStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                Group {
                    if configuration.isPressed {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.mouseOverPressedFocusedBackgroundColor)
                            .frame(width: 38, height: 38)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .contentShape(RoundedRectangle(cornerRadius: 8))
                            .padding(8)
                            
                    } else {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.headerContainerBackgroundColor)
                            .frame(width: 38, height: 38)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .contentShape(RoundedRectangle(cornerRadius: 8))
                            .padding(8)
                    }
                }
            )
    }
}
public var testData: [(key: Int, title: String, content: String)] {
    return [(key: 1, title: "Dogecoin",
             content: "도지코인[1](dogecoin)은 라이트코인을 바탕으로 하는, 도지(doge) 인터넷 밈을 마스코트로 채용한 암호화폐이다. 도지코인은 발행된 지 한 달만에 결제 횟수가 비트코인을 초과하였으며, 자메이카 봅슬레이 팀과 인도 루지 팀의 소치 올림픽 출전을 위한 기부금에도 사용되었다. "),
            (key: 2, title: "Bitcoin", content: "비트코인(영어: Bitcoin)은 블록체인 기술을 기반으로 만들어진 온라인 암호화폐이다. 비트코인의 화폐 단위는 BTC로 표시한다. 2008년 10월 사토시 나카모토라는 가명을 쓰는 프로그래머가 개발하여, 2009년 1월 프로그램 소스를 배포했다."),
            (key: 3, title: "Tesla", content: "테슬라 주식회사는 미국 캘리포니아주 팰로앨토에 기반을 둔 미국의 전기자동차와 청정 에너지 회사이다. 2003년, 마틴 에버하드와 마크 타페닝이 창업했다. 2004년 페이팔의 최고경영자이던 일론 머스크가 투자자로 참여했다."),
            (key: 4, title: "Dogecoin",
             content: "도지코인[1](dogecoin)은 라이트코인을 바탕으로 하는, 도지(doge) 인터넷 밈을 마스코트로 채용한 암호화폐이다. 도지코인은 발행된 지 한 달만에 결제 횟수가 비트코인을 초과하였으며, 자메이카 봅슬레이 팀과 인도 루지 팀의 소치 올림픽 출전을 위한 기부금에도 사용되었다. "),
            (key: 5, title: "Bitcoin", content: "비트코인(영어: Bitcoin)은 블록체인 기술을 기반으로 만들어진 온라인 암호화폐이다. 비트코인의 화폐 단위는 BTC로 표시한다. 2008년 10월 사토시 나카모토라는 가명을 쓰는 프로그래머가 개발하여, 2009년 1월 프로그램 소스를 배포했다."),
            (key: 6, title: "Tesla", content: "테슬라 주식회사는 미국 캘리포니아주 팰로앨토에 기반을 둔 미국의 전기자동차와 청정 에너지 회사이다. 2003년, 마틴 에버하드와 마크 타페닝이 창업했다. 2004년 페이팔의 최고경영자이던 일론 머스크가 투자자로 참여했다.")
    ]
}

struct ListItemHorizontalView: View {
    @StateObject var selectedItem = SelectedItem()
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                LazyVStack {    // total Item LazyVStack
                    ForEach(testData, id: \.self.key) { key in
                        Group {
                            if selectedItem.seletedItem != key.key {
                                
                                HStack(alignment: .center) { // One Item HStack
                                    VStack(alignment: .leading) {
                                        Text(key.title).bold().font(Font.subheadline)
                                            .padding(.bottom, 2)
                                        
                                        Text(key.content).font(Font.caption2)
                                    }
                                    .frame(height: 76)
                                    .padding(8)
                                    
                                    Image("Empty")
                                        .frame(width: 38)
                                }
                                .frame(width: geometry.size.width * 0.95, height: 76)
                                .background(RoundedRectangle(cornerRadius: 8, style: .continuous).fill(Color.headerContainerBackgroundColor)
                                                .shadow(color: Color.black.opacity(0.12), radius: 2, x: 0, y: 2))
                                .onTapGesture(count: 1, perform: {
                                    selectedItem.seletedItem = key.key
                                })
                                
                            } else {
                                
                                HStack(alignment: .center) { // One Item HStack
                                    VStack(alignment: .leading) {
                                        Text(key.title).bold().font(Font.subheadline)
                                            .padding(.bottom, 2)
                                        
                                        Text(key.content).font(Font.caption2)
                                    }
                                    .frame(height: 76)
                                    .padding(8)
                                    
                                    VStack(alignment: .trailing) {  // Right two button VStack
                                        Button(action: {}, label: {
                                            Image("ChevronRight")
                                                .foregroundColor(Color.highlightColorLinkFontColor)
                                                .frame(width: 22, height: 22)
                                        })
                                        .frame(width: 38)
                                        .padding(.bottom, 4)
                                        .border(width: 1, edges: [.bottom], color: Color.borderColor)
                                        
                                        Button(action: {}, label: {
                                            Image("EllipsisH")
                                                .foregroundColor(Color.highlightColorLinkFontColor)
                                                .frame(width: 22, height: 22)
                                        })
                                        .frame(width: 38)
                                    }
                                    .frame(width: 38, height: 76)
                                    .border(width: 1, edges: [.leading], color: Color.borderColor)
                                }   // One Item HStack
                                .frame(width: geometry.size.width * 0.95, height: 76)
                                .background(RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                .fill(Color.mouseOverPressedFocusedBackgroundColor)
                                                .shadow(color: Color.black.opacity(0.12), radius: 2, x: 0, y: 2))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                        .strokeBorder(Color.borderColor, lineWidth: 1)
                                )
                            }   // else
                        }   // Group
                    }   // ForEach
                }   // total Item LazyVStack
                .padding(.bottom, 5)
            } // ScrollView
        } // GeometryReader
    }
}

struct ListItemView: PreviewProvider {
    static var previews: some View {
        Group {
            ListItemVerticalView()
                .previewDevice("iPhone 12 mini")
            ListItemVerticalView()
                .previewDevice("iPad Pro (11-inch) (3rd generation)")
        }
    }
}
