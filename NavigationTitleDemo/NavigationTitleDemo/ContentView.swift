//
//  ContentView.swift
//  NavigationTitleDemo
//
//  Created by Andrew Monshizadeh on 7/27/20.
//

import SwiftUI
import NavigationTitle

struct ContentView: View {
  @Namespace var contentView
  @State var selection: String = "All"
  var body: some View {
    NavigationView {
      List {
        Text("ContentView identifies the root navigation controller AND uses the custom navigationTitle to set it's title")
        NavigationLink("Go to Second View", destination:
                        SecondView(namespace: contentView))
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
      .rootNavigationBarIdentified(within: contentView)
    }
  }
}

struct SecondView: View {
  let namespace: Namespace.ID
  var body: some View {
    List {
      Text("Second View uses SwiftUI provided navigationTitle")
      NavigationLink("Go to Third View", destination: ThirdView(namespace: namespace))
    }
    .navigationTitle("Second View")
  }
}

struct ThirdView: View {
  let namespace: Namespace.ID
  @State var toggle = false
  @State var timer: Timer?
  var body: some View {
    List {
      Text("Third View uses custom navigationTitle AND updates the title at runtime")
      NavigationLink("Go to Fourth View", destination:
                      FourthView(namespace: namespace)
      )
    }
    .navigationTitle(toggle ? "True" : "False")
    .onAppear {
      timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
        toggle.toggle()
      })
    }
    .onDisappear {
      timer?.invalidate()
      timer = nil
    }
  }
}

struct FourthView: View {
  let namespace: Namespace.ID
  var body: some View {
    List {
      Text("Fourth View uses custom navigationTitle")
    }
    .navigationTitle("Fourth View", within: namespace)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
