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
	CLCampfireUser *user = [[CLCampfireUser alloc] initWithJSONObject:jsonObject];
    return user;
}

- (id)initWithJSONObject:(NSDictionary *)jsonObject
{
    self = [super init];
    if (self != nil) {
        {
            NSNumber *userID = [jsonObject objectForKey:@"id"];
            if ([userID isKindOfClass:[NSNumber class]]) {
                self.userID = [userID longLongValue];
            }
        }
        {
            NSString *userName = [jsonObject objectForKey:@"name"];
            if ([userName isKindOfClass:[NSString class]]) {
                self.userName = userName;
            }
        }
        {
            NSString *email = [jsonObject objectForKey:@"email_address"];
            if ([email isKindOfClass:[NSString class]]) {
                self.email = email;
            }
        }
        {
            NSNumber *admin = [jsonObject objectForKey:@"admin"];
            if ([admin isKindOfClass:[NSNumber class]]) {
                self.admin = [admin boolValue];
            }
        }
        {
            NSString *createdAt = [jsonObject objectForKey:@"created_at"];
            if ([createdAt isKindOfClass:[NSString class]]) {
                self.creationDate = [NSDate cl_dateWithCampfireDateString:createdAt];
            }
        }
        {
            NSString *userType = [jsonObject objectForKey:@"type"];
            if ([userType isKindOfClass:[NSString class]]) {
                self.userType = [userType cl_campfireUserType];
            }
        }
        {
            NSString *avatar = [jsonObject objectForKey:@"avatar_url"];
            if ([avatar isKindOfClass:[NSString class]]) {
                NSURL *URL = [[NSURL alloc] initWithString:avatar];
                self.avatarURL = URL;
            }
        }
        {
            NSString *apiToken = [jsonObject objectForKey:@"api_auth_token"];
            if ([apiToken isKindOfClass:[NSString class]]) {
                self.apiToken = apiToken;
            }
        }
    }
    return self;
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

#pragma mark - NSObject

- (NSString *)description
{
    NSString *description = [NSString stringWithFormat:@"%@", [self jsonObject]];
    return description;
}

- (NSUInteger)hash
{
    NSUInteger hash = (NSUInteger)(self.userID);
    return hash;
}

- (BOOL)isEqual:(id)object
{
    BOOL isEqual = [object isKindOfClass:[self class]] && (((CLCampfireUser *)object).userID == self.userID);
    return isEqual;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    CLCampfireUser *user = [[CLCampfireUser alloc] init];
    user.userID = self.userID;
    user.userName = self.userName;
    user.email = self.email;
    user.admin = self.admin;
    user.creationDate = self.creationDate;
    user.userType = self.userType;
    user.avatarURL = self.avatarURL;
    user.apiToken = self.apiToken;
    return user;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[self jsonObject] forKey:@"json"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    return [self initWithJSONObject:[aDecoder decodeObjectForKey:@"json"]];
}

@end
