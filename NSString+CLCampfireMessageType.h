//
//  NSString+CLCampfireMessageType.h
//  Campfire client
//
//  Created by Chris Lundie on 08/Apr/2012.
//  Copyright (c) 2012 Chris Lundie. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "CLCampfireMessageType.h"


@interface NSString (CLCampfireMessageType)

+ (NSString *)cl_stringFromCampfireMessageType:(enum CLCampfireMessageType)messageType;

- (enum CLCampfireMessageType)cl_campfireMessageType;

@end
