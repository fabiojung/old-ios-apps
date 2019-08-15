//
//  DateViewController.m
//  Tarefas
//
//  Created by Fabio Leonardo Jung on 25/08/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import "DateViewController.h"
#import "DateHelper.h"

@implementation DateViewController

@synthesize dueDate, delegate;

- (id)init {
    if (self = [super init]) {
		self.title = NSLocalizedString(@"DueDate_Loc", nil);
    }
    return self;
}

- (void)dealloc {
	[dueDate release];
    [super dealloc];
}

- (void)loadView {
	UIView *contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	contentView.backgroundColor = [UIColor clearColor];
	
	dateTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 50.0, 320.0, 60.0) 
															  style:UITableViewStyleGrouped];
	dateTableView.backgroundColor = [UIColor clearColor];
	dateTableView.scrollEnabled = NO;
	dateTableView.delegate = self;
	dateTableView.dataSource = self;
	[contentView addSubview:dateTableView];
	[dateTableView release];
	
	UIToolbar *dateToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 372.0, 320.0, 44.0)];
	NSMutableArray *buttons = [NSMutableArray array];
	UIBarButtonItem *flexibleSpaceItem; 
	flexibleSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
																	  target:nil 
																	  action:NULL]; 
	[buttons addObject:flexibleSpaceItem]; 
	[flexibleSpaceItem release];
	UIBarButtonItem *button; 
	button = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Today_Loc", nil) 
											  style:UIBarButtonItemStyleBordered 
											 target:self 
											 action:@selector(datePickerToday)];
	[buttons addObject:button]; 
	[button release]; 
	flexibleSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
																	  target:nil 
																	  action:NULL];
	[buttons addObject:flexibleSpaceItem]; 
	[flexibleSpaceItem release];
	button = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"PlusWeek_Loc", nil) 
											  style:UIBarButtonItemStyleBordered 
											 target:self 
											 action:@selector(datePickerPlusWeek)];
	[buttons addObject:button]; 
	[button release]; 
	flexibleSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
																	  target:nil 
																	  action:NULL];
	[buttons addObject:flexibleSpaceItem]; 
	[flexibleSpaceItem release];
	button = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"PlusMonth_Loc", nil) 
											  style:UIBarButtonItemStyleBordered 
											 target:self 
											 action:@selector(datePickerPlusMonth)];
	[buttons addObject:button]; 
	[button release]; 
	flexibleSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
																	  target:nil 
																	  action:NULL]; 
	[buttons addObject:flexibleSpaceItem]; 
	[flexibleSpaceItem release];
	button = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"PlusYear_Loc", nil) 
											  style:UIBarButtonItemStyleBordered 
											 target:self 
											 action:@selector(datePickerPlusYear)];
	[buttons addObject:button]; 
	[button release]; 
	flexibleSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
																	  target:nil 
																	  action:NULL];
	[buttons addObject:flexibleSpaceItem]; 
	[flexibleSpaceItem release];
	[dateToolBar setItems:buttons animated:YES];
	[dateToolBar setBarStyle:UIBarStyleDefault];
	[contentView addSubview:dateToolBar];
	[dateToolBar release];
	
	datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 156.0, 300.0, 200.0)];
	[datePicker setDatePickerMode:UIDatePickerModeDate];
	[datePicker addTarget:self action:@selector(datePickerChangeDate) forControlEvents:UIControlEventValueChanged];
	if (![DateHelper isValidDueDate:self.dueDate]) {
		datePicker.date = [NSDate date];
		self.dueDate = [NSDate date];
	} else {
		datePicker.date = dueDate;
	}
	[contentView addSubview:datePicker];
	[datePicker release];
	self.view = contentView;
	[contentView release];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated {
	if (self.dueDate != nil)
		[self.delegate dateViewControllerEndWithDate:[DateHelper dateWithoutTimeFor:self.dueDate]];
	else 
		[self.delegate dateViewControllerEndWithDate:nil];

	[super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
	[dateTableView reloadData];
	[super viewWillAppear:animated];
}

- (void)datePickerChangeDate {
	self.dueDate = datePicker.date;
	[dateTableView reloadData];
}

- (void)datePickerToday {
	[datePicker setDate:[NSDate date] animated:YES];
	[self datePickerChangeDate];
}

- (void)datePickerPlusWeek {
	NSDate *date = datePicker.date;
	[datePicker setDate:[date addTimeInterval:604800] animated:YES];
	[self datePickerChangeDate];
}

- (void)datePickerPlusMonth {
	NSDate *date = datePicker.date;
	[datePicker setDate:[DateHelper dateByAddingOneMonth:date] animated:YES];
	[self datePickerChangeDate];
}

- (void)datePickerPlusYear {
	NSDate *date = datePicker.date;
	[datePicker setDate:[DateHelper dateByAddingOneYear:date] animated:YES];
	[self datePickerChangeDate];
}

- (void)datePickerNoDueDate {
	[datePicker setDate:[NSDate date] animated:YES];
	self.dueDate = nil;
	[dateTableView reloadData];
}

#pragma mark -
#pragma mark TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"DateCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.imageView.image = [UIImage imageNamed:@"cal.png"];
	cell.textLabel.font = [UIFont systemFontOfSize:17];
	cell.textLabel.textColor = [UIColor colorWithRed:0.243 green:0.306 blue:0.435 alpha:1.0];
	
	if (self.dueDate == nil) {
		cell.textLabel.text = NSLocalizedString(@"NoDueDate_Loc", @"");
	} else {
		cell.textLabel.text = [DateHelper stringFromDate:self.dueDate withNames:NO];
	} 
	
	UIButton *noDateButton = [UIButton buttonWithType:UIButtonTypeCustom];
	noDateButton.backgroundColor = [UIColor clearColor];
	noDateButton.frame = CGRectMake(0.0, 0.0, 25.0, 25.0);
	[noDateButton setImage:[UIImage imageNamed:@"accessory.png"] forState:UIControlStateNormal];
		//[noDateButton setImage:[UIImage imageNamed:@"accessory.png"] forState:UIControlStateNormal];
	[noDateButton addTarget:self action:@selector(datePickerNoDueDate) forControlEvents:UIControlEventTouchDown];
	
	cell.accessoryView = noDateButton;
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
