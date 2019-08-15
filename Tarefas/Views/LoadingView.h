//
//  LoadingView.h
//  LoadingLayer
//
//  Created by Fabio Leonardo Jung on 26/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoadingView : UIView {
	UIActivityIndicatorView *indicator;
	UILabel *label;
}
@property (nonatomic, retain) UIActivityIndicatorView *indicator;
@property (nonatomic, retain) UILabel *label;

@end
