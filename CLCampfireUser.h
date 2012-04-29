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


@interface CLCampfireUser : NSObject

+ (id)userWithJSONObject:(NSDictionary *)jsonObject;

- (NSDictionary *)jsonObject;

@property (nonatomic, assign) long long userID;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, assign, getter=isAdmin) BOOL admin;
@property (nonatomic, copy) NSDate *creationDate;
@property (nonatomic, assign) enum CLCampfireUserType userType;
@property (nonatomic, copy) NSURL *avatarURL;
@property (nonatomic, copy) NSString *apiToken;

@end
