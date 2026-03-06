//
//  ExampleView.swift
//  VIPER
//
//  Created by Felipe Remigio on 22/05/20.
//  Copyright © 2020 Remigio All rights reserved.
//

import SwiftUI

struct ExampleView: View {
    @StateObject var viewModel: ExampleViewModel

    var body: some View {
        ZStack {
            List(viewModel.items) { item in
                Button(action: { viewModel.selectItem(item) }) {
                    Text(item.title)
                }
            }
            if viewModel.isLoading {
                ProgressView()
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
}

struct ExampleView_Previews: PreviewProvider {
    static var previews: some View {
        ExampleView(viewModel: ExampleViewModel())
    }
}
