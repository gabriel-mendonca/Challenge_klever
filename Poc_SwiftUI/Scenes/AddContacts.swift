//
//  AddContacts.swift
//  Poc_SwiftUI
//
//  Created by Gabriel Mendonça Sousa Goncalves on 22/09/21.
//

import SwiftUI
import CoreImage
import CoreData

struct AddContacts: View {
    
    private var contact: Contacts? = nil
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var number = ""
    @State private var rating = 3
    @State private var image: Image?
    @State private var inputImage: UIImage?
    @State private var showingImagePicker = false
    
    init(contact: Contacts? = nil) {
        self.contact = contact
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
            ZStack {
                Rectangle().fill(Color.secondary)
                    .clipShape(Circle())
                    .frame(width: 100, height: 100, alignment: .center)
                    Image(systemName: "camera.fill")
                if image != nil {
                    image?.resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 100, height: 100, alignment: .center)
                    
                }
            }.onTapGesture {
                showingImagePicker = true
            } .sheet(isPresented: $showingImagePicker, onDismiss: loadImage, content: {
                ImagePicker(image: $inputImage)
            })
                    List {
                        Section(header: Text("Contact information")
                                    .fontWeight(.bold)) {
                            TextField("Name of contact", text: $name)
                            TextField("Number of contact", text: $number)
                        }
                        Section(header: Text("Contact favorite").fontWeight(.bold)) {
                            RatingView(rating: $rating)
                        }
                        Section {
                            Button("Save") {
                                
                                contact == nil ? save() : edit()
                                
                                try? self.moc.save()
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }.frame(width: geometry.size.width - 5, height: geometry.size.height - 50, alignment: .center)
                    .listStyle(InsetGroupedListStyle())
                    .environment(\.horizontalSizeClass, .regular)
                    .onAppear {
                        let getImage = UIImage(data: contact?.image ?? Data()) ?? UIImage()
                        let images = Image(uiImage: getImage)
                        let getRating = Int(contact?.rating ?? 3)
                        name = contact?.name ?? ""
                        number = contact?.number ?? ""
                        rating = getRating
                        image = images
                        
                    }
                    .navigationBarTitle(contact == nil ? "Add Contact" : "Edit Contact")
            }
            }
        }
    
    private func save() {
        let newContact = Contacts(context: self.moc)
        let image = inputImage?.jpegData(compressionQuality: 1.0)
        newContact.name = name
        newContact.number = number
        newContact.rating = Int16(rating)
        newContact.date = Date()
        newContact.image = image
    }
    
    private func edit() {
        let image = inputImage?.jpegData(compressionQuality: 1.0)
        moc.performAndWait {
            contact?.name = name
            contact?.number = number
            contact?.rating = Int16(rating)
            contact?.image = image
            try? moc.save()
            presentationMode.wrappedValue.dismiss()
        }
        
    }
    
    func loadImage() {
        guard let inputImage = inputImage else {return}
        image = Image(uiImage: inputImage)
    }
}

struct AddContacts_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    static var previews: some View {
        let contact = Contacts(context: moc)
        contact.image = Data()
        contact.name = "test name"
        contact.number = "test number"
        contact.rating = 4
        return NavigationView {
        AddContacts(contact: contact)
        }
    }
}
