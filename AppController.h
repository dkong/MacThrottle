//
//  AppController.h
//  MacThrottle
//
//  Created by Dara Kong on 8/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AppController : NSObject {
	IBOutlet id speedTextBox;
	IBOutlet id unitsComboBox;
	
	NSString *helperToolPath;
}

- (IBAction) enable: (id)sender;
- (IBAction) disable: (id)sender;

@end
