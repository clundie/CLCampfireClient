//
//  CLCampfireClient.m
//  Campfire client
//
//  Created by Chris Lundie on 04/Apr/2012.
//  Copyright (c) 2012 Chris Lundie. All rights reserved.
//


#import "CLCampfireClient.h"
#import "CLStreamingJSONFetcher.h"
#import "CLCampfireMessage.h"
#import "CLCampfireUser.h"
#import "GTMHTTPFetcher.h"
#import "NSString+CLCampfireMessageType.h"


static const NSTimeInterval _requestTimeoutInterval = 60.0;
static const NSTimeInterval _minRetryInterval = 1.0;
static const NSTimeInterval _maxRetryInterval = 30.0;


@interface CLCampfireClient ()
{
@private
    NSString *_company;
    NSMutableArray *_fetchers;
    NSURLCredential *_URLCredential;
    NSMutableDictionary *_streamingFetchers;
}

- (NSMutableDictionary *)streamingFetchers;

@end


@implementation CLCampfireClient

@synthesize company = _company;

- (id)initWithCompany:(NSString *)company URLCredential:(NSURLCredential *)URLCredential
{
    if ([company length] < 1) {
        [NSException raise:NSInvalidArgumentException format:@"company cannot be nil or zero-length"];
        return nil;
    }
    if (URLCredential == nil) {
        [NSException raise:NSInvalidArgumentException format:@"URLCredential cannot be nil"];
    }
    self = [super init];
    if (self != nil) {
        _company = [company copy];
        _URLCredential = [URLCredential copy];
        _fetchers = [NSMutableArray array];
    }
    return self;
}

- (void)dealloc
{
    for (GTMHTTPFetcher *fetcher in _fetchers) {
        [fetcher stopFetching];
    }
    for (CLStreamingJSONFetcher *fetcher in _streamingFetchers) {
        [fetcher stopFetching];
    }
}

- (void)stop
{
    for (GTMHTTPFetcher *fetcher in _fetchers) {
        [fetcher stopFetching];
    }
    [_fetchers removeAllObjects];
    for (CLStreamingJSONFetcher *fetcher in _streamingFetchers) {
        [fetcher stopFetching];
    }
    [_streamingFetchers removeAllObjects];
}

- (NSMutableDictionary *)streamingFetchers
{
    if (_streamingFetchers == nil) {
        _streamingFetchers = [NSMutableDictionary dictionary];
    }
    return _streamingFetchers;
}

- (void)requestCurrentUserWithCompletionHandler:(void(^)(NSError *, CLCampfireUser *))completionHandler
{
    NSString *urlStr = [NSString stringWithFormat:@"https://%@.campfirenow.com/users/me.json", self.company];
    NSURL *URL = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:_requestTimeoutInterval];
    [request setHTTPShouldHandleCookies:NO];
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithRequest:request];
    fetcher.retryEnabled = YES;
    fetcher.minRetryInterval = _minRetryInterval;
    fetcher.maxRetryInterval = _maxRetryInterval;
    fetcher.credential = _URLCredential;
    [_fetchers addObject:fetcher];
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        [_fetchers removeObject:fetcher];
        if (error == nil) {
            if (completionHandler != nil) {
                id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
                CLCampfireUser *user = nil;
                if ([jsonObject isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *userJsonObject = [((NSDictionary *)jsonObject) objectForKey:@"user"];
                    if ([userJsonObject isKindOfClass:[NSDictionary class]]) {
                        user = [CLCampfireUser userWithJSONObject:userJsonObject];
                    }
                }
                completionHandler(nil, user);
            }
        } else {
            if (completionHandler != nil) {
                completionHandler(error, nil);
            }
        }
    }];
}

- (void)speakMessageType:(enum CLCampfireMessageType)messageType body:(NSString *)body roomID:(long long)roomID completionHandler:(void(^)(NSError *, CLCampfireMessage *))completionHandler
{
    if ((messageType != kCLCampfireTextMessageType) && (messageType != kCLCampfirePasteMessageType) && (messageType != kCLCampfireSoundMessageType) && (messageType != kCLCampfireTweetMessageType)) {
        [NSException raise:NSInvalidArgumentException format:@"message type must be kCLCampfireTextMessageType, kCLCampfirePasteMessageType, kCLCampfireSoundMessageType or kCLCampfireTweetMessageType"];
        return;
    }
    if (roomID < 1) {
        [NSException raise:NSInvalidArgumentException format:@"roomID cannot be less than 1"];
        return;
    }
    if (body == nil) {
        [NSException raise:NSInvalidArgumentException format:@"body cannot be nil"];
    }
    NSString *urlStr = [NSString stringWithFormat:@"https://%@.campfirenow.com/room/%qi/speak.json", self.company, roomID];
    NSURL *URL = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:_requestTimeoutInterval];
    [request setHTTPShouldHandleCookies:NO];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    NSMutableDictionary *message = [NSMutableDictionary dictionaryWithCapacity:2];
    [message setObject:body forKey:@"body"];
    [message setObject:[NSString cl_stringFromCampfireMessageType:messageType] forKey:@"type"];
    NSData *HTTPbody = [NSJSONSerialization dataWithJSONObject:[NSDictionary dictionaryWithObject:message forKey:@"message"] options:0 error:NULL];
    [request setHTTPBody:HTTPbody];
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithRequest:request];
    fetcher.retryEnabled = YES;
    fetcher.minRetryInterval = _minRetryInterval;
    fetcher.maxRetryInterval = _maxRetryInterval;
    fetcher.credential = _URLCredential;
    [_fetchers addObject:fetcher];
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        [_fetchers removeObject:fetcher];
        if (error == nil) {
            if (completionHandler != nil) {
                id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
                CLCampfireMessage *messageToSend = nil;
                if ([jsonObject isKindOfClass:[NSDictionary class]]) {
                    messageToSend = [CLCampfireMessage messageWithJSONObject:jsonObject];   
                }
                completionHandler(nil, messageToSend);
            }
        } else {
            if (completionHandler != nil) {
                completionHandler(error, nil);
            }
        }
    }];
}

- (void)joinRoomID:(long long)roomID completionHandler:(void(^)(NSError *))completionHandler messageHandler:(void(^)(CLCampfireMessage *))messageHandler
{
    if (roomID < 1) {
        [NSException raise:NSInvalidArgumentException format:@"roomID cannot be less than 1"];
        return;
    }
    {
        NSNumber *roomNumber = [NSNumber numberWithLongLong:roomID];
        CLStreamingJSONFetcher *streamingFetcher = [_streamingFetchers objectForKey:roomNumber];
        [streamingFetcher stopFetching];
        [_streamingFetchers removeObjectForKey:roomNumber];
    }
    NSString *urlStr = [NSString stringWithFormat:@"https://%@.campfirenow.com/room/%qi/join.json", self.company, roomID];
    NSURL *URL = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:_requestTimeoutInterval];
    [request setHTTPShouldHandleCookies:NO];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithRequest:request];
    fetcher.retryEnabled = YES;
    fetcher.minRetryInterval = _minRetryInterval;
    fetcher.maxRetryInterval = _maxRetryInterval;
    fetcher.credential = _URLCredential;
    [_fetchers addObject:fetcher];
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        [_fetchers removeObject:fetcher];
        if (error == nil) {
            NSURL *streamingURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://streaming.campfirenow.com/room/%qi/live.json", roomID]];
            CLStreamingJSONFetcher *streamingFetcher = [[CLStreamingJSONFetcher alloc] initWithURL:streamingURL];
            streamingFetcher.URLCredential = _URLCredential;
            streamingFetcher.receivedObjectBlock = ^(id receivedObject) {
                if ([receivedObject isKindOfClass:[NSDictionary class]]) {
                    CLCampfireMessage *receivedMessage = [CLCampfireMessage messageWithJSONObject:receivedObject];
                    if ((receivedMessage != nil) && (messageHandler != nil)) {
                        messageHandler(receivedMessage);
                    }
                }
            };
            [[self streamingFetchers] setObject:streamingFetcher forKey:[NSNumber numberWithLongLong:roomID]];
            [streamingFetcher beginFetch];
            if (completionHandler != nil) {
                completionHandler(nil);
            }
        } else if (error != nil) {
            NSLog(@"%s error=%@, URL=%@, data=%@", __PRETTY_FUNCTION__, error, [[fetcher response] URL], [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            if (completionHandler != nil) {
                completionHandler(error);
            }
        }
    }];
}

- (void)setURLCredential:(NSURLCredential *)URLCredential
{
	_URLCredential = [URLCredential copy];
}

@end
