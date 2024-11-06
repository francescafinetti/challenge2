//
//  RankingView .swift
//  PartyGameTools
//
//  Created by Dylan Esposito on 05/11/24.
//

import SwiftUI

//player entry view

struct RankingView_: View {
    var body: some View {
        VStack{
            
            playerEntry(image: "James", testo: "James \nSunderland ", azione:{}, playerpoints: 500, rank: 1, playerBadge: "badge")
                .padding(8)
            
            playerEntry(image: "Angela", testo: "Angela \nEsposito", azione: {}, playerpoints: 100,rank: 2, playerBadge: "badge")
                .padding(8)
            
            playerEntry(image: "Eddie", testo: "Eddie \nO' Chiatt", azione: {}, playerpoints: 20, rank: 3, playerBadge: "badge")
                .padding(8)
            
            playerEntry(image: "Pyramid", testo: "Pyramid \n Head", azione: {}, playerpoints: 0, rank:4, playerBadge: "badge")
                .padding(8)
            Spacer()
        }
        
        
        
    }
}

//textbox per inserimento punteggi

struct textboxView: View {
    @State private var score = 0
    
    var body: some View {
        VStack {
            TextField("Score", value: $score, format: .number)
                .textFieldStyle(.roundedBorder)
                .frame(width: 75, height: 50)
                .offset(x: 100, y: 10)
            
            HStack {
                
                
                Text("Score:")
                    .font(.system(size:18, weight: .bold))
                Text("\(score)")
                    .font(.system(size:20, weight: .bold))
                    .foregroundColor(.yellow)
            }
        }
    }
}









//prototipo player entry

struct playerEntry: View {
    var image: String
    var testo: String
    var azione: () -> Void
    var playerpoints: Int
    var rank: Int
    var playerBadge: String
    var body: some View {
        
        
        ZStack {
            Rectangle()
                .fill(Color(red: 0.231, green: 0.447, blue:0.945))
                .frame(width: 320, height: 100)
                .cornerRadius(15)
                .shadow(radius: 0.0, x: 0.0, y: 10.0)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(.black, lineWidth: 2)
                )
            HStack {
                Image("\(image)")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 75, height: 75)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .offset(x:-110, y:0)
                
                
            }
            if rank == 1 {
                Image(systemName: "rosette")
                    .font(.system(size: 30))
                    .foregroundColor(.yellow)
                    .offset(x: -140, y: -25)
            }
            if rank == 2 {
                Image(systemName: "rosette")
                    .font(.system(size: 30))
                    .foregroundColor(Color(red: 0.7, green: 0.7, blue:0.7))
                    .offset(x: -140, y: -25)
            }
            if rank == 3 {
                Image(systemName: "rosette")
                    .font(.system(size: 30))
                    .foregroundColor(Color(red: 0.68, green: 0.39, blue:0.0))
                    .offset(x: -140, y: -25)
            }
            Text(testo)
                .font(.system(size:18, weight: .bold))
                .foregroundColor(.white)
                .offset(x:-10, y:-15)
            
            textboxView() //textbox to insert score
            
            
        }
        
        
    }
    
}




#Preview {
    RankingView_()
}


