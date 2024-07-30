//
//  ContentView.swift
//  BottleClassifier
//
//  Created by Groo on 7/30/24.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @State private var pickerItem: PhotosPickerItem?
    @State private var selectedImage: Image?
    var body: some View {
        VStack {
            PhotosPicker("Tap to import a photo", selection: $pickerItem)
                .onChange(of: pickerItem) {
                    Task {
                        selectedImage = try await pickerItem?.loadTransferable(type: Image.self)
                    }
                }
            selectedImage?
                .resizable()
                .scaledToFit()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
