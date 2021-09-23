//
//  DetailsContact.swift
//  Poc_SwiftUI
//
//  Created by Gabriel Mendonça Sousa Goncalves on 22/09/21.
//

import SwiftUI
import CoreData

struct DetailsContact: View {
    
    let contact: Contacts
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State private var showingDeleteAlert = false
    @State private var dateAndHour = Date()
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text(self.contact.name == "" ? "N/A": self.contact.name ?? "Unknown")
                    .font(.title)
                    .foregroundColor(.secondary)
                Text(self.contact.number == "" ? "N/A" : self.contact.number ?? "No number")
                    .padding()
                
                RatingView(rating: .constant(Int(self.contact.rating)))
                    .font(.largeTitle)
                Spacer()
            }
        }.alert(isPresented: $showingDeleteAlert, content: {
            Alert(title: Text("Delete Contact"), message: Text("Are you sure?"), primaryButton: .destructive(Text("Delete")) {
                
            }, secondaryButton: .cancel())
        })
        .navigationBarTitle(self.contact.name == "" ? "Unknown contact" : self.contact.name ?? "",displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            self.showingDeleteAlert = true
        }) {
            Image(systemName: "trash")
        })
    }
    
    var formattedDate: String {
        if let date = self.contact.date {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.timeStyle = .medium
            return formatter.string(from: date)
        } else {
            return "N/A"
        }
    }
    
    func deleteContact() {
        moc.delete(contact)
        presentationMode.wrappedValue.dismiss()
    }
}

struct DetailsContact_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    static var previews: some View {
        let contact = Contacts(context: moc)
        contact.name = "test name"
        contact.number = "test number"
        contact.rating = 4
        return NavigationView {
        DetailsContact(contact: contact)
        }
    }
}
