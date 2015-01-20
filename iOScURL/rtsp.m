//
//  rtsp.m based on rtsp.c
//  iOScURL
//
//  Created by Paul Uhn on 1/20/15.
//  Copyright (c) 2015 Paul Uhn. All rights reserved.
//

#import "rtsp.h"
#import "curl/curl.h"

#define VERSION_STR  "V1.0"

/* error handling macros */
#define my_curl_easy_setopt(A, B, C) \
if ((res = curl_easy_setopt((A), (B), (C))) != CURLE_OK) \
fprintf(stderr, "curl_easy_setopt(%s, %s, %s) failed: %d\n", \
#A, #B, #C, res);

#define my_curl_easy_perform(A) \
if ((res = curl_easy_perform((A))) != CURLE_OK) \
fprintf(stderr, "curl_easy_perform(%s) failed: %d\n", #A, res);


/* send RTSP OPTIONS request */
static void rtsp_options(CURL *curl, const char *uri)
{
    CURLcode res = CURLE_OK;
    printf("\nRTSP: OPTIONS %s\n", uri);
    my_curl_easy_setopt(curl, CURLOPT_RTSP_STREAM_URI, uri);
    my_curl_easy_setopt(curl, CURLOPT_RTSP_REQUEST, (long)CURL_RTSPREQ_OPTIONS);
    my_curl_easy_perform(curl);
}


/* send RTSP DESCRIBE request and write sdp response to a file */
static void rtsp_describe(CURL *curl, const char *uri,
                          const char *sdp_filename)
{
    CURLcode res = CURLE_OK;
    FILE *sdp_fp = fopen(sdp_filename, "wt");
    printf("\nRTSP: DESCRIBE %s\n", uri);
    if (sdp_fp == NULL) {
        fprintf(stderr, "Could not open '%s' for writing\n", sdp_filename);
        sdp_fp = stdout;
    }
    else {
        printf("Writing SDP to '%s'\n", sdp_filename);
    }
    my_curl_easy_setopt(curl, CURLOPT_WRITEDATA, sdp_fp);
    my_curl_easy_setopt(curl, CURLOPT_RTSP_REQUEST, (long)CURL_RTSPREQ_DESCRIBE);
    my_curl_easy_perform(curl);
    my_curl_easy_setopt(curl, CURLOPT_WRITEDATA, stdout);
    if (sdp_fp != stdout) {
        fclose(sdp_fp);
    }
}

/* send RTSP SETUP request */
static void rtsp_setup(CURL *curl, const char *uri, const char *transport)
{
    CURLcode res = CURLE_OK;
    printf("\nRTSP: SETUP %s\n", uri);
    printf("      TRANSPORT %s\n", transport);
    my_curl_easy_setopt(curl, CURLOPT_RTSP_STREAM_URI, uri);
    my_curl_easy_setopt(curl, CURLOPT_RTSP_TRANSPORT, transport);
    my_curl_easy_setopt(curl, CURLOPT_RTSP_REQUEST, (long)CURL_RTSPREQ_SETUP);
    my_curl_easy_perform(curl);
}


/* send RTSP PLAY request */
static void rtsp_play(CURL *curl, const char *uri, const char *range)
{
    CURLcode res = CURLE_OK;
    printf("\nRTSP: PLAY %s\n", uri);
    my_curl_easy_setopt(curl, CURLOPT_RTSP_STREAM_URI, uri);
    my_curl_easy_setopt(curl, CURLOPT_RANGE, range);
    my_curl_easy_setopt(curl, CURLOPT_RTSP_REQUEST, (long)CURL_RTSPREQ_PLAY);
    my_curl_easy_perform(curl);
}


/* send RTSP TEARDOWN request */
static void rtsp_teardown(CURL *curl, const char *uri)
{
    CURLcode res = CURLE_OK;
    printf("\nRTSP: TEARDOWN %s\n", uri);
    my_curl_easy_setopt(curl, CURLOPT_RTSP_REQUEST, (long)CURL_RTSPREQ_TEARDOWN);
    my_curl_easy_perform(curl);
}


/* convert url into an sdp filename */
static void get_sdp_filename(const char *url, char *sdp_filename)
{
    const char *s = strrchr(url, '/');
    strcpy(sdp_filename, "video.sdp");
    if (s != NULL) {
        s++;
        if (s[0] != '\0') {
            sprintf(sdp_filename, "%s.sdp", s);
        }
    }
}


/* scan sdp file for media control attribute */
static void get_media_control_attribute(const char *sdp_filename,
                                        char *control)
{
    int max_len = 256;
    char *s = malloc(max_len);
    FILE *sdp_fp = fopen(sdp_filename, "rt");
    control[0] = '\0';
    if (sdp_fp != NULL) {
        while (fgets(s, max_len - 2, sdp_fp) != NULL) {
            sscanf(s, " a = control: %s", control);
        }
        fclose(sdp_fp);
    }
    free(s);
}

@implementation rtsp

@end
