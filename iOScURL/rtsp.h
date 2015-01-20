//
//  rtsp.h based on rtsp.c
//  iOScURL
//
//  Created by Paul Uhn on 1/20/15.
//  Copyright (c) 2015 Paul Uhn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface rtsp : NSObject
- (void)start:(NSString *)rstpUrl; // rtsp://<server>:<port>/<app>/<stream>
@end
