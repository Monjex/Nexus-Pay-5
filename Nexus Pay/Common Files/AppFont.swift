//
//  AppFont.swift
//  Nexus Pay
//
//  Created by Tushar Fialok on 19/01/23.
//

import Foundation
import UIKit

enum FontsStyles {
    case medium(Int)
    case bold(Int)
    case regular(Int)
}

enum Fonts {
    
    case poppins(FontsStyles)
    
    case medium(Int)
    case bold(Int)
    case regular(Int)
    
    var getFont: UIFont {
        get {
            switch self {
            case .medium(let size):
                return UIFont(name: "Poppins-Medium", size: CGFloat(size))!
                
            case .regular(let size):
                return UIFont(name: "Poppins-Regular", size: CGFloat(size))!
                
            case .bold(let size):
                return UIFont(name: "Poppins-Bold", size: CGFloat(size))!
                
            case .poppins(let font):
                switch font {
                case .medium(let size):
                    return UIFont(name: "Poppins-Medium", size: CGFloat(size))!
                    
                default:
                    return .systemFont(ofSize: 17)
                }
                
            default:
                return UIFont(name: "Poppins", size: 18)!
            }
        }
    }
}
