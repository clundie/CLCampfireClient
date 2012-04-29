//
//  CLStreamingJSONFetcher.m
//  Campfire client
//
//  Created by Chris Lundie on 04/Apr/2012.
//  Copyright (c) 2012 Chris Lundie. All rights reserved.
//


#import "CLStreamingJSONFetcher.h"
#import "NSData+Base64.h"
#import <math.h>


static const NSTimeInterval _requestTimeoutInterval = 60.0;
static const NSTimeInterval _minRetryInterval = 10.0;
static const NSTimeInterval _maxRetryInterval = 240.0;
static NSData *_crData = nil;


@interface CLStreamingJSONFetcher () <NSURLConnectionDelegate>
{
    NSURL *_URL;
    NSURLConnection *_connection;
    NSTimeInterval _nextRetryInterval;
    NSTimer *_retryTimer;
    NSMutableData *_receivedData;
    NSURLResponse *_response;
    BOOL _responseIsSuccessful;
}

- (void)startRetryTimer;
- (void)retryTimerFired:(NSTimer *)timer;
- (void)signRequest:(NSMutableURLRequest *)request;

@end


@implementation CLStreamingJSONFetcher

@synthesize receivedObjectBlock = _receivedObjectBlock;
@synthesize URLCredential = _URLCredential;
@synthesize connectedBlock = _connectedBlock;

- (id)initWithURL:(NSURL *)URL
{
    if (URL == nil) {
        [NSException raise:NSInvalidArgumentException format:@"URL cannot be nil"];
        return nil;
    }
    self = [super init];
    if (self != nil) {
        _URL = [URL copy];
    }
    return self;
}

- (void)dealloc
{
    [_connection cancel];
    [_retryTimer invalidate];
}

- (BOOL)beginFetch
{
    [self stopFetching];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:_URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:_requestTimeoutInterval];
    [request setHTTPShouldHandleCookies:NO];
    [self signRequest:request];
    _nextRetryInterval = _minRetryInterval;
    _receivedData = [NSMutableData dataWithCapacity:4096];
    _responseIsSuccessful = NO;
    _connection = [NSURLConnection connectionWithRequest:request delegate:self];
    return _connection != nil;
}

- (void)stopFetching
{
    [_connection cancel];
    _connection = nil;
    [_retryTimer invalidate];
    _retryTimer = nil;
    _receivedData = nil;
    _response = nil;
}

- (void)startRetryTimer {
    NSTimeInterval interval;
    if (_response != nil) {
        interval = _nextRetryInterval;
        _nextRetryInterval = fmin(_nextRetryInterval * 2.0, _maxRetryInterval);
    } else {
        interval = _minRetryInterval;
        _nextRetryInterval = _minRetryInterval;
    }
    [_retryTimer invalidate];
    _retryTimer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(retryTimerFired:) userInfo:nil repeats:NO];
}

- (void)retryTimerFired:(NSTimer *)timer {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:_URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:_requestTimeoutInterval];
    [request setHTTPShouldHandleCookies:NO];
    [self signRequest:request];
    _receivedData = [NSMutableData dataWithCapacity:4096];
    _response = nil;
    _responseIsSuccessful = NO;
    _connection = [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)signRequest:(NSMutableURLRequest *)request
{
    if (self.URLCredential != nil) {
        NSString *auth = [[[NSString stringWithFormat:@"%@:%@", [self.URLCredential user], ([self.URLCredential hasPassword] ? [self.URLCredential password] : @"")] dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString];
        [request setValue:[NSString stringWithFormat:@"Basic %@", auth] forHTTPHeaderField:@"Authorization"];
    }
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _response = [response copy];
    [_receivedData setLength:0];
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSInteger statusCode = [((NSHTTPURLResponse *)response) statusCode];
        if ((statusCode == 200) && [[response MIMEType] isEqualToString:@"application/json"]) {
            _responseIsSuccessful = YES;
            if (self.connectedBlock != nil) {
                self.connectedBlock();
            }
        }
    }
    if (!_responseIsSuccessful) {
        [self startRetryTimer];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_receivedData appendData:data];
    if (_responseIsSuccessful && ([data length] > 0)) {
        NSUInteger countOfPadding = 0;
        const char *receivedBytes = [_receivedData bytes];
        NSUInteger length = [_receivedData length];
        for (NSUInteger i = 0; i < length; i++) {
            if ((countOfPadding < (NSUIntegerMax - 1)) && ((receivedBytes[i] == '\n') || (receivedBytes[i] == ' '))) {
                countOfPadding++;
            } else {
                break;
            }
        }
        if (countOfPadding > 0) {
            [_receivedData replaceBytesInRange:NSMakeRange(0, countOfPadding) withBytes:NULL length:0];
        }
        NSRange range;
        if (_crData == nil) {
            _crData = [NSData dataWithBytesNoCopy:"\r" length:1 freeWhenDone:NO];
        }
        while (range = [_receivedData rangeOfData:_crData options:0 range:NSMakeRange(0, [_receivedData length])], (range.location != NSNotFound)) {
            NSData *jsonData = [_receivedData subdataWithRange:NSMakeRange(0, range.location)];
            NSError *jsonError = nil;
            id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&jsonError];
            if ((jsonObject != nil) && (self.receivedObjectBlock != nil)) {
                self.receivedObjectBlock(jsonObject);
            } else if (jsonObject == nil) {
                NSLog(@"%s jsonError=%@", __PRETTY_FUNCTION__, jsonError);
            }
            [_receivedData replaceBytesInRange:NSMakeRange(0, range.location + range.length) withBytes:NULL length:0];
        }
    }
}

- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection
{
    return NO;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%s URL=%@, error=%@, receivedData=%@", __PRETTY_FUNCTION__, _URL, error, [[NSString alloc] initWithData:_receivedData encoding:NSUTF8StringEncoding]);
    [self startRetryTimer];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    _response = nil;
    [self startRetryTimer];
}

@end
