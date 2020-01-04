//
//  OpenVPNAdapter+Hidden.h
//  Multiplayer for Minecraft PE
//
//  Created by Sergey Abramchuk on 07.07.17.
//  Copyright © 2017 Gutch. All rights reserved.
//

@import Foundation;

#import <OpenVPNAdapter/OpenVPNAdapter.h>

@interface OpenVPNAdapter ()

- (void)writeVPNPackets:(NSArray<NSData *> *)packets protocols:(NSArray<NSNumber *> *)protocols;

@end
