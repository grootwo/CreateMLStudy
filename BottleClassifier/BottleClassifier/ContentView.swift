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
    @State private var answer: Set<String>?
    var answerString: [String] {
        if let answer {
            return [String](answer)
        }
        return ["Unkown"]
    }
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
            if let answer {
                Text(answerString.joined(separator: " / "))
            }
            Spacer()
            Button("Bottle or not") {
                recognizeBottle()
            }
            .disabled(selectedImage == nil)
        }
        .padding()
    }
    func recognizeBottle() {
        do {
            let config = MLModelConfiguration()
            let model = try BottleClassifier1(configuration: config)
            let prediction = try model.prediction(image: selectedImage as! CVPixelBuffer)
            answer = prediction.featureNames
        } catch {
            print("error")
        }
    }
}

#Preview {
    ContentView()
}
