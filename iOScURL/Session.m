//
//  Session.m based on Session.java
//  libstreaming
//
//  Created by Paul Uhn on 1/20/15.
//  Copyright (c) 2015 Paul Uhn. All rights reserved.
//

#import "Session.h"
#import "AACStream.h"
#import "H264Stream.h"

@implementation Session

+ (NSString *)getSessionDescription:(NSString *)ip config:(NSData *)config
{
    NSString *sessionDescription = [NSString string];
    sessionDescription = [sessionDescription stringByAppendingString:@"v=0\r\n"];
    // TODO: Add IPV6 support
    long uptime = [[NSDate date] timeIntervalSince1970] * 1000; // milliseconds
    long mTimestamp = (uptime/1000)<<32 & (((uptime-((uptime/1000)*1000))>>32)/1000); // NTP timestamp
    NSString *mOrigin = @"127.0.0.1";
    sessionDescription = [sessionDescription stringByAppendingFormat:@"o=- %ld %ld IN IP4 %@\r\n", mTimestamp, mTimestamp, mOrigin];
    sessionDescription = [sessionDescription stringByAppendingString:@"s=Unnamed\r\n"];
    sessionDescription = [sessionDescription stringByAppendingString:@"i=N/A\r\n"];
    sessionDescription = [sessionDescription stringByAppendingString:[NSString stringWithFormat:@"c=IN IP4 %@\r\n", ip]];
    // t=0 0 means the session is permanent (we don't know when it will stop)
    sessionDescription = [sessionDescription stringByAppendingString:@"t=0 0\r\n"];
    sessionDescription = [sessionDescription stringByAppendingString:@"a=recvonly\r\n"];
    sessionDescription = [sessionDescription stringByAppendingString:[AACStream getSessionDescription]];
    sessionDescription = [sessionDescription stringByAppendingString:@"a=control:trackID=0\r\n"];
    sessionDescription = [sessionDescription stringByAppendingString:[H264Stream getSessionDescription:config]];
    sessionDescription = [sessionDescription stringByAppendingString:@"a=control:trackID=1\r\n"];
    return sessionDescription;
}

@end
