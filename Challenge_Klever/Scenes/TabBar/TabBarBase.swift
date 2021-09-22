//
//  TabBarBase.swift
//  Challenge_Klever
//
//  Created by Gabriel Mendonça Sousa Goncalves on 22/09/21.
//

import Foundation
import SwiftUI

struct TabBarBase: View {
    @State var selectView = 1
    
    var body: some View {
        TabView(selection: $selectView,
                content:  {
                    Home()
                        .tabItem { Label("Home", systemImage: "server.rack") }.tag(1)
                    Text("Tab Content 2").tabItem { /*@START_MENU_TOKEN@*/Text("Tab Label 2")/*@END_MENU_TOKEN@*/ }.tag(2)
                })
    }
}
