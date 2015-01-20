//
//  H264Stream.h based on H264Stream.java, RTSPClientConnection.mm
//  libstreaming, encoderdemo
//
//  Created by Paul Uhn on 1/20/15.
//  Copyright (c) 2015 Paul Uhn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface H264Stream : NSObject
+ (NSString *)getSessionDescription:(NSData *)config;
@end
