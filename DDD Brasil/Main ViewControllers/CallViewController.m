//
//  CallViewController.m
//  DDD Brasil
//
//  Created by Fabio Leonardo Jung on 12/08/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import "CallViewController.h"
#import <QuartzCore/QuartzCore.h>

#define kMainLabelFrame1 CGRectMake(6.0, 93.0, 43.0, 31.0)
#define kMainLabelFrame2 CGRectMake(38.0, 93.0, 43.0, 31.0)

#define kCallFromBrasil		1
#define kCallFromExterior	2
#define kSMSFromBrasil		3
#define kPickContact		4
#define kChangeContact		5
#define TTVIEW_TAG			10

#define CTBC_TAG	12
#define BRT_TAG		14
#define TELEF_TAG	15
#define EMBRAT_TAG	21
#define INTELI_TAG	23
#define GVT_TAG		25
#define OI_TAG		31
#define TIM_TAG		41
#define OUTRA_TAG	100

@interface CallViewController ()
- (void)selectContact:(id)sender;
- (void)validatePhoneNumber:(NSString *)aString;
- (void)callNumber:(id)sender;
- (void)deselectTabIndex;
- (void)addNewContact;
- (void)presentSheet;
- (void)setButtons:(BOOL)hide;
- (void)changeOperadora:(id)sender;
- (void)changeViewFor:(id)sender;
- (void)showWarningWith:(NSString *)text;
- (NSString *)fullPhoneNumberTo:(int)usage;
- (UISegmentedControl *)makeButtonWithTitle:(NSString *)aTitle andTag:(NSInteger)aTag;
@end


@implementation CallViewController

@synthesize ddd;
@synthesize destino;

- (id)init {
	if (self = [super init]) {
		self.navigationItem.title = @"DDD Brasil";
		device = [NSMutableString stringWithString:[[UIDevice currentDevice] model]];
		[device deleteCharactersInRange:NSMakeRange(4, device.length - 4)];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	}
	return self;
}

- (void)loadView {
	contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	[contentView setBackgroundColor:[UIColor colorWithRed:0.863 green:0.874 blue:0.897 alpha:1.000]];
	
	mainToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, -1, 320, 43)];
	mainToolBar.contentMode = UIViewContentModeScaleToFill;
	mainToolBar.barStyle = UIBarStyleBlackTranslucent;
	
	mainTabBar = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Estou no Brasil", @"Estou no Exterior", nil]];
	mainTabBar.frame = CGRectMake(12.0, 7.0, 296.0, 30.0);
	mainTabBar.segmentedControlStyle = UISegmentedControlStyleBar;
	mainTabBar.tintColor = [UIColor colorWithRed:0.488 green:0.488 blue:0.488 alpha:1.000];
	mainTabBar.selectedSegmentIndex = 0;
	[mainTabBar addTarget:self action:@selector(changeViewFor:) forControlEvents:UIControlEventValueChanged];
	[mainToolBar addSubview:mainTabBar];
	[mainTabBar release];
	
	[contentView addSubview:mainToolBar];
	[mainToolBar release];
	
	UILabel *labelDestino = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 50.0, 320.0, 25.0)];
	[labelDestino setText:[NSString stringWithFormat:@"Ligando para: %@", self.destino]];
	[labelDestino setFont:[UIFont boldSystemFontOfSize:14]];
	[labelDestino setAdjustsFontSizeToFitWidth:YES];
	[labelDestino setTextAlignment:UITextAlignmentCenter];
	[labelDestino setTextColor:[UIColor colorWithRed:0.313 green:0.346 blue:0.422 alpha:1.000]];
	[labelDestino setShadowColor:[UIColor whiteColor]];
	[labelDestino setShadowOffset:CGSizeMake(1, 1)];
	[labelDestino setBackgroundColor:[UIColor clearColor]];
	[contentView addSubview:labelDestino];
	[labelDestino release];
	
	mainLabel = [[UILabel alloc] initWithFrame:kMainLabelFrame1];
	[mainLabel setBackgroundColor:[UIColor clearColor]];
	[mainLabel setFont:[UIFont boldSystemFontOfSize:20]];
	[mainLabel setTextColor:[UIColor blackColor]];
	[mainLabel setShadowColor:[UIColor whiteColor]];
	[mainLabel setShadowOffset:CGSizeMake(1, 1)];
	[mainLabel setTextAlignment:UITextAlignmentRight];
	[mainLabel setText:@"0 +"];
	[contentView addSubview:mainLabel];
	[mainLabel release];
	
	operLabel = [[UILabel alloc] initWithFrame:CGRectMake(48.0, 93.0, 38.0, 31.0)];
	[operLabel setBackgroundColor:[UIColor colorWithRed:0.863 green:0.874 blue:0.897 alpha:1.000]];
	[operLabel setTextAlignment:UITextAlignmentCenter];
	[operLabel setFont:[UIFont boldSystemFontOfSize:20]];
	[operLabel setShadowColor:[UIColor whiteColor]];
	[operLabel setShadowOffset:CGSizeMake(1, 1)];
	[operLabel setText:@"XX"];
	[contentView addSubview:operLabel];
	[operLabel release];
	
	operField = [[UITextField alloc] initWithFrame:CGRectMake(48.0, 97.0, 38.0, 31.0)];
	[operField setBorderStyle:UITextBorderStyleNone];
	[operField setTextAlignment:UITextAlignmentCenter];
	[operField setKeyboardType:UIKeyboardTypeNumberPad];
	[operField setFont:[UIFont boldSystemFontOfSize:20]];
	[operField setClearsOnBeginEditing:YES];
	[operField setText:@"-1"];
	[operField setBackgroundColor:[UIColor clearColor]];
	[operField setDelegate:self];
	[operField setEnabled:NO];
	[operField setHidden:YES];
	[contentView addSubview:operField];
	[operField release];
	
	dddField = [[UILabel alloc] initWithFrame:CGRectMake(83.0, 93.0, 64.0, 31.0)];
	[dddField setBackgroundColor:[UIColor colorWithRed:0.863 green:0.874 blue:0.897 alpha:1.000]];
	[dddField setTextAlignment:UITextAlignmentCenter];
	[dddField setFont:[UIFont boldSystemFontOfSize:20]];
	[dddField setShadowColor:[UIColor whiteColor]];
	[dddField setShadowOffset:CGSizeMake(1, 1)];
	[dddField setText:[NSString stringWithFormat:@"+ %@ +", ddd]];
	[contentView addSubview:dddField];
	[dddField release];
	
	phoneField = [[UITextField alloc] initWithFrame:CGRectMake(155.0, 93.0, 120.0, 30.0)];
	[phoneField setBorderStyle:UITextBorderStyleRoundedRect];
	[phoneField setTextAlignment:UITextAlignmentCenter];
	[phoneField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
	
	[phoneField setKeyboardType:UIKeyboardTypeNumberPad];
	[phoneField setReturnKeyType:UIReturnKeyDone];
	[phoneField setFont:[UIFont boldSystemFontOfSize:20]];
	[phoneField setPlaceholder:@"Telefone"];
	[phoneField setDelegate:self];
	[contentView addSubview:phoneField];
	[phoneField release];
	
	UIButton *getContact = [UIButton buttonWithType:UIButtonTypeCustom];
	[getContact setFrame:CGRectMake(282.0, 93.0, 30.0, 30.0)];
	[getContact setImage:[UIImage imageNamed:@"aBook.png"] forState:UIControlStateNormal];
	[getContact setTag:kPickContact];
	[getContact addTarget:self action:@selector(selectContact:) forControlEvents:UIControlEventTouchDown];
	[contentView addSubview:getContact];
	
	UIButton *ligar = [UIButton buttonWithType:UIButtonTypeCustom];
	[ligar setFrame:CGRectMake(107.0, 152.0, 106.0, 42.0)];
	[ligar setImage:[UIImage imageNamed:@"ligar.png"] forState:UIControlStateNormal];
	[ligar addTarget:self action:@selector(callNumber:) forControlEvents:UIControlEventTouchDown];
	if ([device isEqualToString:@"iPod"]) [ligar setEnabled:NO];
	[contentView addSubview:ligar];
	
	UIButton *sms = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[sms setFrame:CGRectMake(13.0, 154.0, 80.0, 38.0)];
	[sms setTitle:@"Mensagem de Texto" forState:UIControlStateNormal];
	sms.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
	sms.titleLabel.textAlignment = UITextAlignmentCenter;
	sms.titleLabel.font = [UIFont boldSystemFontOfSize:12];
	[sms addTarget:self action:@selector(smsNumber:) forControlEvents:UIControlEventTouchDown];
	if ([device isEqualToString:@"iPod"]) [sms setEnabled:NO];
	[contentView addSubview:sms];
	
	UIButton *contatos = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[contatos setFrame:CGRectMake(226.0, 154.0, 80.0, 38.0)];
	[contatos setTitle:@"Adicionar a Contatos" forState:UIControlStateNormal];
	contatos.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
	contatos.titleLabel.textAlignment = UITextAlignmentCenter;
	contatos.titleLabel.font = [UIFont boldSystemFontOfSize:12];
	[contatos addTarget:self action:@selector(didPresentActionSheet) forControlEvents:UIControlEventTouchDown];
	[contentView addSubview:contatos];
	
	label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 233.0, 320.0, 25.0)];
	[label setText:@"Escolha a Operadora de sua preferência:"];
	[label setFont:[UIFont boldSystemFontOfSize:14]];
	[label setTextAlignment:UITextAlignmentCenter];
	[label setTextColor:[UIColor darkGrayColor]];
	[label setShadowColor:[UIColor whiteColor]];
	[label setShadowOffset:CGSizeMake(1, 1)];
	[label setBackgroundColor:[UIColor clearColor]];
	[contentView addSubview:label];
	[label release];
	
	[contentView addSubview:[self makeButtonWithTitle:@"CTBC Telecom" andTag:CTBC_TAG]];
	[contentView addSubview:[self makeButtonWithTitle:@"Brasil Telecom" andTag:BRT_TAG]];
	[contentView addSubview:[self makeButtonWithTitle:@"Telefonica" andTag:TELEF_TAG]];
	[contentView addSubview:[self makeButtonWithTitle:@"Embratel" andTag:EMBRAT_TAG]];
	[contentView addSubview:[self makeButtonWithTitle:@"Intelig" andTag:INTELI_TAG]];
	[contentView addSubview:[self makeButtonWithTitle:@"GVT" andTag:GVT_TAG]];
	[contentView addSubview:[self makeButtonWithTitle:@"Oi" andTag:OI_TAG]];
	[contentView addSubview:[self makeButtonWithTitle:@"TIM" andTag:TIM_TAG]];
	[contentView addSubview:[self makeButtonWithTitle:@"Outra" andTag:OUTRA_TAG]];
	
	wLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 123.0, 320.0, 25.0)];
	wLabel.backgroundColor = [UIColor colorWithRed:0.863 green:0.874 blue:0.897 alpha:1.000];
	wLabel.font = [UIFont boldSystemFontOfSize:14];
	wLabel.textColor = [UIColor colorWithRed:0.241 green:0.279 blue:0.355 alpha:1.000];
	[wLabel setShadowColor:[UIColor whiteColor]];
	[wLabel setShadowOffset:CGSizeMake(1, 1)];
	wLabel.textAlignment = UITextAlignmentCenter;
	wLabel.alpha = 0;
	[contentView addSubview:wLabel];
	
	self.view = contentView;
	[contentView release];
}

- (UISegmentedControl *)makeButtonWithTitle:(NSString *)aTitle andTag:(NSInteger)aTag {
	UISegmentedControl *button = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:aTitle]];
	button.tintColor = [UIColor colorWithRed:0.488 green:0.488 blue:0.488 alpha:1.000];
	button.segmentedControlStyle = UISegmentedControlStyleBar;
	button.tag = aTag;
	[button addTarget:self action:@selector(changeOperadora:) forControlEvents:UIControlEventValueChanged];
	if (aTag == CTBC_TAG) button.frame = CGRectMake(10.0, 270.0, 96.0, 30.0);
	if (aTag == BRT_TAG) button.frame = CGRectMake(112.0, 270.0, 96.0, 30.0);
	if (aTag == TELEF_TAG) button.frame = CGRectMake(214.0, 270.0, 96.0, 30.0);
	if (aTag == EMBRAT_TAG) button.frame = CGRectMake(10.0, 306.0, 96.0, 30.0);
	if (aTag == INTELI_TAG) button.frame = CGRectMake(112.0, 306.0, 96.0, 30.0);
	if (aTag == GVT_TAG) button.frame = CGRectMake(214.0, 306.0, 96.0, 30.0);
	if (aTag == OI_TAG) button.frame = CGRectMake(10.0, 342.0, 96.0, 30.0);
	if (aTag == TIM_TAG) button.frame = CGRectMake(112.0, 342.0, 96.0, 30.0);
	if (aTag == OUTRA_TAG) {
		button.frame = CGRectMake(214.0, 342.0, 96.0, 30.0);
		button.momentary = YES;
	}
	
	return [button autorelease];
}

- (void)viewWillAppear:(BOOL)animated {
	needsCustomKeyboard = YES;
	if (selectedButton > 0) {
		UISegmentedControl *button = (UISegmentedControl *)[contentView viewWithTag:selectedButton];
		button.selectedSegmentIndex = 0;
	}
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[destino release];
	[ddd release];
	[super dealloc];
}

- (void)dismissKeybord:(id)sender {
	[enabledField resignFirstResponder];
	if (operField.text.length == 0) {
		operLabel.text = @"XX";
		operField.hidden = YES;
	} else if (![operField.text isEqualToString:@"-1"]) {
		operLabel.text = operField.text;
		operField.hidden = YES;
	}
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	enabledField = textField;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	if (phoneField.editing) {
		if (textField.text.length >= 8 && range.length == 0) {
			return NO;
		}
		
	} else if (textField.text.length >= 2 && range.length == 0) {
		return NO;
	} 
	return YES;
}

- (void)changeOperadora:(id)sender {
	if ([sender tag] == selectedButton)
		if ([sender tag] != OUTRA_TAG) return;
	[self deselectTabIndex];
	selectedButton = [sender tag];
	switch ([sender tag]) {
		case CTBC_TAG:
			operLabel.text = @"12";
			break;
		case BRT_TAG:
			operLabel.text = @"14";
			break;
		case TELEF_TAG:
			operLabel.text = @"15";
			break;
		case EMBRAT_TAG:
			operLabel.text = @"21";
			break;
		case INTELI_TAG:
			operLabel.text = @"23";
			break;
		case GVT_TAG:
			operLabel.text = @"25";
			break;
		case OI_TAG:
			operLabel.text = @"31";
			break;
		case TIM_TAG:
			operLabel.text = @"41";
			break;
		case OUTRA_TAG:
			selectedButton = 0;
			[operLabel setText:@""];
			[operField setText:@""];
			[operField setHidden:NO];
			[operField setEnabled:YES];
			[operField becomeFirstResponder];
			break;
		default:
			break;
	}
}

- (void)deselectTabIndex {
	if (selectedButton == 0) return;
	UISegmentedControl *button = (UISegmentedControl *)[contentView viewWithTag:selectedButton];
	button.selectedSegmentIndex = UISegmentedControlNoSegment;
}

- (void)changeViewFor:(id)sender {
	[self dismissKeybord:nil];
	switch ([sender selectedSegmentIndex]) {
		case 0:
			[self setButtons:NO];
			label.hidden = NO;
			operLabel.hidden = NO;
			[mainLabel setFrame:kMainLabelFrame1];
			[mainLabel setText:@"0 +"];
			break;
		case 1:
			[self setButtons:YES];
			label.hidden = YES;
			operField.hidden = YES;
			operLabel.hidden = YES;
			[mainLabel setFrame:kMainLabelFrame2];
			[mainLabel setText:@"+ 55"];
			break;
	}
}

- (void)setButtons:(BOOL)hide {
	[contentView viewWithTag:CTBC_TAG].hidden = hide;
	[contentView viewWithTag:BRT_TAG].hidden = hide;
	[contentView viewWithTag:TELEF_TAG].hidden = hide;
	[contentView viewWithTag:EMBRAT_TAG].hidden = hide;
	[contentView viewWithTag:INTELI_TAG].hidden = hide;
	[contentView viewWithTag:GVT_TAG].hidden = hide;
	[contentView viewWithTag:OI_TAG].hidden = hide;
	[contentView viewWithTag:TIM_TAG].hidden = hide;
	[contentView viewWithTag:OUTRA_TAG].hidden = hide;
}

- (void)validatePhoneNumber:(NSString *)aString {
	
	NSMutableString *phone = [[NSMutableString alloc] initWithString:aString];
	[phone replaceOccurrencesOfString:@" " withString:@"" options:2 range:NSMakeRange(0, phone.length)];
	[phone replaceOccurrencesOfString:@"(" withString:@"" options:2 range:NSMakeRange(0, phone.length)];
	[phone replaceOccurrencesOfString:@")" withString:@"" options:2 range:NSMakeRange(0, phone.length)];
	[phone replaceOccurrencesOfString:@"-" withString:@"" options:2 range:NSMakeRange(0, phone.length)];
	
	if (phone.length > 8) {
		phoneField.text = [phone substringWithRange:NSMakeRange(phone.length - 8, 8)];
		[phone release];
	} else {
		phoneField.text = phone;
		[phone release];
	}
}

- (void)callNumber:(id)sender {
	[self dismissKeybord:nil];
	NSString *fullNumber;
	if (mainTabBar.selectedSegmentIndex == 0) {
		if (ddd.length != 2) return;
		if (phoneField.text.length < 3) {
			[self showWarningWith:@"Informe um Telefone!"];
			return;
		}
		if (operLabel.text.length != 2 || [operLabel.text isEqualToString:@"XX"]) {
			[self showWarningWith:@"Escolha uma Operadora!"];
			return;
		}
		
		fullNumber = [NSString stringWithFormat:@"tel://%@", [self fullPhoneNumberTo:kCallFromBrasil]];
	} else {
		if (phoneField.text.length < 3 || ddd.length != 2) {
			[self showWarningWith:@"Informe um Telefone!"];
			return;
		}
		fullNumber = [NSString stringWithFormat:@"tel://%@", [self fullPhoneNumberTo:kCallFromExterior]];
	}
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:fullNumber]];
}

- (void)smsNumber:(id)sender {
	[self dismissKeybord:nil];
	if (phoneField.text.length < 3 || ddd.length != 2 ) {
		[self showWarningWith:@"Informe um Telefone!"];
		return;
	}
	NSString *fullNumber;
	if (mainTabBar.selectedSegmentIndex == 0) {
		fullNumber = [NSString stringWithFormat:@"sms://%@", [self fullPhoneNumberTo:kSMSFromBrasil]];
	} else {
		fullNumber = [NSString stringWithFormat:@"sms://%@", [self fullPhoneNumberTo:kCallFromExterior]];
	}
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:fullNumber]];
}

- (NSString *)fullPhoneNumberTo:(int)usage {
	if (usage == kCallFromBrasil) {
		return [NSString stringWithFormat:@"0%@%@%@", operLabel.text, ddd, phoneField.text];
	} else if (usage == kCallFromExterior) {
		return [NSString stringWithFormat:@"+55%@%@", ddd, phoneField.text];
	} else if (usage == kSMSFromBrasil) {
		return [NSString stringWithFormat:@"0%@%@", ddd, phoneField.text];
	}
	return nil;
}

- (void)keyboardWillShow:(NSNotification *)note {
    if (!needsCustomKeyboard) {
		return;
	}
	UIWindow *tempWindow;
	UIView *keyboard;
	
	for(int c = 0; c < [[[UIApplication sharedApplication] windows] count]; c ++) {
		tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:c];
		
		for(int i = 0; i < [tempWindow.subviews count]; i++) {
			keyboard = [tempWindow.subviews objectAtIndex:i];
			
			if([[keyboard description] hasPrefix:@"<UIKeyboard"] == YES) {
				
				UIButton *done = [UIButton buttonWithType:UIButtonTypeCustom];
				done.frame = CGRectMake(0, 163, 106, 53);
				[done setImage:[UIImage imageNamed:@"done.png"] forState:UIControlStateNormal];
				[done setImage:[UIImage imageNamed:@"donePressed.png"] forState:UIControlStateHighlighted];
				[keyboard addSubview:done];
				[done addTarget:keyboard action:@selector(orderOutWithAnimation:) forControlEvents:UIControlEventTouchUpInside];
				return;
			}
		}
	}
}

- (void)keyboardWillHide:(NSNotification *)note {
	[enabledField resignFirstResponder];
	if (enabledField == operField) {
		if (operField.text.length == 0) {
			operLabel.text = @"XX";
			operField.hidden = YES;
		} else if (![operField.text isEqualToString:@"-1"]) {
			operLabel.text = operField.text;
			operField.hidden = YES;
		}
	}
	[self deselectTabIndex];
}

- (void)didPresentActionSheet {
	[self dismissKeybord:nil];
	if (mainTabBar.selectedSegmentIndex == 0) {
		if (ddd.length != 2) return;
		if (phoneField.text.length < 3) {
			[self showWarningWith:@"Informe um Telefone!"];
			return;
		}
		if (operLabel.text.length != 2 || [operLabel.text isEqualToString:@"XX"]) {
			[self showWarningWith:@"Escolha uma Operadora!"];
			return;
		}
	} else {
		if (phoneField.text.length < 3 || ddd.length != 2) 
		{
			[self showWarningWith:@"Informe um Telefone!"];
			return;
		}
	}
	[self presentSheet];
}

- (void)presentSheet {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
															 delegate:self
													cancelButtonTitle:@"Cancelar"
											   destructiveButtonTitle:nil
													otherButtonTitles:@"Criar Novo Contato", @"Adicionar a Contato", nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[actionSheet showInView:self.view];
	[actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	switch (buttonIndex) {
		case 0:
			[self addNewContact];
			break;
		case 1:
			[self selectContact:nil];
			break;
		default:
			break;
	}
}

#pragma mark -
#pragma mark AddressBook

- (void)selectContact:(id)sender {
	if ([sender tag] == kPickContact) {
		peoplePickerOnly = [[ABPeoplePickerNavigationController alloc] init];
		peoplePickerOnly.peoplePickerDelegate = self;
		peoplePickerOnly.navigationBar.barStyle = UIBarStyleBlackOpaque;
		[self presentModalViewController:peoplePickerOnly animated:YES];
		[peoplePickerOnly release];
	} else {
		peoplePickerToChange = [[ABPeoplePickerNavigationController alloc] init];
		peoplePickerToChange.peoplePickerDelegate = self;
		peoplePickerToChange.editing = YES;
		peoplePickerToChange.navigationBar.barStyle = UIBarStyleBlackOpaque;
		[self presentModalViewController:peoplePickerToChange animated:YES];
		[peoplePickerToChange release];
	}
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker 
	  shouldContinueAfterSelectingPerson:(ABRecordRef)thisPerson {
	if (peoplePicker == peoplePickerOnly) {
		return YES;
	} else {
		CFErrorRef anError = NULL;
		
		ABMutableMultiValueRef multiValueRef = ABRecordCopyValue(thisPerson, kABPersonPhoneProperty);
		ABMutableMultiValueRef multi = ABMultiValueCreateMutableCopy(multiValueRef);
		CFRelease(multiValueRef);
		BOOL didAdd = NO; 
		
		if (mainTabBar.selectedSegmentIndex == 0) {
			didAdd = ABMultiValueAddValueAndLabel(multi, [self fullPhoneNumberTo:kCallFromBrasil], kABPersonPhoneMainLabel, NULL);
		} else if (mainTabBar.selectedSegmentIndex == 1) {
			didAdd = ABMultiValueAddValueAndLabel(multi, [self fullPhoneNumberTo:kCallFromExterior], kABPersonPhoneMainLabel, NULL);
		}
		
		if (!didAdd) {
			NSLog(@"ERROR");
		}
		
		ABRecordSetValue(thisPerson, kABPersonPhoneProperty, multi, &anError);
		CFRelease(multi);
		ABAddressBookSave(peoplePicker.addressBook, &anError);
		[self dismissModalViewControllerAnimated:YES];
	}
	return NO;
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
	[self dismissModalViewControllerAnimated:YES];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker 
	  shouldContinueAfterSelectingPerson:(ABRecordRef)person 
								property:(ABPropertyID)property 
							  identifier:(ABMultiValueIdentifier)identifier {	
	if (peoplePicker == peoplePickerOnly) {
		
		if (property == kABPersonPhoneProperty) {
			ABMultiValueRef thisPhone = ABRecordCopyValue(person, property);
			CFStringRef phoneRef = ABMultiValueCopyValueAtIndex(thisPhone, identifier);
			NSString *phoneNumber = [NSString stringWithString:(NSString *)phoneRef];
			[self validatePhoneNumber:phoneNumber];
			[self dismissModalViewControllerAnimated:YES];
			CFRelease(phoneRef);
			CFRelease(thisPhone);
			return NO;
		}
	}
	return NO;	
}

- (void)addNewContact {
	needsCustomKeyboard = NO;
	ABNewPersonViewController *newPersonViewController = [[ABNewPersonViewController alloc] init];
	[newPersonViewController setNewPersonViewDelegate:self];
	ABRecordRef aRecord = ABPersonCreate();
	CFErrorRef anError = NULL;
	
	ABMutableMultiValueRef multi = ABMultiValueCreateMutable(kABMultiStringPropertyType);
	BOOL didAdd = NO; 
	
	if (mainTabBar.selectedSegmentIndex == 0) {
		didAdd = ABMultiValueAddValueAndLabel(multi, [self fullPhoneNumberTo:kCallFromBrasil], kABPersonPhoneMainLabel, NULL);
	} else if (mainTabBar.selectedSegmentIndex == 1) {
		didAdd = ABMultiValueAddValueAndLabel(multi, [self fullPhoneNumberTo:kCallFromExterior], kABPersonPhoneMainLabel, NULL);
	}
	
	if (!didAdd) {
		NSLog(@"ERROR");
	}
	
	ABRecordSetValue(aRecord, kABPersonPhoneProperty, multi, &anError);
	CFRelease(multi);
	
	newPersonViewController.displayedPerson = aRecord;
	CFRelease(aRecord);
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:newPersonViewController];
	[newPersonViewController release];
	navController.navigationBar.barStyle = UIBarStyleBlackOpaque;
	[self presentModalViewController:navController animated:YES];
}

- (void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person {
	[self dismissModalViewControllerAnimated:YES];
}

- (BOOL)personViewController:(ABPersonViewController *)personViewController 
shouldPerformDefaultActionForPerson:(ABRecordRef)person 
					property:(ABPropertyID)property 
				  identifier:(ABMultiValueIdentifier)identifier {
	return NO;
}

- (void)showWarningWith:(NSString *)text {
	
	[wLabel setText:text];
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.5];
	[wLabel setAlpha:1.0];
	[UIView commitAnimations];
	
	[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(hideWarning) userInfo:nil repeats:NO];
}

- (void)hideWarning {
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.5];
	[wLabel setAlpha:0.0];
	[UIView commitAnimations];
}

@end
