//
//  NSString+CLCampfireUserType.h
//  Campfire client
//
//  Created by Chris Lundie on 15/Apr/2012.
//  Copyright (c) 2012 Chris Lundie. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "CLCampfireUserType.h"


@interface NSString (CLCampfireUserType)

+ (NSString *)cl_stringFromCampfireUserType:(enum CLCampfireUserType)userType;

- (enum CLCampfireUserType)cl_campfireUserType;

@end
