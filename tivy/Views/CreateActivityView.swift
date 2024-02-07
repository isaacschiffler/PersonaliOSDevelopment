//
//  CreateActivityView.swift
//  tivy
//
//  Created by Isaac Schiffler on 6/1/23.
//

import SwiftUI
import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage
import MapKit

struct CreateActivityView: View {
    @State private var title = ""
    @State private var description = ""
    @State private var mainImage: UIImage?
    @State private var effort = 0.0
    @State private var time = 0.0
    @State private var cost = 0.0
    @State private var physical = 0.0
    @State private var moreImages: [UIImage?] = Array(repeating: nil, count: 10)
    @State private var selectedCoordinate: CLLocationCoordinate2D? = nil
    let timeOptions = ["Choose", "Any", "Daytime", "Sunrise", "Morning", "Breakfast", "Lunch", "Afternoon", "Dinner", "Sunset", "Night", "Late Night"]
    @State private var idealTime: String = "Choose"
    @State private var isShowingImagePicker = false
    @State var showConfirm: Bool = false
    
    @State private var titleGood = true
    @State private var desGood = true
    @State private var imageGood = true
    @State private var timeGood = true
    
    @Binding var showCreateActivityView: Bool
    
    var body: some View {
        ScrollView {
            ZStack {
                VStack {
                    //Current Image
                    VStack {
                        if mainImage != nil {
                            Image(uiImage: mainImage!)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 300, height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding(.top, 10)
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 300, height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding(.top, 10)
                        }
                        Button {
                            //Pick out photo
                            isShowingImagePicker = true
                        } label: {
                            Text("Upload Photo")
                        }
                    }
                    .padding(.top, 10)
                    Text("Title")
                        .position(x: 30, y: 10)
                        .fontWeight(.light)
                        .font(.footnote)
                        .padding(.top, 10)
                    RoundedRectangle(cornerRadius: 10)
                        .stroke()
                        .overlay(
                            TextField("title", text: $title)
                                .textFieldStyle(.plain)
                                .offset(x: 10)
                                .autocapitalization(.none)
                                .onChange(of: title) { newValue in
                                    if newValue.count > 125 {
                                        title = String(newValue.prefix(125))
                                    }
                                }
                        )
                        .frame(width: 350, height: 40)
                        .padding(.vertical, 20)
                    Text("Description")
                        .position(x: 51, y: 10)
                        .fontWeight(.light)
                        .font(.footnote)
                    RoundedRectangle(cornerRadius: 10)
                        .stroke()
                        .overlay(
                            TextView(text: $description)
                                .textFieldStyle(.plain)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                .alignmentGuide(.leading) { _ in 0 }
                                .padding(10)
                            /*.placeholder(when: description.isEmpty, placeholder: {
                             Text("description")
                             .offset(x: 3, y: -72.5)
                             .zIndex(1)
                             .foregroundColor(.gray)
                             .opacity(0.5)
                             })*/ //this makes it so clicking the actual placeholder does nothing
                        )
                        .frame(width: 350, height: 200)
                        .padding(.vertical, 20)
                    VStack {
                        VStack {
                            Text(String(format: "Effort Rating: %.1f", effort))
                                .font(.footnote)
                                .frame(width: 350, alignment: .leading) // Set a fixed frame width for the label
                            
                            Slider(value: $effort, in: 0.0...5.0, step: 0.1)
                                .frame(width: 325)
                        }
                        .padding([.top, .leading, .trailing], 10)
                        VStack {
                            Text(String(format: "Time Commitment Rating: %.1f", time))
                                .font(.footnote)
                                .frame(width: 350, alignment: .leading) // Set a fixed frame width for the label
                            
                            Slider(value: $time, in: 0.0...5.0, step: 0.1)
                                .frame(width: 325)
                        }
                        .padding([.top, .leading, .trailing], 10)
                        VStack {
                            Text(String(format: "Cost Rating: %.1f", cost))
                                .font(.footnote)
                                .frame(width: 350, alignment: .leading) // Set a fixed frame width for the label
                            
                            Slider(value: $cost, in: 0.0...5.0, step: 0.1)
                                .frame(width: 325)
                        }
                        
                        .padding([.top, .leading, .trailing], 10)
                        VStack {
                            Text(String(format: "Physicality Rating: %.1f", physical))
                                .font(.footnote)
                                .frame(width: 350, alignment: .leading) // Set a fixed frame width for the label
                            
                            Slider(value: $physical, in: 0.0...5.0, step: 0.1)
                                .frame(width: 325)
                            
                        }
                        .padding([.top, .leading, .trailing], 10)
                        VStack {
                            Text("Ideal time:")
                                .font(.footnote)
                                .padding(.top)
                                .frame(width: 350, alignment: .leading) // Set a fixed frame width for the label

                            Picker("Select an ideal time", selection: $idealTime) {
                                ForEach(timeOptions, id: \.self) { option in
                                    Text(option)
                                }
                            }
                            .padding(.bottom)
                            .offset(y: -20)
                            .pickerStyle(.menu)
                            .accentColor(.mint)
                        }
                        VStack {
                            Text("Additional Images (not required but recommended; up to ten):")
                                .font(.footnote)
                                .frame(width: 350, alignment: .leading) // Set a fixed frame width for the label
                            MoreImagesUploadView(images: $moreImages)
                        }
                        VStack {
                            Text("Select Location (not required but recommended):")
                                .font(.footnote)
                                .frame(width: 350, alignment: .leading) // Set a fixed frame width for the label
                            MapViewSelection(selectedCoordinate: $selectedCoordinate)
                                .frame(width: 350, height: 300)
                                .clipShape(RoundedRectangle(cornerRadius: 10))

                            if let coordinate = selectedCoordinate {
                                Text("Selected Location: \(coordinate.latitude), \(coordinate.longitude)")
                            } else {
                                Text("No location selected.")
                            }
                        }

                    }
                    VStack {
                        Button {
                            if verifyFields() {
                                submitToFirestore()
                                showConfirm = true
                            }
                        } label: {
                            Text("Submit")
                                .font(.title)
                                .bold()
                                .frame(width: 200, height: 40)
                        }
                        .padding(.top)
                        
                        //add error messages here if any are incorrectly entered...
                        VStack {
                            if !titleGood {
                                Text("Title must be between 2 and 60 chars")
                                Text("Current: \(title.count)")
                            }
                            if !desGood {
                                Text("Description must be between 30 and 750 chars")
                                Text("Current: \(description.count)")
                            }
                            if !imageGood {
                                Text("Must include main image")
                            }
                            if !timeGood {
                                Text("Must select an ideal time")
                            }
                        }
                    }
                }
                .foregroundStyle(.linearGradient(colors: [.green, .mint], startPoint: .topLeading, endPoint: .bottomTrailing))
                .sheet(isPresented: $isShowingImagePicker) {
                    ImagePicker(image: $mainImage)
                }
                .alert(isPresented: $showConfirm) {
                    Alert(
                        title: Text("Successful Upload"),
                        message: Text("Thank you for submitting an activity!"),
                        dismissButton: .default(Text("OK"), action: {
                            showCreateActivityView = false
                        })
                    )
                }
            }
        }
    }
    
    //structs and functions
    func submitToFirestore() {
        //submit all the fields to a document in "activities" collection
        let db = Firestore.firestore()
        let collection = db.collection("activities")
        var docID: String = ""

        
        //create doc
        var newDocumentRef: DocumentReference? = nil
        newDocumentRef = collection.addDocument(data: ["title": title,
                                                       "description": description,
                                                       "effort": effort,
                                                       "time": time,
                                                       "cost": cost,
                                                       "physical": physical,
                                                       "timeOfDay": idealTime,
                                                       "user": Auth.auth().currentUser!.uid]) { error in
            if let error = error {
                // Handle error
                print("Error creating document: \(error)")
            } else {
                // Document created successfully
                docID = newDocumentRef?.documentID ?? ""
                if docID != "" {
                    print("New document ID: \(docID)")
                    // Use the document ID as needed
                }
                else {
                    print("error in creating new document for activity")
                }
            }
            
            //upload image to storage
            uploadActivityPhoto(mainImage: mainImage, docID: docID)
            
            //upload more images to storage and add them to the doc as a collection of image paths
            uploadMoreImages(images: moreImages, docID: docID)
            
            //upload map location
            uploadCoordinate(coords: selectedCoordinate, docID: docID)
        }
    }
    
    func verifyFields() -> Bool {
        //verify all fields have an item
        let title = verifyTitle()
        let des = verifyDescription()
        let im = verifyMainImage()
        let ti = verifyTimeOfDay()
        
        if title && des && im && ti {
            return true
        }
        return false
    }
    
    func verifyTitle() -> Bool {
        if title.count < 2 || title.count > 60 {
            titleGood = false
            return false
        }
        return true
    }
    
    func verifyDescription() -> Bool {
        if description.count < 30 || title.count > 750 {
            desGood = false
            return false
        }
        return true
    }
    
    func verifyMainImage() -> Bool {
        if mainImage == nil {
            imageGood = false
            return false
        }
        return true
    }
    
    func verifyTimeOfDay() -> Bool {
        if idealTime == "Choose" {
            timeGood = false
            return false
        }
        return true
    }
    
    //Map feature
    struct MapViewSelection: UIViewRepresentable {
        @Binding var selectedCoordinate: CLLocationCoordinate2D?
        @State private var annotations: [MKPointAnnotation] = []

        func makeUIView(context: Context) -> MKMapView {
            let mapView = MKMapView()
            mapView.delegate = context.coordinator

            // Add long press gesture recognizer
            let longPressGesture = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleLongPress(_:)))
            mapView.addGestureRecognizer(longPressGesture)

            return mapView
        }

        func updateUIView(_ view: MKMapView, context: Context) {
            // Update the map view if needed
            updateAnnotations(on: view)
        }

        func makeCoordinator() -> Coordinator {
            Coordinator(selectedCoordinate: $selectedCoordinate, annotations: $annotations)
        }

        class Coordinator: NSObject, MKMapViewDelegate {
            @Binding var selectedCoordinate: CLLocationCoordinate2D?
            @Binding var annotations: [MKPointAnnotation]

            init(selectedCoordinate: Binding<CLLocationCoordinate2D?>, annotations: Binding<[MKPointAnnotation]>) {
                _selectedCoordinate = selectedCoordinate
                _annotations = annotations
            }

            @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
                if gestureRecognizer.state == .began {
                    let mapView = gestureRecognizer.view as! MKMapView
                    let locationInView = gestureRecognizer.location(in: mapView)
                    let coordinate = mapView.convert(locationInView, toCoordinateFrom: mapView)

                    selectedCoordinate = coordinate

                    // Update the annotations array
                    annotations = [createAnnotation(for: coordinate)]

                    // Remove all existing annotations from the map view
                    mapView.removeAnnotations(mapView.annotations)
                    
                    // Add the selected annotation to the map view
                    mapView.addAnnotation(annotations.first!)
                }
            }

            func createAnnotation(for coordinate: CLLocationCoordinate2D) -> MKPointAnnotation {
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                return annotation
            }
        }

        private func updateAnnotations(on mapView: MKMapView) {
            // Remove all existing annotations from the map view
            mapView.removeAnnotations(mapView.annotations)
            
            // Add the selected annotation to the map view
            if let selectedCoordinate = selectedCoordinate {
                let annotation = MKPointAnnotation()
                annotation.coordinate = selectedCoordinate
                mapView.addAnnotation(annotation)
            }
        }
    }
    
    //also gotta add the change photo thing
}

struct CreateActivityView_Previews: PreviewProvider {
    static var previews: some View {
        CreateActivityView(showCreateActivityView: .constant(true))
    }
}

struct TextView: UIViewRepresentable { //holy fuck this actually wraps the text
    @Binding var text: String
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.delegate = context.coordinator
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        @Binding var text: String
        
        init(text: Binding<String>) {
            _text = text
        }
        
        func textViewDidChange(_ textView: UITextView) {
            text = textView.text
        }
    }
}


func uploadActivityPhoto(mainImage: UIImage?, docID: String) {
    
    //make sure image isn't nil
    guard mainImage != nil else {
        return
    }
    
    // create storage reference
    let storageRef = Storage.storage().reference()
    
    //turn image into data
    let imageData = mainImage!.jpegData(compressionQuality: 0.8)
    
    guard imageData != nil else {
        return
    }
    
    //specify the filepath and name
    let path = "images/activityImages/\(docID)/mainImage.jpg"
    let fileRef = storageRef.child(path)
    
    //upload the data
    let uploadTask = fileRef.putData(imageData!, metadata: nil) { metadata, error in
        if error == nil && metadata != nil {
            //save reference to the file in firestore DB
            //can wait to do this later once a database is created to store the image ref
            let db = Firestore.firestore()
            let collection = db.collection("activities")
            let document = collection.document(docID)
            document.updateData(["image": path]) { error in
                if let error = error {
                    document.setData(["image": path]) { error in
                        if let error = error {
                            print("Error creating data set for uid \(error.localizedDescription)")
                        } else {
                            print("created new document and added photo for docID")
                        }
                    }
                    print("Error updating document: \(error.localizedDescription)")
                }
                else {
                    print("Document uploaded successfully")
                }
            }
        }
    }
}


func uploadMoreImages(images: [UIImage?], docID: String) {
    var i = 0
    var total = 0
    var imagePaths: [String] = []
    
    for image in images {
        if image != nil {
            total += 1
        }
    }
    
    for image in images {
        // Make sure image isn't nil
        guard let image = image, let imageData = image.jpegData(compressionQuality: 0.8) else {
            continue
        }
        
        // Create storage reference
        let storageRef = Storage.storage().reference()
        
        // Specify the filepath and name
        let path = "images/activityImages/\(docID)/moreImages/image\(i).jpg"
        let fileRef = storageRef.child(path)
        
        // Upload the data
        let uploadTask = fileRef.putData(imageData, metadata: nil) { metadata, error in
            if error == nil, let _ = metadata {
                // Save the image path to the array
                imagePaths.append(path)
                i -= 1
                // Check if all images have been uploaded
                if i == 0 {
                    // Update the document with the image paths array
                    let db = Firestore.firestore()
                    let collection = db.collection("activities")
                    let document = collection.document(docID)
                    document.updateData(["moreImages": FieldValue.arrayUnion(imagePaths)]) { error in
                        if let error = error {
                            print("Error updating document: \(error.localizedDescription)")
                        } else {
                            print("Document updated successfully")
                        }
                    }
                }
            }
        }
        
        i += 1
    }
}

func uploadCoordinate(coords: CLLocationCoordinate2D?, docID: String) {
    guard let coordinate = coords else {
        return
    }

    let db = Firestore.firestore()
    let col = db.collection("activities")
    let docRef = col.document(docID)

    let geopoint = GeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude)

    let coordinateData: [String: Any] = [
        "location": geopoint
    ]

    docRef.updateData(coordinateData) { error in
        if let error = error {
            print("Error uploading coordinate: \(error.localizedDescription)")
        } else {
            print("Coordinate uploaded successfully.")
        }
    }
}
