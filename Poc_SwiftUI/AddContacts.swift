//
//  AddContacts.swift
//  Challenge_Klever
//
//  Created by Gabriel Mendonça Sousa Goncalves on 22/09/21.
//

import SwiftUI

struct AddContacts: View {
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var number = ""
    @State private var rating = 3
    
    var body: some View {
        NavigationView {
            Form {
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
                        let newContact = Contacts(context: self.moc)
                        newContact.name = name
                        newContact.number = number
                        newContact.rating = Int16(rating)
                        newContact.date = Date()
                        
                        try? self.moc.save()
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }.navigationBarTitle("Add Contact")
        }
    }
}

struct AddContacts_Previews: PreviewProvider {
    static var previews: some View {
        AddContacts()
    }
}
