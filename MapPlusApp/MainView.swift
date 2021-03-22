//
//  MainView.swift
//  MapPlusApp
//
//  Created by Daeho Kim on 02.03.21.
//

import SwiftUI

struct MainView: View {
    var body: some View {
//        PlusMapServiceView()
        MetalView()
            .ignoresSafeArea()
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
