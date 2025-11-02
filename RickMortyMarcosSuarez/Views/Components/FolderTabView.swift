//
//  FolderTabView.swift
//  RickMortyMarcosSuarez
//
//  Created by Marcos Suarez Ayala on 1/11/25.
//

import SwiftUI

struct TabData: Identifiable {
    let id = UUID()
    let title: String
    let view: AnyView
}

struct FolderTabView: View {
    let tabs: [TabData]
    let folderColor: Color
    var textTabColor: Color = .primary
    @State private var selectedTabIndex: Int = 0
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(tabs.indices, id: \.self) { index in
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedTabIndex = index
                            }
                        }) {
                            FolderTabItem(
                                title: tabs[index].title,
                                isSelected: index == selectedTabIndex,
                                folderColor: folderColor,
                                textTabColor: textTabColor
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            tabs[selectedTabIndex].view
                .frame(maxWidth: .infinity)
                .background(folderColor)
        }
    }
}

private struct FolderTabItem: View {
    let title: String
    let isSelected: Bool
    let folderColor: Color
    let textTabColor: Color
    
    private let cornerRadius: CGFloat = 20
    
    private var bottomBorderColor: Color {
        isSelected ? folderColor : folderColor.opacity(0.5)
    }
    
    private var backgroundColor: Color {
        isSelected ? folderColor : folderColor.opacity(0.5)
    }
    
    private var textColor: Color {
        isSelected ? textTabColor : textTabColor.opacity(0.5)
    }
    
    var body: some View {
        Text(title)
            .font(.headline)
            .foregroundColor(textColor)
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
            .background(backgroundColor)
            .clipShape(
                UnevenRoundedRectangle(
                    topLeadingRadius: cornerRadius,
                    bottomLeadingRadius: 0,
                    bottomTrailingRadius: 0,
                    topTrailingRadius: cornerRadius
                )
            )
    }
}


#Preview {
    let vistasDeCarpetas: [TabData] = [
        TabData(title: "Introducción", view: AnyView(ContenidoVista(texto: "Vista Principal", color: .yellow))),
        TabData(title: "Configuración Avanzada", view: AnyView(ContenidoVista(texto: "Opciones del Sistema", color: .green))),
        TabData(title: "Reportes Anuales Larguísimo", view: AnyView(ContenidoVista(texto: "Datos y Estadísticas", color: .teal))),
        TabData(title: "Ayuda", view: AnyView(ContenidoVista(texto: "Soporte Técnico", color: .red))),
        TabData(title: "Mi Perfil", view: AnyView(ContenidoVista(texto: "Información Personal", color: .orange)))
    ]
    
    FolderTabView(tabs: vistasDeCarpetas, folderColor: .gray)
        .padding(24)
}

struct ContenidoVista: View {
    let texto: String
    let color: Color
    
    var body: some View {
        ZStack {
            Text(texto)
                .font(.largeTitle)
                .shadow(radius: 1)
                .foregroundColor(color)
                .padding(.horizontal, 16)
                .padding(.vertical, 30)
                .background(color.opacity(0.3))
                .padding(8)
        }
    }
}
