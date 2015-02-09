//
//  BitMasks.swift
//  Pong
//
//  Created by Jens Sproede (OEV) on 09.02.15.
//  Copyright (c) 2015 OEV. All rights reserved.
//

import Foundation

struct BitMasks {
    static let none:UInt32 = 0
    static let World:UInt32 = UINT32_MAX
    static let TopBorder:UInt32 = 0b1
    static let BottomBorder:UInt32 = 0b10
    static let Ball:UInt32 = 0b100
    static let Player:UInt32 = 0b1000
}