//
//  ShootPhotoView.swift
//  BottleClassifier
//
//  Created by Groo on 7/31/24.
//

import SwiftUI
import CoreML

struct ShootPhotoView: View {
    @State private var isShowPhotoLibrary = true
    @State private var image = UIImage()
    @State private var probability: [String: Double]?
    @State private var target = ""
    var body: some View {
        VStack {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(minWidth: 0, maxWidth: .infinity)
                .edgesIgnoringSafeArea(.all)
                .onChange(of: image) {
                    Task {
                        print("upload an image")
                        await recognizeBottle()
                    }
                }
            if let probability {
                Text(target)
                    .font(.title)
                Text("bottle: \(probability["bottle"] ?? -1)")
                Text("not bottle: \(probability["not bottle"] ?? -1)")
            }
            Button(action: {
                isShowPhotoLibrary = true
            }, label: {
                Image(systemName: "camera.shutter.button.fill")
                    .font(.system(size: 20))
                Text("Camera")
                    .font(.headline)
            })
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(20)
            .padding(.horizontal)
        }
        .fullScreenCover(isPresented: $isShowPhotoLibrary) {
            ImagePicker(sourceType: .camera, selectedImage: $image)
                .ignoresSafeArea()
        }
    }
    func recognizeBottle() async {
        do {
            let config = MLModelConfiguration()
            let model = try BottleClassifier1(configuration: config)
            let prediction = try model.prediction(image: pixelBufferFromImage(image: image))
            probability = prediction.targetProbability
            target = prediction.target
        } catch {
            print("error")
        }
    }
}

#Preview {
    ShootPhotoView()
}
