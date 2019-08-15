//
//  ConfigViewController.h
//  Tarefas
//
//  Created by Fabio Leonardo Jung on 21/12/08.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ConfigViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>{
	UITableView *myTableView;
	UITextField *emailField;
	UILabel *cellLabel;
	UISwitch *switchDelete;
}

@end
