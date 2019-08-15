//
//  WeightGraphView.m
//  PetsCare
//
//  Created by Fabio Leonardo Jung on 30/03/09.
//  Copyright 2009 iTouchFactory. All rights reserved.
//

#import "WeightGraphView.h"
#import "Weight.h"
#import "DateHelper.h"

@implementation WeightGraphView

- (id)initWithFrame:(CGRect)rect {
	[super initWithFrame:rect];
	return self;
}

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	
	CGContextRef c = UIGraphicsGetCurrentContext();
	
	//draw background:
	float maxX = 305.0;
	float minX = 40.0;
	float minY = 30.0;
	float maxY = 170;
	
	
	NSString *statem = [NSString stringWithFormat:@"WHERE petpk = '%d';", self.petpk];
	if ([[Weight findByCriteria:statem] count] < 2) {
		NSString *noData = NSLocalizedString(@"No Data", nil);
		float actualFontSize = 10.0;
		[noData sizeWithFont:[UIFont boldSystemFontOfSize:100.0] 
				 minFontSize:10.0 
			  actualFontSize:&actualFontSize 
					forWidth:(maxX - minX) 
			   lineBreakMode:UILineBreakModeClip];
		CGSize actualSize = [noData sizeWithFont:[UIFont boldSystemFontOfSize:actualFontSize]];
		[[UIColor colorWithWhite:0.8 alpha:1.0] set];
		CGRect appNameRect = CGRectMake(25.0, minY, maxX - 25.0, actualSize.height);
		[noData drawInRect:appNameRect 
				  withFont:[UIFont boldSystemFontOfSize:actualFontSize] 
			 lineBreakMode:UILineBreakModeClip 
				 alignment:UITextAlignmentCenter];
		return;
	}
	float maxWeight = 0.0;
	
	NSString *statement = [NSString stringWithFormat:@"WHERE petpk = '%d' ORDER BY weight DESC;", self.petpk];
	maxWeight = [[[[Weight findByCriteria:statement] objectAtIndex:0] weight] floatValue];
	
	if (maxWeight <= 0.0) {
		return;
	}
	
	UIColor *graphColor = nil;
	
	graphColor = [UIColor colorWithRed:0.12 green:0.35 blue:0.71 alpha:1.0];
	
	//draw grid and captions:
	CGContextBeginPath(c);
	CGContextSetLineWidth(c, 1.0);
	CGContextSetAllowsAntialiasing(c, NO);
	[[UIColor darkGrayColor] set];
	CGContextMoveToPoint(c, minX, minY - 2);
	CGContextAddLineToPoint(c, maxX, minY - 2);
	CGContextMoveToPoint(c, maxX, maxY + 2);
	CGContextAddLineToPoint(c, minX, maxY + 2);
	CGContextDrawPath(c, kCGPathStroke);
	CGContextSetAllowsAntialiasing(c, YES);
	
	[@"0" drawInRect:CGRectMake(0, maxY - 4, minX - 4, 10) 
			withFont:[UIFont boldSystemFontOfSize:10.0] 
	   lineBreakMode:UILineBreakModeCharacterWrap
		   alignment:UITextAlignmentRight];
	
	NSString *maxString = [NSString stringWithFormat:@"%i", (int)maxWeight];
	
	[maxString drawInRect:CGRectMake(0, minY - 8, minX - 4, 10) 
				 withFont:[UIFont boldSystemFontOfSize:10.0] 
			lineBreakMode:UILineBreakModeCharacterWrap
				alignment:UITextAlignmentRight];
	
	[[UIColor blackColor] set];
	NSString *caption = [NSString stringWithFormat:@"%@ (%@)", NSLocalizedString(@"Weight", nil), self.weightUnit];
	
	[caption drawInRect:CGRectMake(10, 5, 300, 20)
			   withFont:[UIFont systemFontOfSize:12.0]
		  lineBreakMode:UILineBreakModeCharacterWrap
			  alignment:UITextAlignmentLeft];
	
	NSString *subtitle = [NSString stringWithFormat:@"%@                                         %@", 
						  [DateHelper stringFromDate:[[weights objectAtIndex:0] date] withNames:NO], 
						  [DateHelper stringFromDate:[[weights lastObject] date] withNames:NO]];
	
	[subtitle drawInRect:CGRectMake(20, maxY + 8, 300, 20) 
				withFont:[UIFont systemFontOfSize:12.0] 
		   lineBreakMode:UILineBreakModeCharacterWrap 
			   alignment:UITextAlignmentCenter];
	
	//draw weekend background:
	
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSUInteger unitFlags = NSDayCalendarUnit;
	NSDateComponents *components = [gregorian components:unitFlags
												fromDate:[[weights objectAtIndex:0] date]
												  toDate:[[weights lastObject] date] 
												 options:0];
	NSInteger adays = [components day];
	CGContextSetAllowsAntialiasing(c, NO);
	float weekendWidth = (maxX - minX) / (adays);
	UIColor *shade;
	shade = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.2];
	[shade set];
	int count = 0;
	for (int i = 0; i < adays; i++) {
		count++;		
		if (count == 30) {
			float x = minX + ((maxX - minX) / (adays)) * i;
			float x2 = x + weekendWidth;
			if (x2 > maxX) x2 = maxX;
			CGRect weekendRect = CGRectMake(x, minY - 2, (x2 - x), (maxY - minY) + 3);
			CGContextFillRect(c, weekendRect);
			count = 0;
		}
		
	}
	CGContextSetAllowsAntialiasing(c, YES);
	
	//draw trend line:
	[graphColor set];
	int i = 0;
	float prevX = 0.0;
	CGContextBeginPath(c);
	CGContextSetLineWidth(c, 2.0);
	CGContextSetLineJoin(c, kCGLineJoinRound);
	
	for (Weight *w in weights) {
		NSDateComponents *dayComponents = [gregorian components:unitFlags
													   fromDate:[[weights objectAtIndex:0] date]
														 toDate:[w date] 
														options:0];
		float r = [[w weight] floatValue];
		float y = maxY - ((r / maxWeight) * (maxY - minY));
		float x = minX + ((maxX - minX) / adays) * [dayComponents day];
		CGRect rect = CGRectMake(x - 1, y - 1, 2, 2);
		if (prevX == 0.0) {
			CGContextMoveToPoint(c, x, y);
		}
		else {
			CGContextAddLineToPoint(c, x, y);
		}
		CGContextAddEllipseInRect(c, rect);
		
		prevX = x;
		i++;
	}
	CGContextDrawPath(c, kCGPathStroke);
	
	for (int i = 0; i < [weights count] - 1; i++) {
		if (i % 2 == 0) {
			float valueY = maxY - (([[[weights objectAtIndex:i] weight] floatValue] / maxWeight) * (maxY - minY));
			if ((valueY < (maxY + 10)) && (valueY > (minY + 10))) {
				NSString *firstWeightString = [NSString stringWithFormat:@"%i", (int)[[[weights objectAtIndex:i] weight] floatValue]];
				[graphColor set];
				[firstWeightString drawInRect:CGRectMake(0, valueY - 6, minX - 4, 10) 
									 withFont:[UIFont boldSystemFontOfSize:10.0]
								lineBreakMode:UILineBreakModeCharacterWrap 
									alignment:UITextAlignmentRight];
			}
			//draw average line:
			[graphColor set];
			CGContextSetLineWidth(c, 1.0);
			CGContextSetAllowsAntialiasing(c, YES);
			CGContextBeginPath(c);
			float lengths[] = {2.0, 2.0};
			CGContextSetLineDash(c, 0.0, lengths, 2);
			CGContextMoveToPoint(c, minX, valueY);
			CGContextAddLineToPoint(c, maxX, valueY);
			CGContextDrawPath(c, kCGPathStroke);
			CGContextSetLineDash(c, 0.0, NULL, 0);
		}
		
	}
	[gregorian release];
}

- (void)dealloc 
{	
    [super dealloc];
}

@end