//
//  ShootPhotoView.swift
//  BottleClassifier
//
//  Created by Groo on 7/31/24.
//

import SwiftUI

struct ShootPhotoView: View {
    @State private var isShowPhotoLibrary = true
    @State private var image = UIImage()
    var body: some View {
        VStack {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(minWidth: 0, maxWidth: .infinity)
                .edgesIgnoringSafeArea(.all)
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
        }
    }
}

#Preview {
    ShootPhotoView()
}
