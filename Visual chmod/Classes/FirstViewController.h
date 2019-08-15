//
//  FirstViewController.h
//  Visual chmod
//
//  Created by Fabio Leonardo Jung on 07/01/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FirstViewController : UIViewController {
	UIButton *ownRead, *ownWrite, *ownExec, *groupRead, *groupWrite, *groupExec, *otherRead, *otherWrite, *otherExec;
	UIImageView *imgOwnRead, *imgOwnWrite, *imgOwnExec, *imgGroupRead, *imgGroupWrite, *imgGroupExec, *imgOtherRead, *imgOtherWrite, *imgOtherExec;
	UILabel *lsLabel, *chmodLabel;
	NSMutableString *lsText, *chmodText1;
	UISwitch *swUID, *swGID, *swStBit;
	int owner, group, other, root;
	BOOL uid_ON, gid_ON, sticky_ON;
}

@end
