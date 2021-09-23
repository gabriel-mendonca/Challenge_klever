//
//  ContentView.swift
//  Challenge_Klever
//
//  Created by Gabriel Mendonça Sousa Goncalves on 22/09/21.
//

import SwiftUI

struct Home: View {
    
    @State private var showingAddScreen = false
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Contacts.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Contacts.name, ascending: true),NSSortDescriptor(keyPath: \Contacts.number, ascending: true)]) var contacts: FetchedResults<Contacts>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(contacts, id: \.self) { contacts in
                    NavigationLink(destination: DetailsContact(contact: contacts)) {
                        
                        VStack(alignment: .leading) {
                            Text(contacts.name ?? "")
                                .font(.headline)
                            Text(contacts.number ?? "")
                                .foregroundColor(.secondary)
                        }
                    }
                }.onDelete(perform: { indexSet in
                    deleteRows(at: indexSet)
                })
            }
            .navigationBarTitle("Contacts")
            .navigationBarItems(leading: EditButton(), trailing: Button(action: {
                self.showingAddScreen.toggle()
            }, label: {
                Image(systemName: "plus")
            }))
            .sheet(isPresented: $showingAddScreen, content: {
                AddContacts().environment(\.managedObjectContext, self.moc)
            })
        }
    }
    
    func deleteRows(at offSets: IndexSet) {
        for offset in offSets {
            let contact = contacts[offset]
            moc.delete(contact)
        }
        try? moc.save()
    }
}
    
    

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
