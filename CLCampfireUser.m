//
//  CLCampfireUser.m
//  Campfire client
//
//  Created by Chris Lundie on 15/Apr/2012.
//  Copyright (c) 2012 Chris Lundie. All rights reserved.
//


#import "CLCampfireUser.h"
#import "NSString+CLCampfireUserType.h"
#import "NSDate+CLCampfire.h"


@implementation CLCampfireUser

@synthesize userID = _userID;
@synthesize userName = _userName;
@synthesize email = _email;
@synthesize admin = _admin;
@synthesize creationDate = _creationDate;
@synthesize userType = _userType;
@synthesize avatarURL = _avatarURL;
@synthesize apiToken = _apiToken;

+ (id)userWithJSONObject:(NSDictionary *)jsonObject
{
	CLCampfireUser *user = [[CLCampfireUser alloc] init];
    {
        NSNumber *userID = [jsonObject objectForKey:@"id"];
        if ([userID isKindOfClass:[NSNumber class]]) {
            user.userID = [userID longLongValue];
        }
    }
    {
        NSString *userName = [jsonObject objectForKey:@"name"];
        if ([userName isKindOfClass:[NSString class]]) {
            user.userName = userName;
        }
    }
    {
        NSString *email = [jsonObject objectForKey:@"email_address"];
        if ([email isKindOfClass:[NSString class]]) {
            user.email = email;
        }
    }
    {
        NSNumber *admin = [jsonObject objectForKey:@"admin"];
        if ([admin isKindOfClass:[NSNumber class]]) {
            user.admin = [admin boolValue];
        }
    }
    {
        NSString *createdAt = [jsonObject objectForKey:@"created_at"];
        if ([createdAt isKindOfClass:[NSString class]]) {
            user.creationDate = [NSDate cl_dateWithCampfireDateString:createdAt];
        }
    }
    {
        NSString *userType = [jsonObject objectForKey:@"type"];
        if ([userType isKindOfClass:[NSString class]]) {
            user.userType = [userType cl_campfireUserType];
        }
    }
    {
        NSString *avatar = [jsonObject objectForKey:@"avatar_url"];
        if ([avatar isKindOfClass:[NSString class]]) {
            NSURL *URL = [[NSURL alloc] initWithString:avatar];
            user.avatarURL = URL;
        }
    }
	{
		NSString *apiToken = [jsonObject objectForKey:@"api_auth_token"];
		if ([apiToken isKindOfClass:[NSString class]]) {
			user.apiToken = apiToken;
		}
	}
	return user;
}

- (NSDictionary *)jsonObject
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSNumber numberWithLongLong:self.userID] forKey:@"id"];
    [dict setObject:(self.userName != nil) ? [self.userName copy] : [NSNull null] forKey:@"name"];
    [dict setObject:(self.email != nil) ? [self.email copy] : [NSNull null] forKey:@"email_address"];
    [dict setObject:[NSNumber numberWithBool:self.admin] forKey:@"admin"];
    NSString *creationDateStr = [self.creationDate descriptionWithLocale:nil];
    [dict setObject:(creationDateStr != nil) ? creationDateStr : [NSNull null] forKey:@"created_at"];
    NSString *typeStr = [NSString cl_stringFromCampfireUserType:self.userType];
    [dict setObject:(typeStr != nil) ? [typeStr copy] : [NSNull null] forKey:@"type"];
    [dict setObject:(self.avatarURL != nil) ? [[self.avatarURL absoluteString] copy] : [NSNull null] forKey:@"avatar_url"];
    return [dict copy];
}

- (NSString *)description
{
    NSString *description = [NSString stringWithFormat:@"%@", [self jsonObject]];
    return description;
}

@end
