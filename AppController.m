//
//  AppController.m
//  MacThrottle
//
//  Created by Dara Kong on 8/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"


@implementation AppController

- (void)awakeFromNib
{
	helperToolPath = [[[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/AuthHelperTool"] retain];
}

-(IBAction) enable: sender
{
	NSLog(@"Called enable button %@", [speedTextBox stringValue]);
	
	NSArray *args = [NSArray arrayWithObjects:helperToolPath, @"enableLimit", [speedTextBox stringValue], [unitsComboBox stringValue], nil];
	[NSTask launchedTaskWithLaunchPath:helperToolPath arguments:args];
}

-(IBAction) disable: sender
{
	NSLog(@"Called disable button" );

	NSArray *args = [NSArray arrayWithObjects:helperToolPath, @"disableLimit", @"", @"", nil];
	[NSTask launchedTaskWithLaunchPath:helperToolPath arguments:args];
}

@end
