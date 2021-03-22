//
//  MapPlusAppApp.swift
//  MapPlusApp
//
//  Created by Daeho Kim on 02.03.21.
//

import SwiftUI

@main
struct MapPlusAppApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
                .onAppear {
                    UserLocationManager.shared.start()
                    
                    if !UserLocationManager.shared.isAvailabe() {
                        print("Location service is not available!")
                    }
                }
        }

    }
}
