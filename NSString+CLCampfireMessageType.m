//
//  NSString+CLCampfireMessageType.m
//  Campfire client
//
//  Created by Chris Lundie on 08/Apr/2012.
//  Copyright (c) 2012 Chris Lundie. All rights reserved.
//


#import "NSString+CLCampfireMessageType.h"


static NSString *_messageTypes[] =
{
    @"TextMessage",
    @"PasteMessage",
    @"SoundMessage",
    @"AdvertisementMessage",
    @"AllowGuestsMessage",
    @"DisallowGuestsMessage",
    @"IdleMessage",
    @"KickMessage",
    @"LeaveMessage",
    @"SystemMessage",
    @"TimestampMessage",
    @"TopicChangeMessage",
    @"UnidleMessage",
    @"UnlockMessage",
    @"UploadMessage",
    @"TweetMessage",
};


@implementation NSString (CLCampfireMessageType)

+ (NSString *)cl_stringFromCampfireMessageType:(enum CLCampfireMessageType)messageType
{
	NSString *str = nil;
	if ((messageType >= 1) && (messageType <= 16)) {
		str = _messageTypes[messageType - 1];
	}
	return str;
}

- (enum CLCampfireMessageType)cl_campfireMessageType
{
    enum CLCampfireMessageType messageType = kCLCampfireUnknownMessageType;
    for (int i = 0; i < 16; i++) {
        if ([_messageTypes[i] isEqualToString:self]) {
            messageType = (enum CLCampfireMessageType)(i + 1);
            break;
        }
    }
    return messageType;
}

@end
