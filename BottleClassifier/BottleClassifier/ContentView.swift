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
    @State private var pickerItem: PhotosPickerItem?
    @State private var selectedImage: Image?
    @State private var probability: [String: Double]?
    @State private var target = ""
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
            if let probability {
                Text(target)
                    .font(.title)
                Text("bottle: \(probability["bottle"] ?? -1)")
                Text("not bottle: \(probability["not bottle"] ?? -1)")
            }
            Spacer()
            Button("Bottle or not") {
                Task {
                    await recognizeBottle()
                }
            }
            .disabled(selectedImage == nil)
        }
        .padding()
    }
    func recognizeBottle() async {
        do {
            let config = MLModelConfiguration()
            let model = try BottleClassifier1(configuration: config)
            guard let imageData = try await pickerItem?.loadTransferable(type: Data.self) else { return }
            let prediction = try model.prediction(image: pixelBufferFromImage(image: UIImage(data: imageData)!))
            probability = prediction.targetProbability
            target = prediction.target
        } catch {
            print("error")
        }
    }
}

#Preview {
    ContentView()
}

