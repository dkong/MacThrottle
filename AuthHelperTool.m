//
//  AuthHelperTool.m
//  BDAuthorize
//
//  Created by Brian Dunagan on 11/23/08.
//  Copyright 2008 bdunagan.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

int main(int argc, char *argv[])
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSLog(@"AuthHelperTool started");

	// Look at arguments.
	if (argc == 5)
	{
		// Hasn't been called as root yet.
		NSLog(@"AuthHelperTool executing self-repair");
		
		// Paraphrased from http://developer.apple.com/documentation/Security/Conceptual/authorization_concepts/03authtasks/chapter_3_section_4.html
		OSStatus myStatus;
		AuthorizationFlags myFlags = kAuthorizationFlagDefaults;
		AuthorizationRef myAuthorizationRef;

		myStatus = AuthorizationCreate(NULL, kAuthorizationEmptyEnvironment, myFlags, &myAuthorizationRef);
		if (myStatus != errAuthorizationSuccess)
			return myStatus;

		AuthorizationItem myItems = {kAuthorizationRightExecute, 0, NULL, 0};
		AuthorizationRights myRights = {1, &myItems};
		myFlags = kAuthorizationFlagDefaults |
			kAuthorizationFlagInteractionAllowed |
			kAuthorizationFlagPreAuthorize |
			kAuthorizationFlagExtendRights;

		myStatus = AuthorizationCopyRights (myAuthorizationRef, &myRights, NULL, myFlags, NULL );
		if (myStatus != errAuthorizationSuccess)
			return myStatus;

		char *myToolPath = argv[1];
		char *myArguments[] = {argv[1], "--self-repair", argv[2], argv[3], argv[4], NULL};
		FILE *myCommunicationsPipe = NULL;
		
		myFlags = kAuthorizationFlagDefaults;
		myStatus = AuthorizationExecuteWithPrivileges(myAuthorizationRef, myToolPath, myFlags, myArguments, &myCommunicationsPipe);
		NSLog(@"AuthHelperTool called AEWP");
	}
	else
	{
		if (argc == 6)
		{	
			NSString *command = [NSString stringWithCString:argv[3]];
			NSLog(@"AuthHelperTool sent command %@", command);

			if ([command isEqualToString:@"enableLimit"])
			{
				NSLog(@"AuthHelperTool executing %@", command);

				NSString *speed = [NSString stringWithCString:argv[4]];
				NSString *units = [NSString stringWithCString:argv[5]];
				NSString *bandwidthLimit = [NSString stringWithFormat:@"%@%@", speed, units]; 

				// setuid is necessary to execute sudo.
				setuid(0);
				NSArray *args = [NSArray arrayWithObjects: @"ipfw", @"pipe", @"1", @"config", @"bw", bandwidthLimit, nil];
				[NSTask launchedTaskWithLaunchPath:@"/usr/bin/sudo" arguments:args];
				NSLog(@"AuthHelperTool done with part 1 %@: args %@ ?", command, args);
		
				NSArray *args2 = [NSArray arrayWithObjects: @"ipfw", @"add", @"1", @"pipe", @"1", @"src-port", @"80", nil];
				[NSTask launchedTaskWithLaunchPath:@"/usr/bin/sudo" arguments:args2];
				NSLog(@"AuthHelperTool done with part 2%@: ?", command);
			}
			else if ([command isEqualToString:@"disableLimit"])
			{
				NSLog(@"AuthHelperTool executing %@", command);
				
				// setuid is necessary to execute sudo.
				setuid(0);
				NSArray *args = [NSArray arrayWithObjects: @"ipfw", @"delete", @"1", nil];
				[NSTask launchedTaskWithLaunchPath:@"/usr/bin/sudo" arguments:args];
				NSLog(@"AuthHelperTool done with delete %@: ?", command);
			}
				
				//
				/*
				NSTask *task = [[NSTask alloc] init];
				[task setLaunchPath: @"/usr/bin/sudo"];
				
				NSArray *arguments = [NSArray arrayWithObjects: @"-l", @"-a", @"-t", nil];
				[task setArguments: arguments];
				
				NSPipe *pipe = [NSPipe pipe];
				[task setStandardOutput: pipe];
				
				NSFileHandle *file = [pipe fileHandleForReading];
				
				[task launch];
				
				NSData *data = [file readDataToEndOfFile];
				
				NSString *string = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
				
				NSLog (@"woop!  got\n%@", string);
				 */
		}
	}
	NSLog(@"AuthHelperTool exiting");

	[pool release];
	return 0;
}
