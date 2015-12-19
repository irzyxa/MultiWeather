//
//  MWViewController.m
//  MultiWeather
//
//  Created by AIrza on 6/5/14.
//  Copyright (c) 2014 AIrza Inc. All rights reserved.
//

#import "MWViewController.h"
#import "MWLocation.h"
#import "MWLocationCell.h"
#import "MWManager.h"
#import "MWWeatherPageViewController.h"
#import "UIColor+Helper.h"

@interface MWViewController ()

@property(nonatomic, retain) NSMutableArray *items;

@end

@implementation MWViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[MWManager sharedManager] getDefaultLocation];
    
    [self loadPreviousData];

    [[[MWManager sharedManager] defaultLocation] addObserver:self forKeyPath:@"cityName" options:0 context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveCurrentData) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    NSIndexPath *indexPath = self.locationsTableView.indexPathForSelectedRow;
    if (indexPath) {
        [self.locationsTableView deselectRowAtIndexPath:indexPath animated:animated];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [[[MWManager sharedManager] defaultLocation] removeObserver:self forKeyPath:@"cityName"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_items release];
    [_locationsTableView release];
    [super dealloc];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"cityName"]) {
        [self.locationsTableView reloadData];
    }
}

#pragma mark - Advanced methods

- (void)loadPreviousData
{
   self.items = [[MWManager sharedManager] loadFavoritesLocations];
}

- (void)saveCurrentData
{
    [[MWManager sharedManager] saveFavoritesLocations:self.items];
}

#pragma mark - TableView datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else {
        return self.items.count;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.items.count > 0)
        return 2;
    else
        return 1;
}

#pragma mark - TableView deleagte

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MWLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocationCell"];

    if (indexPath.section == 0) {
        cell.cityImageView.image = [UIImage imageNamed:@"defaultLocation"];
        cell.cityLabel.textColor = [UIColor colorWithR:82 G:188 B:255];
        MWLocation *item = [[MWManager sharedManager] defaultLocation];
        
        cell.cityLabel.text = item.cityName;
        cell.regionLabel.text = item.regionName;
    } else {
        cell.cityImageView.image = [UIImage imageNamed:@"location"];
        cell.cityLabel.textColor = [UIColor blackColor];

        MWLocation *item = self.items[indexPath.row];
        
        cell.cityLabel.text = item.cityName;
        cell.regionLabel.text = item.regionName;
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"WeatherSegue" sender:[tableView cellForRowAtIndexPath:indexPath]];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return NO;
    } else {
        return YES;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Default Location";
    } else if (section == 1  && self.items.count > 0) {
        return @"Favorites";
    } else {
        return nil;
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.items removeObjectAtIndex:indexPath.row];
        if (self.items.count > 0) {
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        } else { //need remove last cell and section
            [self.locationsTableView beginUpdates];
            
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                
            NSMutableIndexSet *indexes = [[NSMutableIndexSet alloc] init];
            [indexes addIndex:indexPath.section];
            [tableView deleteSections:indexes withRowAnimation:UITableViewRowAnimationAutomatic];
            [indexes release];
            
            [self.locationsTableView endUpdates];
        }
    }
}

#pragma mark - Segues

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"WeatherSegue"]) {
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.locationsTableView indexPathForCell:cell];
        MWWeatherPageViewController *weatherPageVC = segue.destinationViewController;
        if (indexPath.section == 0)
            weatherPageVC.location = [MWManager sharedManager].defaultLocation;
        else
            weatherPageVC.location = self.items[indexPath.row];
    } else if ([segue.identifier isEqualToString:@"AddLocationSegue"]) {
        
        UINavigationController *addLocationNC = segue.destinationViewController;
        MWAddLocationViewController *addLocationVC = addLocationNC.viewControllers[0];
        addLocationVC.delegate = self;
    }
}

#pragma mark - MWAddLocation Delegate
-(void)addLocation:(MWAddLocationViewController *)sender didDisappearWithLocation:(MWLocation *)location
{
    [self.items addObject:location];
    [self.locationsTableView reloadData];
}

@end
