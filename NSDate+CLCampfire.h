//
//  NSDate+CLCampfire.h
//  Campfire client
//
//  Created by Chris Lundie on 21/Apr/2012.
//  Copyright (c) 2012 Chris Lundie. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface NSDate (CLCampfire)

+ (id)cl_dateWithCampfireDateString:(NSString *)dateString;
- (NSString *)cl_descriptionForCampfire;

@end
