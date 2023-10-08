//
//  PreferenceTest.swift
//  SwiftfulThinkingAdvanced
//
//  Created by Павел Бескоровайный on 04.10.2023.
//

import SwiftUI

extension PreferenceKey {
  static func reduce<T>(value: inout T, nextValue: () -> T) {
    value = nextValue()
  }
}
