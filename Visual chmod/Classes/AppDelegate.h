//
//  AppDelegate.h
//  Visual chmod
//
//  Created by Fabio Leonardo Jung on 07/01/09.
//  Copyright iTouchFactory 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "AboutViewController.h"

@interface AppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
	UITabBarController *tbarController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

