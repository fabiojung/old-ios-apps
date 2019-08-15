//
//  AboutViewController.h
//  DDD Brasil
//
//  Created by Fabio Leonardo Jung on 12/08/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface AboutViewController : UIViewController <MFMailComposeViewControllerDelegate> {
	UILabel *appVersion;
	UILabel *appCopyright;
	UILabel *appRights;
}

@property (nonatomic, retain) IBOutlet UILabel *appVersion;
@property (nonatomic, retain) IBOutlet UILabel *appCopyright;
@property (nonatomic, retain) IBOutlet UILabel *appRights;

@end
