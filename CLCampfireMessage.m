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
	CLCampfireMessage *message = [[CLCampfireMessage alloc] init];
	NSString *messageType = [jsonObject objectForKey:@"type"];
	if ([messageType isKindOfClass:[NSString class]]) {
        message.messageType = [messageType cl_campfireMessageType];
	}
    NSString *body = [jsonObject objectForKey:@"body"];
    if ([body isKindOfClass:[NSString class]]) {
        message.body = body;
    }
    NSNumber *starred = [jsonObject objectForKey:@"starred"];
    if ([starred isKindOfClass:[NSNumber class]]) {
        message.starred = [starred boolValue];
    }
    NSNumber *messageID = [jsonObject objectForKey:@"id"];
    if ([messageID isKindOfClass:[NSNumber class]]) {
        message.messageID = [messageID longLongValue];
    }
    NSNumber *roomID = [jsonObject objectForKey:@"room_id"];
    if ([roomID isKindOfClass:[NSNumber class]]) {
        message.roomID = [roomID longLongValue];
    }
    NSNumber *userID = [jsonObject objectForKey:@"user_id"];
    if ([userID isKindOfClass:[NSNumber class]]) {
        message.userID = [userID longLongValue];
    }
    NSString *createdAt = [jsonObject objectForKey:@"created_at"];
    if ([createdAt isKindOfClass:[NSString class]]) {
        message.creationDate = [NSDate cl_dateWithCampfireDateString:createdAt];
    }
	return message;
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

- (NSString *)description
{
    NSString *description = [NSString stringWithFormat:@"%@", [self jsonObject]];
    return description;
}

@end
