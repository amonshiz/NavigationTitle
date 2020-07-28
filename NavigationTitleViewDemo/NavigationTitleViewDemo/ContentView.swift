//
//  ContentView.swift
//  NavigationTitleViewDemo
//
//  Created by Andrew Monshizadeh on 7/27/20.
//

import SwiftUI
import NavigationTitleView

struct ContentView: View {
  @State var selection: Int = 1
  var body: some View {
    NavigationView {
      List {
        Text("Hello, world!").padding()
      }
      .navigationTitle("First")
      .toolbar(items: {
        ToolbarItem {
          NavigationTitleView(
            content:
              Picker(selection: $selection, label: Text("Hello")) {
                Text("1").tag(1)
                Text("2").tag(2)
              }
              .pickerStyle(SegmentedPickerStyle())
          )
        }
      })
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
