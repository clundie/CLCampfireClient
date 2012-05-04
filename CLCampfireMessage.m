//
//  CLCampfireMessage.m
//  Campfire client
//
//  Created by Chris Lundie on 08/Apr/2012.
//  Copyright (c) 2012 Chris Lundie. All rights reserved.
//


#import "CLCampfireMessage.h"
#import "NSString+CLCampfireMessageType.h"
#import "NSDate+CLCampfire.h"


@implementation CLCampfireMessage

@synthesize messageType = _messageType;
@synthesize body = _body;
@synthesize starred = _starred;
@synthesize messageID = _messageID;
@synthesize roomID = _roomID;
@synthesize userID = _userID;
@synthesize creationDate = _creationDate;

+ (id)messageWithJSONObject:(NSDictionary *)jsonObject
{
	CLCampfireMessage *message = [[CLCampfireMessage alloc] initWithJSONObject:jsonObject];
	return message;
}

- (id)initWithJSONObject:(NSDictionary *)jsonObject
{
    self = [super init];
    if (self != nil) {
        {
            NSString *messageType = [jsonObject objectForKey:@"type"];
            if ([messageType isKindOfClass:[NSString class]]) {
                self.messageType = [messageType cl_campfireMessageType];
            }
        }
        {
            NSString *body = [jsonObject objectForKey:@"body"];
            if ([body isKindOfClass:[NSString class]]) {
                self.body = body;
            }
        }
        {
            NSNumber *starred = [jsonObject objectForKey:@"starred"];
            if ([starred isKindOfClass:[NSNumber class]]) {
                self.starred = [starred boolValue];
            }
        }
        {
            NSNumber *messageID = [jsonObject objectForKey:@"id"];
            if ([messageID isKindOfClass:[NSNumber class]]) {
                self.messageID = [messageID longLongValue];
            }
        }
        {
            NSNumber *roomID = [jsonObject objectForKey:@"room_id"];
            if ([roomID isKindOfClass:[NSNumber class]]) {
                self.roomID = [roomID longLongValue];
            }
        }
        {
            NSNumber *userID = [jsonObject objectForKey:@"user_id"];
            if ([userID isKindOfClass:[NSNumber class]]) {
                self.userID = [userID longLongValue];
            }
        }
        {
            NSString *createdAt = [jsonObject objectForKey:@"created_at"];
            if ([createdAt isKindOfClass:[NSString class]]) {
                self.creationDate = [NSDate cl_dateWithCampfireDateString:createdAt];
            }
        }
    }
    return self;
}

- (NSDictionary *)jsonObject
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *typeStr = [NSString cl_stringFromCampfireMessageType:self.messageType];
    [dict setObject:(typeStr != nil) ? [typeStr copy] : [NSNull null] forKey:@"type"];
    [dict setObject:(self.body != nil) ? [self.body copy] : [NSNull null] forKey:@"body"];
    [dict setObject:[NSNumber numberWithBool:self.starred] forKey:@"starred"];
    [dict setObject:[NSNumber numberWithLongLong:self.messageID] forKey:@"id"];
    [dict setObject:[NSNumber numberWithLongLong:self.roomID] forKey:@"room_id"];
    [dict setObject:[NSNumber numberWithLongLong:self.userID] forKey:@"user_id"];
    NSString *creationDateStr = [self.creationDate descriptionWithLocale:nil];
    [dict setObject:(creationDateStr != nil) ? creationDateStr : [NSNull null] forKey:@"created_at"];
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
    NSUInteger hash = (NSUInteger)(self.messageID);
    return hash;
}

- (BOOL)isEqual:(id)object
{
    BOOL isEqual = [object isKindOfClass:[self class]] && (((CLCampfireMessage *)object).messageID == self.messageID);
    return isEqual;
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

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    CLCampfireMessage *message = [[CLCampfireMessage alloc] init];
    message.messageType = self.messageType;
    message.body = self.body;
    message.starred = self.starred;
    message.messageID = self.messageID;
    message.roomID = self.roomID;
    message.userID = self.userID;
    message.creationDate = self.creationDate;
    return message;
}

@end
