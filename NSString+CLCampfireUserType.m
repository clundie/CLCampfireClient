//
//  NSString+CLCampfireUserType.m
//  Campfire client
//
//  Created by Chris Lundie on 15/Apr/2012.
//  Copyright (c) 2012 Chris Lundie. All rights reserved.
//


#import "NSString+CLCampfireUserType.h"


static NSString *_userTypes[] =
{
    @"Member",
    @"Guest",
};


@implementation NSString (CLCampfireUserType)

+ (NSString *)cl_stringFromCampfireUserType:(enum CLCampfireUserType)userType
{
    NSString *str = nil;
    if ((userType >= 1) && (userType <= 2)) {
        str = _userTypes[userType - 1];
    }
    return str;
}

- (enum CLCampfireUserType)cl_campfireUserType
{
    enum CLCampfireUserType userType = kCLCampfireUnknownUserType;
    for (int i = 0; i < 2; i++) {
        if ([_userTypes[i] isEqualToString:self]) {
            userType = (enum CLCampfireUserType)(i + 1);
            break;
        }
    }
    return userType;
}

@end
