//
//  Home.swift
//  API Resquet
//
//  Created by Antonio Costa on 13/08/25.
//

import SwiftUI

struct Home: View {
    var body: some View {
        ScrollView{
            VStack{
                Text("Deals of the day")
                    .font(.system(.title2, weight: .semibold))
                    .foregroundStyle(.primary)
                
                //MARK: COLOCAR OS COMPONENTES CRIADOS PELA SOFIA AQUI

            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack{
                Text("Top picks")
                    .font(.system(.title2, weight: .semibold))
                    .foregroundStyle(.primary)
                
                //MARK: COLOCAR OS COMPONENTES CRIADOS PELA SOFIA AQUI

            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            
            
        }.navigationTitle("Home")
    }
}

#Preview {
    TabBar()
}
