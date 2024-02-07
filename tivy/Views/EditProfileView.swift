//
//  EditProfileView.swift
//  tivy
//
//  Created by Isaac Schiffler on 5/31/23.
//

import SwiftUI //right now the bio link is way to big for some reason

struct EditProfileView: View {
    @Binding var username: String
    @Binding var bio: String
    @Binding var profileImage: UIImage?
    @State private var isShowingImagePicker = false
    
    
    var body: some View {
        
        NavigationStack {
            ScrollView {
                Button(action: { isShowingImagePicker = true }) {
                    if let image = profileImage {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    }
                }
                .offset(y: 0)
                .padding(.vertical, 15)
                NavigationLink(destination: UpdateUsernameView(username: $username), label: {
                    HStack {
                        Text("Username")
                            .fontWeight(.light)
                            .padding(.leading)
                        Spacer()
                        ZStack(alignment: .topLeading) {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke()
                                .frame(width: 250, height: 40)
                                .padding(.trailing)
                            Text(username)
                                .padding(10)
                                .alignmentGuide(.leading, computeValue: { _ in 0})
                        }
                    }
                })
                .padding(.top, 10)
                //maybe make this like the createActivityView with the rectangle around the stuff
                NavigationLink(destination: UpdateBioField(bio: $bio), label: {
                    HStack {
                        Text("Bio")
                            .fontWeight(.light)
                            .padding(.leading)
                            .offset(y: -90)
                        Spacer()
                        ZStack(alignment: .topLeading) {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke()
                                .frame(width: 250, height: 200)
                                .padding(.trailing)
                            Text(bio)
                                .padding(10)
                                .alignmentGuide(.leading, computeValue: { _ in 0})
                                .multilineTextAlignment(.leading)
                                .frame(width: 250, height: 200, alignment: .topLeading)
                        }
                    }
                })
            }
            .foregroundStyle(.linearGradient(colors: [.green, .mint], startPoint: .topLeading, endPoint: .bottomTrailing))
            .navigationTitle("Edit Profile")
            //edit foreground color so it isn't green
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(selectedImage: $profileImage, isPresented: $isShowingImagePicker)
            }
        }
    }
    
    struct ImagePicker: UIViewControllerRepresentable {
        @Binding var selectedImage: UIImage?
        @Binding var isPresented: Bool
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = context.coordinator
            imagePicker.sourceType = .photoLibrary
            return imagePicker
        }
        
        func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {}
        
        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }
        
        class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
            let parent: ImagePicker
            
            init(_ parent: ImagePicker) {
                self.parent = parent
            }
            
            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                    parent.selectedImage = image
                    uploadPhoto(profileImage: image)
                }
                parent.isPresented = false
            }
            
            func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                parent.isPresented = false
            }
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView(username: .constant("IsaacSchUsername"), bio: .constant("this is the bio ig and some more text"), profileImage: .constant(UIImage(systemName: "person.circle")!))
    }
}
