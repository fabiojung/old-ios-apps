//
//  AboutViewController.m
//  DDD Brasil
//
//  Created by Fabio Leonardo Jung on 12/08/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import "AboutViewController.h"

@implementation AboutViewController

@synthesize appVersion;
@synthesize appCopyright;
@synthesize appRights;

- (id)infoValueForKey:(NSString*)key
{
	if ([[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:key])
		return [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:key];
	return [[[NSBundle mainBundle] infoDictionary] objectForKey:key];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIBarButtonItem *mailButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose 
																				target:self 
																				action:@selector(displayComposerSheet)];
	self.navigationItem.rightBarButtonItem = mailButton;
	[mailButton release];
	
	[appVersion setText:[NSString stringWithFormat:@"%@ %@", @"Versão", [self infoValueForKey:@"CFBundleVersion"]]];
	[appCopyright setText:[self infoValueForKey:@"NSHumanReadableCopyright"]];
	[appRights setText:@"Todos Direitos Reservados."];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {

}

- (void)showMessageResult:(NSString *)text {
	UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:nil 
													  message:text
													 delegate:self 
											cancelButtonTitle:nil 
											otherButtonTitles:@"Ok", nil];
	[myAlert show];
	[myAlert release];
}

-(void)displayComposerSheet {
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.navigationBar.barStyle = UIBarStyleBlackOpaque;
    picker.mailComposeDelegate = self;
    
    [picker setSubject:@"DDD Brasil"];
	NSArray *toRecipients = [NSArray arrayWithObject:@"contact@itouchfactory.com"]; 
    
    [picker setToRecipients:toRecipients];
    
    [self presentModalViewController:picker animated:YES];
    [picker release];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{    
    switch (result) {
        case MFMailComposeResultSent:
            [self showMessageResult:@"Sua mensagem foi enviada! Obrigado por entrar em contato."];
            break;
        default:
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (void)dealloc {
	[appVersion release];
	[appCopyright release];
	[appRights release];
    [super dealloc];
}

@end
