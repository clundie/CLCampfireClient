//
//  CLCampfireMessageType.h
//  Campfire client
//
//  Created by Chris Lundie on 08/Apr/2012.
//  Copyright (c) 2012 Chris Lundie. All rights reserved.
//


#import <Foundation/Foundation.h>


enum CLCampfireMessageType
{
    kCLCampfireUnknownMessageType = 0,
    kCLCampfireTextMessageType = 1,
    kCLCampfirePasteMessageType = 2,
    kCLCampfireSoundMessageType = 3,
    kCLCampfireAdvertisementMessageType = 4,
    kCLCampfireAllowGuestsMessageType = 5,
    kCLCampfireDisallowGuestsMessageType = 6,
    kCLCampfireIdleMessageType = 7,
    kCLCampfireKickMessageType = 8,
    kCLCampfireLeaveMessageType = 9,
    kCLCampfireSystemMessageType = 10,
    kCLCampfireTimestampMessageType = 11,
    kCLCampfireTopicChangeMessageType = 12,
    kCLCampfireUnidleMessageType = 13,
    kCLCampfireUnlockMessageType = 14,
    kCLCampfireUploadMessageType = 15,
    kCLCampfireTweetMessageType = 16,
};
