//
//  Home.swift
//  Bashneft
//
//  Created by Руслан Ишмухаметов on 22.03.2023.
//

import SwiftUI

struct Home: View {
    
    @State private var activeType: String = "ГДИ"
    @State private var carouselMode: Bool = false
    
    // Detail View Properties
    @State private var showDetailView: Bool = false
    @State private var selectedInvestigation: Investigation?
    @State private var animateCurrentInvestigation: Bool = false

    @Namespace private var animation
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Browse")
                    .font(.largeTitle.bold())
                Text("Recomended")
                    .fontWeight(.semibold)
                    .padding(.leading, 15)
                    .foregroundColor(.gray)
                    .offset(y: 2)
                
                Spacer(minLength: 10)
                
                Menu {
                    Button("Toggle carusel mode (\(carouselMode ? "On": "Off"))") {
                        carouselMode.toggle()
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .rotationEffect(.init(degrees: -90))
                        .foregroundColor(.gray)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 15)
            
            TypesView()
            
            GeometryReader {
                let size = $0.size
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    // Investigarion Card View
                    VStack(spacing: 35) {
                        ForEach(sampleInvestigations) { investigation in
                            InvestigationCardView(investigation)
                            
                            // Opening detail view
                                .onTapGesture {
                                    withAnimation(.easeOut(duration: 0.35)) {
                                        animateCurrentInvestigation = true
                                        selectedInvestigation = investigation

                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                        withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                                            showDetailView = true
                                        }
                                    }

                                }
                        }
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 20)
                    .padding(.bottom, bottompadding(size))
                    .background {
                        ScrollViewDetector(carouselMode: $carouselMode, totalCardFound: sampleInvestigations.count)
                    }

                }
                .coordinateSpace(name: "SCROLLVIEW")
            }
            
            .padding(.top, 15)
        }
        .overlay {
            if let selectedInvestigation, showDetailView {
                DetailView(show: $showDetailView,animation: animation, investigation: selectedInvestigation)
                // For more fluent animation
                    .transition(.asymmetric(insertion: .identity, removal: .offset(y: 5)))
            }
        }
        .onChange(of: showDetailView) { newValue in
            if !newValue {
                // Reseting animation
                withAnimation(.easeInOut(duration: 0.15).delay(0.4)) {
                    animateCurrentInvestigation = false
                }
            }
        }
    }
    
    // Bottom padding for last card to move up to the top
    func bottompadding(_ size: CGSize = .zero) -> CGFloat {
        let cardHeight: CGFloat = 220
        let scrollViewHeight: CGFloat = size.height
        
        return scrollViewHeight - cardHeight - 40
    }
    
    // Investigarion Card View
    @ViewBuilder
    func InvestigationCardView(_ investigation: Investigation) -> some View {
        GeometryReader {
            let size = $0.size
            let rect = $0.frame(in: .named("SCROLLVIEW"))
            
            HStack(spacing: -25) {
                // Detail Card
                VStack(alignment: .leading, spacing: 6) {
                    Text(investigation.name)
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Text(investigation.fullName)
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    // Rating View
                    RatingView(rating: investigation.rating)
                        .padding(.top, 10)
                    
                    Spacer(minLength: 10)
                    
                    HStack(spacing: 4) {
                        Text("\(investigation.count)")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                        
                        Text("выполнено")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Spacer(minLength: 0)
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .padding(20)
                .frame(width: size.width / 2, height: size.height * 0.8)
                .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.white)
                        .shadow(color: .black.opacity(0.08), radius: 8, x: 5, y: 5)
                        .shadow(color: .black.opacity(0.08), radius: 8, x: -5, y: -5)

                }
                .zIndex(1)
                
                // Moving investigation
                .offset(x: animateCurrentInvestigation && selectedInvestigation?.id == investigation.id ? -20 : 0)
                
                // Cover Image
                ZStack {
                    if !(showDetailView && selectedInvestigation?.id == investigation.id) {
                        Image(investigation.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width / 2, height: size.height)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            // Matched Geometry ID
                            .matchedGeometryEffect(id: investigation.id, in: animation)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: -5, y: -5)

                    }

                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            }
            .frame(width: size.width)
            .rotation3DEffect(.init(degrees: convertOffsetToRotation(rect)), axis: (x: 1, y: 0, z: 0), anchor: .bottom, anchorZ: 1, perspective: 0.8)
        }
        .frame(height: 220)
    }
    
    // Convering minY to Rotation
    func convertOffsetToRotation(_ rect: CGRect) -> CGFloat {
        let cardHeight = rect.height + 20
        let minY = rect.minY - 20
        let progress = minY < 0 ? (minY / cardHeight) : 0
        let constraitedProgress = min(-progress, 1.0)
        return (constraitedProgress * 90)
    }

    // Tags View
    @ViewBuilder
    func TypesView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(types, id: \.self) { type in
                    Text(type)
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 5)
                        .background {
                            if activeType == type {
                                Capsule()
                                    .fill(Color("Blue"))
                                    .matchedGeometryEffect(id: "ACTIBETYPE", in: animation)
                            } else {
                                Capsule()
                                    .fill(.gray.opacity(0.2))
                            }
                        }
                        .foregroundColor(activeType == type ? .white : .gray)
                        .onTapGesture {
                            withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.7)) {
                                activeType = type
                            }
                        }
                }
            }
            .padding(.horizontal, 15)
        }
    }
}

// Sample Types

var types: [String] = [
    "ГДИ", "ПГИ", "Hi-tech", "Химия",
]

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



