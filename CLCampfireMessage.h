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


@interface CLCampfireMessage : NSObject <NSCoding, NSCopying>

+ (id)messageWithJSONObject:(NSDictionary *)jsonObject;

- (id)initWithJSONObject:(NSDictionary *)jsonObject;
- (NSDictionary *)jsonObject;

@property (assign) enum CLCampfireMessageType messageType;
@property (copy) NSString *body;
@property (assign, getter=isStarred) BOOL starred;
@property (assign) long long messageID;
@property (assign) long long roomID;
@property (assign) long long userID;
@property (copy) NSDate *creationDate;

@end
