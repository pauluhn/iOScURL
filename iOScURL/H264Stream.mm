//
//  H264Stream.mm based on H264Stream.java, RTSPClientConnection.mm
//  libstreaming, encoderdemo
//
//  Created by Paul Uhn on 1/20/15.
//  Copyright (c) 2015 Paul Uhn. All rights reserved.
//

#import "H264Stream.h"
#import "NALUnit.h"

static const char* Base64Mapping = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

NSString* encodeLong(unsigned long val, int nPad)
{
    char ch[4];
    int cch = 4 - nPad;
    for (int i = 0; i < cch; i++)
    {
        int shift = 6 * (cch - (i+1));
        int bits = (val >> shift) & 0x3f;
        ch[i] = Base64Mapping[bits];
    }
    for (int i = 0; i < nPad; i++)
    {
        ch[cch + i] = '=';
    }
    NSString* s = [[NSString alloc] initWithBytes:ch length:4 encoding:NSUTF8StringEncoding];
    return s;
}

NSString* encodeToBase64(NSData* data)
{
    NSString* s = @"";
    
    const uint8_t* p = (const uint8_t*) [data bytes];
    int cBytes = (int)[data length];
    while (cBytes >= 3)
    {
        unsigned long val = (p[0] << 16) + (p[1] << 8) + p[2];
        p += 3;
        cBytes -= 3;
        
        s = [s stringByAppendingString:encodeLong(val, 0)];
    }
    if (cBytes > 0)
    {
        int nPad;
        unsigned long val;
        if (cBytes == 1)
        {
            // pad 8 bits to 2 x 6 and add 2 ==
            nPad = 2;
            val = p[0] << 4;
        }
        else
        {
            // must be two bytes -- pad 16 bits to 3 x 6 and add one =
            nPad = 1;
            val = (p[0] << 8) + p[1];
            val = val << 2;
        }
        s = [s stringByAppendingString:encodeLong(val, nPad)];
    }
    return s;
}

@implementation H264Stream

+ (NSString *)getSessionDescription:(NSData *)config
{
    avcCHeader avcC((const BYTE*)[config bytes], (int)[config length]);
    SeqParamSet seqParams;
    seqParams.Parse(avcC.sps());

    NSString* profile_level_id = [NSString stringWithFormat:@"%02x%02x%02x", seqParams.Profile(), seqParams.Compat(), seqParams.Level()];
    
    NSData* data = [NSData dataWithBytes:avcC.sps()->Start() length:avcC.sps()->Length()];
    NSString* sps = encodeToBase64(data);
    data = [NSData dataWithBytes:avcC.pps()->Start() length:avcC.pps()->Length()];
    NSString* pps = encodeToBase64(data);

    NSString *mSessionDescription = [NSString string];
    mSessionDescription = [mSessionDescription stringByAppendingString:@"m=video 0 RTP/AVP 96\r\n"];
    mSessionDescription = [mSessionDescription stringByAppendingString:@"a=rtpmap:96 H264/90000\r\n"];
    mSessionDescription = [mSessionDescription stringByAppendingFormat:@"a=fmtp:96 packetization-mode=1;profile-level-id=%@;sprop-parameter-sets=%@,%@;\r\n", profile_level_id, sps, pps];
    return mSessionDescription;
}

@end
