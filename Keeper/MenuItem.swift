//
//  MenuItem.swift
//  Keeper2
//
//  Created by 杨寿来 on 2024/4/1.
//

import SwiftUI

struct MenuItem<Content:View>: View {
    @State var hc:Color
    
    var hoverColor:Color
    
    var padding : CGFloat = 4

    var content: () -> Content
    
    var onClickAction: ()->Void
    
    init(_ hoverColor: Color = Color.gray, padding: CGFloat = 4, action: @escaping ()->Void = {},  @ViewBuilder content: @escaping () -> Content) {
        self.hoverColor = hoverColor
        self.padding = padding
        self.content = content
        self.hc = self.hoverColor.opacity(0)
        self.onClickAction = action
    }
    
    var body: some View {
        HStack(content: content)
            .padding(.all, padding)
            .background(hc)
            .cornerRadius(4)
            .onHover(perform: { hovering in
                if hovering{
                    hc = hoverColor.opacity(0.3)
                }else{
                    hc = hoverColor.opacity(0)
                }
            }).onTapGesture {
                onClickAction()
            }
        
    }
}

