//
//  OffsetKey.swift
//  TaskManagement
//
//  Created by Jacek Kosinski U on 26/09/2023.
//

import SwiftUI

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
