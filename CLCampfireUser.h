//
//  CLCampfireUser.h
//  Campfire client
//
//  Created by Chris Lundie on 15/Apr/2012.
//  Copyright (c) 2012 Chris Lundie. All rights reserved.
//


@class CLCampfireUser;


#import <Foundation/Foundation.h>
#import "CLCampfireUserType.h"


@interface CLCampfireUser : NSObject <NSCoding, NSCopying>

+ (id)userWithJSONObject:(NSDictionary *)jsonObject;

- (id)initWithJSONObject:(NSDictionary *)jsonObject;
- (NSDictionary *)jsonObject;

@property (assign) long long userID;
@property (copy) NSString *userName;
@property (copy) NSString *email;
@property (assign, getter=isAdmin) BOOL admin;
@property (copy) NSDate *creationDate;
@property (assign) enum CLCampfireUserType userType;
@property (copy) NSURL *avatarURL;
@property (copy) NSString *apiToken;

@end
