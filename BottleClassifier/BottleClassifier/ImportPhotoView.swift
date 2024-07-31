//
//  ImportPhotoView.swift
//  BottleClassifier
//
//  Created by Groo on 7/31/24.
//

import SwiftUI
import CoreML
import PhotosUI

struct ImportPhotoView: View {
    @State private var pickerItem: PhotosPickerItem?
    @State private var selectedImage: Image?
    @State private var probability: [String: Double]?
    @State private var target = ""
    var body: some View {
        VStack {
            PhotosPicker(selection: $pickerItem) {
                if let selectedImage {
                    selectedImage
                        .resizable()
                        .scaledToFit()
                } else {
                    ContentUnavailableView("No image", systemImage: "photo.badge.plus")
                }
            }
            .onChange(of: pickerItem) {
                Task {
                    selectedImage = try await pickerItem?.loadTransferable(type: Image.self)
                }
            }
            if let probability {
                Text(target)
                    .font(.title)
                Text("bottle: \(probability["bottle"] ?? -1)")
                Text("not bottle: \(probability["not bottle"] ?? -1)")
            }
        }
        .padding()
        .toolbar {
            Button("Bottle or not") {
                Task {
                    await recognizeBottle()
                }
            }
            .disabled(selectedImage == nil)
        }
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
    ImportPhotoView()
}
