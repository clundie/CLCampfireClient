//
//  CLStreamingJSONFetcher.h
//  Campfire client
//
//  Created by Chris Lundie on 04/Apr/2012.
//  Copyright (c) 2012 Chris Lundie. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface CLStreamingJSONFetcher : NSObject

- (id)initWithURL:(NSURL *)URL;
- (BOOL)beginFetch;
- (void)stopFetching;

@property (nonatomic, copy) void (^receivedObjectBlock)(id receivedObject);
@property (nonatomic, copy) void (^connectedBlock)();
@property (nonatomic, copy) NSURLCredential *URLCredential;

@end
