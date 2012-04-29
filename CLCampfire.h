//
//  CLCampfire.h
//  Campfire client
//
//  Created by Chris Lundie on 04/Apr/2012.
//  Copyright (c) 2012 Chris Lundie. All rights reserved.
//


@class CLCampfireMessage;
@class CLCampfireUser;


#import <Foundation/Foundation.h>
#import "CLCampfireMessageType.h"


@interface CLCampfire : NSObject

- (id)initWithCompany:(NSString *)company URLCredential:(NSURLCredential *)URLCredential;
- (void)joinRoomID:(long long)roomID completionHandler:(void(^)(NSError *))completionHandler messageHandler:(void(^)(CLCampfireMessage *))messageHandler;
- (void)speakMessageType:(enum CLCampfireMessageType)messageType body:(NSString *)body roomID:(long long)roomID completionHandler:(void(^)(NSError *, CLCampfireMessage *))completionHandler;
- (void)requestCurrentUserWithCompletionHandler:(void(^)(NSError *, CLCampfireUser *))completionHandler;
- (void)stop;
- (void)setURLCredential:(NSURLCredential *)URLCredential;

@property (nonatomic, copy, readonly) NSString *company;

@end
