//
//  MWAddLocationViewController.h
//  MultiWeather
//
//  Created by AIrza on 12/06/14.
//  Copyright (c) 2014 AIrza Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWLocation.h"
#import "MWLocationManager.h"

@class MWAddLocationViewController;

@protocol MWAddLocationDelegate <NSObject>

@optional
-(void)addLocation:(MWAddLocationViewController *)sender didDisappearWithLocation:(MWLocation *)location;

@end

@interface MWAddLocationViewController : UIViewController<UISearchBarDelegate, MWLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UITableView *locationsTableView;
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (assign, nonatomic) id<MWAddLocationDelegate>delegate;

- (IBAction)cancelPressed:(id)sender;
- (IBAction)donePressed:(id)sender;

@end
