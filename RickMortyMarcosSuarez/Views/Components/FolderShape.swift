//
//  FolderShape.swift
//  RickMortyMarcosSuarez
//
//  Created by Marcos Suarez Ayala on 2/11/25.
//

import SwiftUI

struct FolderShape: Shape {
    let tabWidthRatio: CGFloat = 0.40
    let tabHeightRatio: CGFloat = 0.10
    let tabCornerRadius: CGFloat = 4
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Calcular dimensiones
        let tabWidth = rect.width * tabWidthRatio
        let tabHeight = rect.height * tabHeightRatio
        let tabXStart = (rect.width - tabWidth) / 2
        let tabXEnd = tabXStart + tabWidth
        let bodyTopY = rect.minY + tabHeight
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        
        // Dibujar el cuerpo de la carpeta
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: bodyTopY))
        
        // Dibujar la pestaña (Tab)
        path.addLine(to: CGPoint(x: tabXEnd, y: bodyTopY))
        path.addLine(to: CGPoint(x: tabXEnd, y: rect.minY + tabCornerRadius))
        path.addArc(
            center: CGPoint(x: tabXEnd - tabCornerRadius, y: rect.minY + tabCornerRadius),
            radius: tabCornerRadius,
            startAngle: .degrees(0),
            endAngle: .degrees(-90),
            clockwise: true
        )
        path.addLine(to: CGPoint(x: tabXStart + tabCornerRadius, y: rect.minY))
        path.addArc(
            center: CGPoint(x: tabXStart + tabCornerRadius, y: rect.minY + tabCornerRadius),
            radius: tabCornerRadius,
            startAngle: .degrees(-90),
            endAngle: .degrees(-180),
            clockwise: true
        )
        path.addLine(to: CGPoint(x: tabXStart, y: bodyTopY))
        path.addLine(to: CGPoint(x: rect.minX, y: bodyTopY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        
        return path
    }
}

#Preview {
    FolderShape()
        .fill(.green)
        .stroke(Color.black, lineWidth: 5)
        .frame(width: .infinity, height: .infinity)
        .padding(20)
}
