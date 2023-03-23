//
//  RatingView.swift
//  Bashneft
//
//  Created by Руслан Ишмухаметов on 23.03.2023.
//

import SwiftUI

struct RatingView: View {
    
    var rating: Int
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...5, id: \.self) { index in
                Image(systemName: "star.fill")
                    .font(.caption2)
                    .foregroundColor(index <= rating ? .yellow: .gray.opacity(0.5))
            }
            
            Text("\(rating)")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.yellow)
                .padding(.leading, 5)
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(rating: 4)
    }
}
