//
//  DetailView.swift
//  Bashneft
//
//  Created by Руслан Ишмухаметов on 23.03.2023.
//

import SwiftUI

struct DetailView: View {
    
    @Binding var show: Bool
    var animation: Namespace.ID
    var investigation: Investigation
    
    // View prorerties
    @State private var animateContent: Bool = false
    @State private var offsetAnimation: Bool = false
    
    var body: some View {
        VStack {
            // Clouse button
            Button {
                withAnimation(.easeOut(duration: 0.2)) {
                    offsetAnimation = false
                }
                withAnimation(.easeInOut(duration: 0.35).delay(0.1)) {
                    animateContent = false
                    show = false
                }
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .containerShape(Rectangle())
            }
            .padding([.leading, .vertical], 15)
            .frame(maxWidth: .infinity, alignment: .leading)
            .opacity(animateContent ? 1 : 0)
            
            
            // Preview
            GeometryReader {
                let size = $0.size
                
                HStack(spacing: 20) {
                    Image(investigation.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: (size.width - 30) / 2, height: size.height)
                        .clipShape(CustomCorners(corners: [.topRight, .bottomRight], radius: 20))
                    //MatchedGeometry ID
                        .matchedGeometryEffect(id: investigation.id, in: animation)
                    
                    // Investigation Details
                    VStack(alignment: .leading, spacing: 8) {
                        Text(investigation.name)
                            .font(.title)
                            .fontWeight(.semibold)
                        
                        Text(investigation.fullName)
                            .font(.callout)
                            .foregroundColor(.gray)
                        
                        RatingView(rating: investigation.rating)
                    }
                    .padding(.trailing, 15)
                    .padding(.top, 30)
                    .offset(y: offsetAnimation ? 0 : 100)
                    .opacity(offsetAnimation ? 1 : 0)
                    
                    
                }
            }
            .frame(height: 220)
            .zIndex(1)
            
            Rectangle()
                .fill(.gray.opacity(0.04))
                .ignoresSafeArea()
                .overlay(alignment: .top, content: {
                    InvestigationDetails()
                })
                .padding(.leading, 30)
                .padding(.top, -180)
                .zIndex(0)
                .opacity(animateContent ? 1 : 0)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background {
            Rectangle()
                .fill(.white)
                .ignoresSafeArea()
                .opacity(animateContent ? 1 : 0)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.35)) {
                animateContent = true
            }
            
            withAnimation(.easeInOut(duration: 0.35).delay(0.1)) {
                offsetAnimation = true
            }
        }
    }
    
    @ViewBuilder
    func InvestigationDetails() -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Button {
                    
                } label: {
                    Label("Reviews", systemImage: "text.alignleft")
                        .font(.callout)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                
                Button {
                    
                } label: {
                    Label("Like", systemImage: "suit.heart")
                        .font(.callout)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                
                Button {
                    
                } label: {
                    Label("Share", systemImage: "square.and.arrow.up")
                        .font(.callout)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
            }
            
            Divider()
                .padding(.top, 25)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 15) {
                    Text("О методе исследований")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Данный вид исследований заплючается в остановке добывающей скважины, и контроле забойного давления с помощью глубинных манометров. Метод позволяет оценить пластовое давление и ФЕС пласта. Длительность остановки скважины для исследований определяется исходя из свойств пласта и флюида, до выхода на радиальный режим фильтрации")
                        .font(.callout)
                        .foregroundColor(.gray)
                }
                .padding(.bottom, 15)
                .padding(.top, 20)
            }
            
            // Show AR model button
            Button {
                
            } label: {
                Text("Посмотреть в 3D")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 45)
                    .padding(.vertical, 10)
                    .background {
                        Capsule()
                            .fill(Color("Blue").gradient)
                    }
                    .foregroundColor(.white)
            }
            .padding(.bottom, 15)
        }
        .padding(.top, 180)
        .padding([.horizontal, .top], 15)
        .offset(y: offsetAnimation ? 0 : 100)
        .opacity(offsetAnimation ? 1 : 0)
    }
}


struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
