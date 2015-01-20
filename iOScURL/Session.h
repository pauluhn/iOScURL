//
//  Session.h based on Session.java
//  libstreaming
//
//  Created by Paul Uhn on 1/20/15.
//  Copyright (c) 2015 Paul Uhn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Session : NSObject
+ (NSString *)getSessionDescription:(NSString *)ip config:(NSData *)config;
@end
