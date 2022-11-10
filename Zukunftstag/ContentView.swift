//
//  ContentView.swift
//  Zukunftstag
//
//  Created by Alain Stulz on 10.11.22.
//

import SwiftUI
import MapKit

struct ContentView: View {
    var body: some View {
        TabView {
            FlorentinView()
                .tabItem({
                    Label("Florentin", systemImage: "house")
                })
            FabriceView()
                .tabItem({
                    Label("Fabrice", systemImage: "banknote")
                })
            AyanView()
                .tabItem({
                    Label("Ayan", systemImage: "map")
                })
        }
    }
}

struct MapItem: Identifiable {
    let id: UUID = UUID()
    let coordinate = CLLocationCoordinate2D(latitude: 47.378643758162404,
                                            longitude: 8.524531325492308)
}

struct AyanView: View {
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 47.378643758162404,
                                       longitude: 8.524531325492308),
        latitudinalMeters: 100,
        longitudinalMeters: 100
    )
    
    @State private var text = ""

    var body: some View {
        VStack {
            Map(coordinateRegion: $region, annotationItems: [MapItem()]) { item in
                MapPin(coordinate: item.coordinate)
            }
        }
    }
}

struct FlorentinView: View {
    @State private var color: Color = Color.black
    
    let secretCode: String = "1234"
    @State private var enteredCode: String = ""
    
    let colors: [Color] = [.yellow, .red, .green, .blue]
    
    var body: some View {
        VStack {
            if enteredCode == secretCode {
                VStack {
                    Circle()
                        .fill(.angularGradient(.init(colors: colors),
                                               center: .center,
                                               startAngle: .degrees(0),
                                               endAngle: .degrees(360)))
                    
                    Button("Ausloggen", action: {
                        enteredCode = ""
                    })
                }
            } else {
                Text("Dein Code:")
                TextField("Code", text: $enteredCode)
                    .keyboardType(.numberPad)
            }
        }.padding(.horizontal, 60)
    }
}

struct FabriceView: View {
    @State private var showingUeberweisen = false
    @State private var showingKontostand = false
    
    @State private var balance: Int = 300
    
    @State private var destination: String = ""
    
    @State private var errorMessage: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                NavigationLink(isActive: $showingUeberweisen,
                               destination: {
                    VStack {
                        Text("100 CHF überweisen an:")
                        TextField("Empfänger", text: $destination)
                        Button("Senden", action: {
                            if balance >= 100 {
                                balance -= 100
                            } else {
                                errorMessage = "Du kannst nicht mehr überweisen als du hast!"
                            }
                        })
                        
                        Text(errorMessage)
                    }
                }, label: {Text("Überweisen")})
                
                NavigationLink(isActive: $showingKontostand,
                               destination: {
                    Text("Dein Kontostand: \(balance)")
                }, label: {Text("Kontostand")})
                
                
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
