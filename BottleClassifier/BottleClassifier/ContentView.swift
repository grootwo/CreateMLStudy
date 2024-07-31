//
//  ContentView.swift
//  BottleClassifier
//
//  Created by Groo on 7/30/24.
//

import SwiftUI
import PhotosUI
import CoreML

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 50) {
                NavigationLink(destination: ShootPhotoView()) {
                    Label("shoot a photo", systemImage: "camera.shutter.button")
                        .font(.title)
                }
                NavigationLink(destination: ImportPhotoView()) {
                    Label("import an image", systemImage: "photo.badge.plus")
                        .font(.title)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

