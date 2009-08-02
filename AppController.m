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
	isLimitEnabled = false;	// TODO: query ipfw and see if limit rule already exists (possibly by user manually running command line)
}

-(IBAction) enable: sender
{
	NSLog(@"Called enable button %@", [speedTextBox stringValue]);
	
	NSTask *task = [[NSTask alloc] init];
	[task setLaunchPath:helperToolPath];

	NSArray *args = [NSArray arrayWithObjects:helperToolPath, @"enableLimit", [speedTextBox stringValue], [unitsComboBox stringValue], nil];
	[task setArguments:args];
	
	[task launch];
	[task waitUntilExit];
	
	int status = [task terminationStatus];
    if (status == 0)
	{
		NSLog(@"Task succeeded.");

		[enableButton setEnabled:NO];
		[disableButton setEnabled:YES];
		[speedTextBox setEnabled:NO];
		[unitsComboBox setEnabled:NO];
		
		isLimitEnabled = true;
	}
    else
		NSLog(@"Task failed. %d", status );
}

-(IBAction) disable: sender
{
	NSLog(@"Called disable button" );
	
	NSTask *task = [[NSTask alloc] init];
	[task setLaunchPath:helperToolPath];
	
	NSArray *args = [NSArray arrayWithObjects:helperToolPath, @"disableLimit", @"", @"", nil];
	[task setArguments:args];
	
	[task launch];
	[task waitUntilExit];
	
	int status = [task terminationStatus];
    if (status == 0)
	{
		NSLog(@"Task succeeded.");
		
		[enableButton setEnabled:YES];
		[disableButton setEnabled:NO];
		[speedTextBox setEnabled:YES];
		[unitsComboBox setEnabled:YES];
		
		isLimitEnabled = false;
	}
    else
		NSLog(@"Task failed. %d", status );
}

@end
