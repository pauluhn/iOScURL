//
//  AACStream.m based on AACStream.java
//  libstreaming
//
//  Created by Paul Uhn on 1/20/15.
//  Copyright (c) 2015 Paul Uhn. All rights reserved.
//

#import "AACStream.h"

@implementation AACStream

+ (NSString *)getSessionDescription
{
    // All the MIME types parameters used here are described in RFC 3640
    // SizeLength: 13 bits will be enough because ADTS uses 13 bits for frame length
    // config: contains the object type + the sampling rate + the channel number
    
    // TODO: streamType always 5 ? profile-level-id always 15 ?
    
    int mProfile = 2; // AAC LC
    int mSamplingRateIndex = 4; // 44100
    int mChannel = 1;
    int mConfig = (mProfile & 0x1F) << 11 | (mSamplingRateIndex & 0x0F) << 7 | (mChannel & 0x0F) << 3;
    
    NSString *mSessionDescription = [NSString string];
    mSessionDescription = [mSessionDescription stringByAppendingString:@"m=audio 0 RTP/AVP 96\r\n"];
    mSessionDescription = [mSessionDescription stringByAppendingString:@"a=rtpmap:96 mpeg4-generic/44100\r\n"];
    mSessionDescription = [mSessionDescription stringByAppendingFormat:@"a=fmtp:96 streamtype=5; profile-level-id=15; mode=AAC-hbr; config=%x; SizeLength=13; IndexLength=3; IndexDeltaLength=3;\r\n", mConfig];
    return mSessionDescription;
}

@end
