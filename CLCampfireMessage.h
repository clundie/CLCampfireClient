//
//  CLCampfireMessage.h
//  Campfire client
//
//  Created by Chris Lundie on 08/Apr/2012.
//  Copyright (c) 2012 Chris Lundie. All rights reserved.
//


@class CLCampfireMessage;


#import <Foundation/Foundation.h>
#import "CLCampfireMessageType.h"


@interface CLCampfireMessage : NSObject

+ (id)messageWithJSONObject:(NSDictionary *)jsonObject;

- (NSDictionary *)jsonObject;

@property (nonatomic, assign) enum CLCampfireMessageType messageType;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, assign, getter=isStarred) BOOL starred;
@property (nonatomic, assign) long long messageID;
@property (nonatomic, assign) long long roomID;
@property (nonatomic, assign) long long userID;
@property (nonatomic, copy) NSDate *creationDate;

@end
