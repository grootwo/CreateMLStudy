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
    func pixelBufferFromImage(image: UIImage) -> CVPixelBuffer {
            
            
            let ciimage = CIImage(image: image)
            //let cgimage = convertCIImageToCGImage(inputImage: ciimage!)
            let tmpcontext = CIContext(options: nil)
            let cgimage =  tmpcontext.createCGImage(ciimage!, from: ciimage!.extent)
            
            let cfnumPointer = UnsafeMutablePointer<UnsafeRawPointer>.allocate(capacity: 1)
            let cfnum = CFNumberCreate(kCFAllocatorDefault, .intType, cfnumPointer)
            let keys: [CFString] = [kCVPixelBufferCGImageCompatibilityKey, kCVPixelBufferCGBitmapContextCompatibilityKey, kCVPixelBufferBytesPerRowAlignmentKey]
            let values: [CFTypeRef] = [kCFBooleanTrue, kCFBooleanTrue, cfnum!]
            let keysPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 1)
            let valuesPointer =  UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 1)
            keysPointer.initialize(to: keys)
            valuesPointer.initialize(to: values)
            
            let options = CFDictionaryCreate(kCFAllocatorDefault, keysPointer, valuesPointer, keys.count, nil, nil)
           
            let width = cgimage!.width
            let height = cgimage!.height
         
            var pxbuffer: CVPixelBuffer?
            // if pxbuffer = nil, you will get status = -6661
            var status = CVPixelBufferCreate(kCFAllocatorDefault, width, height,
                                             kCVPixelFormatType_32BGRA, options, &pxbuffer)
            status = CVPixelBufferLockBaseAddress(pxbuffer!, CVPixelBufferLockFlags(rawValue: 0));
            
            let bufferAddress = CVPixelBufferGetBaseAddress(pxbuffer!);

            
            let rgbColorSpace = CGColorSpaceCreateDeviceRGB();
            let bytesperrow = CVPixelBufferGetBytesPerRow(pxbuffer!)
            let context = CGContext(data: bufferAddress,
                                    width: width,
                                    height: height,
                                    bitsPerComponent: 8,
                                    bytesPerRow: bytesperrow,
                                    space: rgbColorSpace,
                                    bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue);
            context?.concatenate(CGAffineTransform(rotationAngle: 0))
            context?.concatenate(__CGAffineTransformMake( 1, 0, 0, -1, 0, CGFloat(height) )) //Flip Vertical
    //        context?.concatenate(__CGAffineTransformMake( -1.0, 0.0, 0.0, 1.0, CGFloat(width), 0.0)) //Flip Horizontal
            

            context?.draw(cgimage!, in: CGRect(x:0, y:0, width:CGFloat(width), height:CGFloat(height)));
            status = CVPixelBufferUnlockBaseAddress(pxbuffer!, CVPixelBufferLockFlags(rawValue: 0));
            return pxbuffer!;
            
        }
}

#Preview {
    ContentView()
}

