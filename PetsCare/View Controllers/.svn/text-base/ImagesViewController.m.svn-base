//
//  ImagesViewController.m
//  PetsCare
//
//  Created by Fabio Leonardo Jung on 14/07/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import "ImagesViewController.h"

#define kImageFirstTag 5000

@interface ImagesViewController	()
- (void)loadDataSource;
@end

@implementation ImagesViewController

@synthesize delegate;


- (id)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
		self.title = NSLocalizedString(@"GenericAlbum", nil);
		
		UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																					target:self 
																					action:@selector(cancel)];
		self.navigationItem.rightBarButtonItem = doneButton;
		[doneButton release];
		
		[self loadDataSource];
    }
    return self;
}

- (UIButton *)makeButtonWithTag:(NSInteger)aTag andFrame:(CGRect)aFrame {
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame = aFrame;
	button.backgroundColor = [UIColor whiteColor];
	button.tag = aTag;
	[button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png", aTag]] forState:UIControlStateNormal];
	[button setImage:[UIImage imageNamed:@"border.png"] forState:UIControlStateNormal];
	[button setImage:[UIImage imageNamed:@"mask.png"] forState:UIControlStateHighlighted];
	[button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
	return button;
}

- (void)cancel {
	[self.delegate imagesViewControllerDidCancel:self];
}

- (void)buttonAction:(id)sender {
	NSString *imagePath = [NSString stringWithFormat:@"%d", [sender tag]];
	[self.delegate imagesViewController:self didFinishPickingImage:[UIImage imageFromImagesBundle:imagePath]];
}

- (void)viewDidLoad {
	[self.tableView setSeparatorStyle:UITableViewCellSelectionStyleNone];
    [super viewDidLoad];
}

- (void)loadDataSource {
	cellArray = [[NSMutableArray alloc] init];
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSInteger theTag = kImageFirstTag;
	for (int i = 0; i < 4; i++) {
		CGRect firstFrame = CGRectMake(4.0, 2.0, 75.0, 75.0);
		NSMutableArray *array = [NSMutableArray array];
		for (int j = 0; j < 4; j++) {
			if (j > 0) {
				firstFrame = CGRectMake(firstFrame.origin.x + 79, firstFrame.origin.y, firstFrame.size.width, firstFrame.size.height);
			}
			[array addObject:[self makeButtonWithTag:theTag andFrame:firstFrame]];
			theTag++;
		}
		[cellArray addObject:array];
	}
	[pool release];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 79.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    
    [cell.contentView addSubview:[[cellArray objectAtIndex:indexPath.row] objectAtIndex:0]];
	[cell.contentView addSubview:[[cellArray objectAtIndex:indexPath.row] objectAtIndex:1]];
	[cell.contentView addSubview:[[cellArray objectAtIndex:indexPath.row] objectAtIndex:2]];
	[cell.contentView addSubview:[[cellArray objectAtIndex:indexPath.row] objectAtIndex:3]];
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)dealloc {
	[cellArray release];
	cellArray = nil;
    [super dealloc];
}

@end
