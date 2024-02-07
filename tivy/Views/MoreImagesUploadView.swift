//
//  MoreImagesUploadView.swift
//  tivy
//
//  Created by Isaac Schiffler on 6/3/23.
//

import SwiftUI

struct MoreImagesUploadView: View {
    @Binding var images: [UIImage?]
    @State private var isShowingImagePicker = false
    @State private var curIndex: Int = 0

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(0..<images.count, id: \.self) { index in
                    VStack {
                        if let image = images[index] {
                            HStack {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 75)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .offset(x: 12.5)
                                    .padding(.horizontal, 10)
                                Button(action: {
                                    deleteImage(at: index)
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                            }
                            
                        } else if (index != 0 && images[index - 1] != nil) ||
                        (index == 0 && images[index] == nil){
                            Button(action: {
                                curIndex = index
                                isShowingImagePicker.toggle()
                            }) {
                                Image(systemName: "plus")
                                    .frame(width: 100, height: 75)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(8)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .cornerRadius(8)
                        }
                    }
                    .foregroundStyle(.linearGradient(colors: [.green, .mint], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .sheet(isPresented: $isShowingImagePicker) {
                        ImagePicker(image: $images[curIndex])
                    }
                }
            }
        }
    }
    
    private func selectImage(for index: Int) {
        // Set the selectedImage and selectedIndex
        
        // Trigger the image picker sheet
    }
    
    private func handleImageSelection(_ result: Result<URL, Error>, for index: Int) {
        // Handle the selected image from the file picker
        // Set the corresponding image in the images array
    }
    
    private func deleteImage(at index: Int) {
        // Delete the image at the given index by setting it to nil
        images[index] = nil
        /*for i in (index + 1)...10 {
            if images[i] != nil {
                images[i - 1] = images[i]
                images[i] = nil
            }
        }*/ //can try to figure this out so the images trickle down if an image in the middle is deleted
    }
}

/*struct MoreImagesUploadView_Previews: PreviewProvider {
    @State private var images: [UIImage?] = Array(repeating: nil, count: 10)
    static var previews: some View {
        MoreImagesUploadView(images: $images)
    }
}*/

//for some reason i can't figure out the preview thing
