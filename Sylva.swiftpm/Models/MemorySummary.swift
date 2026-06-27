//
//  MemorySummary.swift
//  Final
//
//  Created by GEU on 17/02/26.
//

import Foundation
import FoundationModels

//To store summary of conversation for the card in galleryview
@available(iOS 26.0, *)
@Generable
struct MemorySummary {
    @Guide(description: "A 2-line emotional memory reminder")
    let summary: String
}
