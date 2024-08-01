//
//  ShootPhotoView.swift
//  BottleClassifier
//
//  Created by Groo on 7/31/24.
//

import SwiftUI

struct ShootPhotoView: View {
    @State private var isShowPhotoLibrary = false
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
                Image(systemName: "photo")
                    .font(.system(size: 20))
                Text("Photo library")
                    .font(.headline)
            })
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(20)
            .padding(.horizontal)
        }
        .sheet(isPresented: $isShowPhotoLibrary) {
            ImagePicker(sourceType: .photoLibrary)
        }
    }
}

#Preview {
    ShootPhotoView()
}
