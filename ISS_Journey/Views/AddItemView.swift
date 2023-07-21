//
//  SwiftUIView.swift
//  ISS_Journey
//
//  Created by michaell medina on 20/07/23.
//

import SwiftUI

struct AddItemView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm: AddItemViewModel
    
    init(vm: AddItemViewModel) {
        self.vm = vm
    }
    
    var body: some View {
        Form {
            Text("\(vm.latitude)")
            Text("\(vm.longitude)")
            
            Button("Save") {
                vm.save()
                presentationMode.wrappedValue.dismiss()
            }.centerHorizontally()
            
            .navigationTitle("Add New Budget")
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        
        let viewContext = CoreDataManager.shared.persistenseStoreContainer.viewContext
        NavigationView{
            AddItemView(vm: AddItemViewModel(context: viewContext))
        }
    }
}
