//
//  ContentView.swift
//  NavigationTitleViewDemo
//
//  Created by Andrew Monshizadeh on 7/27/20.
//

import SwiftUI
import NavigationTitleView

struct ContentView: View {
  @Namespace var contentView
  @State var selection: String = "All"
  var body: some View {
    NavigationView {
      List {
        Text("Hello, world!").padding()
      }
      .toolbar(items: {
        ToolbarItem(placement: .principal) {
          Picker(selection: $selection, label: Text("Call Type")) {
            Text("All").tag("All")
            Text("Missed").tag("Missed")
          }
          .pickerStyle(SegmentedPickerStyle())
        }
      })
      .navigationTitle("Recents", within: contentView)
    }
    .rootNavigationBarIdentified(within: contentView)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
