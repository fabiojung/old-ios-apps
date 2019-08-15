//
//  TextFieldViewController.h
//  PetsCare
//
//  Created by Fabio Leonardo Jung on 07/04/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Type.h"

@interface TextFieldViewController : UIViewController <UITextFieldDelegate> {
	UITextField *myTextField;
	UIBarButtonItem *saveButton;
}

@end
