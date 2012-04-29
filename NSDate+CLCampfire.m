//
//  NSDate+CLCampfire.m
//  Campfire client
//
//  Created by Chris Lundie on 21/Apr/2012.
//  Copyright (c) 2012 Chris Lundie. All rights reserved.
//


#import "NSDate+CLCampfire.h"


@implementation NSDate (CLCampfire)

+ (id)cl_dateWithCampfireDateString:(NSString *)dateString
{
	static NSDateFormatter *formatter = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		formatter = [[NSDateFormatter alloc] init];
		[formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
		[formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss Z"];
	});
	NSDate *date = [formatter dateFromString:dateString];
	return date;
}

- (NSString *)cl_descriptionForCampfire
{
	static NSDateFormatter *formatter = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		formatter = [[NSDateFormatter alloc] init];
		[formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
		[formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss Z"];
	});
	NSString *description = [formatter stringFromDate:self];
	return description;
}

@end
