//
//  MWProgressHUD.m
//  MultiWeather
//
//  Created by AIrza on 7/1/14.
//  Copyright (c) 2014 AIrza Inc. All rights reserved.
//

#import "MWProgressHUD.h"

@interface MWProgressHUD ()

@property (nonatomic, retain) UIActivityIndicatorView *activitiIndicatorView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, assign) CGRect boxRect;

@end

const CGFloat boxWidth = 96.0f;
const CGFloat boxHeight = 96.0f;

@implementation MWProgressHUD

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.title = @"Loading...";
        
		_activitiIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		[self.activitiIndicatorView startAnimating];
		[self addSubview:self.activitiIndicatorView];
        
		_titleLabel = [[UILabel alloc] initWithFrame:frame];
        self.titleLabel.font = [UIFont systemFontOfSize:12.f];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.opaque = NO;
        self.titleLabel.numberOfLines = 2;
        self.titleLabel.adjustsFontSizeToFitWidth = NO;
        self.titleLabel.text = self.title;
        self.titleLabel.textColor = [UIColor whiteColor];
		[self addSubview:self.titleLabel];
    }
    return self;
}

+ (MWProgressHUD *)showHUDForView:(UIView *)view
{
    MWProgressHUD *hudView = [[MWProgressHUD alloc] initWithFrame:view.bounds];
    
    hudView.opaque = NO;
    [view addSubview:hudView];
    view.userInteractionEnabled = NO;
    
    return [hudView autorelease];
}

+ (void)hideHUDForView:(UIView *)view
{
    MWProgressHUD *hudView = [MWProgressHUD hudForView:view];
    if (hudView) {
        [hudView removeFromSuperview];
    }
    view.userInteractionEnabled = YES;
}

+ (MWProgressHUD *)hudForView:(UIView *)view
{
    for (UIView *subview in view.subviews) {
        if ([subview isKindOfClass:[self class]]) {
            return (MWProgressHUD *)subview;
        }
    }
    return nil;
}

-(CGRect)boxRect
{
    return CGRectMake((self.superview.bounds.size.width - boxWidth) / 2.f, (self.superview.bounds.size.height - boxHeight) /2.f, boxWidth, boxHeight);
}

- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	UIGraphicsPushContext(context);

    //Gradient colours
    size_t gradLocationsNum = 2;
    CGFloat gradLocations[2] = {0.0f, 1.0f};
    CGFloat gradColors[8] = {0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.75f};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum);
    CGColorSpaceRelease(colorSpace);
    //Gradient center
    CGPoint gradCenter= CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    //Gradient radius
    float gradRadius = MIN(self.bounds.size.width , self.bounds.size.height) ;
    //Gradient draw
    CGContextDrawRadialGradient (context, gradient, gradCenter,
                                 0, gradCenter, gradRadius,
                                 kCGGradientDrawsAfterEndLocation);
    CGGradientRelease(gradient);
    
    UIBezierPath *roundRect = [UIBezierPath bezierPathWithRoundedRect:self.boxRect cornerRadius:10.0f];
    
    [[UIColor colorWithWhite:0.0f alpha:0.75f] setFill];
    
    [roundRect fill];
    
    NSString *topTitleText = @"Loading";
    
    UIFont *font = [UIFont boldSystemFontOfSize:12.0f];
    
    CGSize textSize = [topTitleText sizeWithAttributes:@{NSFontAttributeName: font}];
    
    CGPoint textPoint = CGPointMake(self.boxRect.origin.x + (self.boxRect.size.width / 2.f) - (textSize.width / 2.f) , self.boxRect.origin.y + 2.f);
    
    [topTitleText drawAtPoint:textPoint withAttributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    UIGraphicsPopContext();
}

-(void)layoutSubviews
{
	CGRect indicatorRect = _activitiIndicatorView.bounds;
   
	CGFloat yPos = roundf(self.boxRect.origin.y + (self.boxRect.size.height / 2.f) - (indicatorRect.size.height / 2.f));
	CGFloat xPos = roundf(self.boxRect.origin.x + (self.boxRect.size.width / 2.f) - (indicatorRect.size.width / 2.f));
	indicatorRect.origin.y = yPos - 5.f;
	indicatorRect.origin.x = xPos;
	_activitiIndicatorView.frame = indicatorRect;
    
    _titleLabel.text = self.title;
    
	CGRect titleRect = _titleLabel.bounds;
    titleRect.size.width = boxWidth;
    titleRect.size.height = 32.f;
    
	yPos = roundf(self.boxRect.origin.y + self.boxRect.size.height - titleRect.size.height);
	xPos = roundf(self.boxRect.origin.x + (self.boxRect.size.width / 2.f) - (titleRect.size.width / 2.f));
    
	titleRect.origin.y = yPos;
	titleRect.origin.x = xPos;
    
    _titleLabel.frame = titleRect;
    
}

-(void)dealloc
{
    [_titleLabel release];
    [_activitiIndicatorView release];
    [super dealloc];
}

@end
