//
//  MWViewController.h
//  MultiWeather
//
//  Created by AIrza on 6/5/14.
//  Copyright (c) 2014 AIrza Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWWeatherViewController.h"
#import "MWAddLocationViewController.h"

@interface MWViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, MWAddLocationDelegate>
@property (retain, nonatomic) IBOutlet UITableView *locationsTableView;

@end
