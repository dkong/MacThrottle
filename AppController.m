//
//  AppController.m
//  MacThrottle
//
//  Created by Dara Kong on 8/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"


@implementation AppController

-(IBAction) enable: sender
{
	NSLog(@"Called enable button %@", [speedTextBox stringValue] );
	
	NSTask *task;
    task = [[NSTask alloc] init];
    [task setLaunchPath: @"/bin/ls"];
	
    NSArray *arguments;
    arguments = [NSArray arrayWithObjects: @"-l", @"-a", @"-t", nil];
    [task setArguments: arguments];
	
    NSPipe *pipe;
    pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
	
    NSFileHandle *file;
    file = [pipe fileHandleForReading];
	
    [task launch];
	
    NSData *data;
    data = [file readDataToEndOfFile];
	
    NSString *string;
    string = [[NSString alloc] initWithData: data
								   encoding: NSUTF8StringEncoding];
    NSLog (@"woop!  got\n%@", string);
}

-(IBAction) disable: sender
{
	NSLog(@"Called disable button" );
}

@end
