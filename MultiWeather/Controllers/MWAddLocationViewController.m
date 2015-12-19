//
//  MWAddLocationViewController.m
//  MultiWeather
//
//  Created by AIrza on 12/06/14.
//  Copyright (c) 2014 AIrza Inc. All rights reserved.
//

#import "MWAddLocationViewController.h"
#import "UIAlertView+Helper.h"

@interface MWAddLocationViewController ()

@property (nonatomic, retain) MWLocationManager *locationManager;
@property (nonatomic, retain) NSArray *items;
@property (nonatomic, retain) NSIndexPath *checkedIndexPath;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation MWAddLocationViewController {
    MWLocation *curLocation;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _locationManager = [[MWLocationManager alloc] init];
    _items = [[NSArray alloc] init];
    
    UITapGestureRecognizer *tap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)] autorelease];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    [self addActivityIndicatorToSearchBar];
    
    self.locationManager.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    _locationManager.delegate = nil;
    [_locationManager release];
    [_locationsTableView release];
    [_doneButton release];
    [_checkedIndexPath release];
    [_searchBar release];
    [_activityIndicatorView release];
    [super dealloc];
}

- (void)addActivityIndicatorToSearchBar
{
    UITextField *searchTextField = nil;
    
    for (UIView *view in self.searchBar.subviews) {
        for (UIView *secView in view.subviews) {
            
            if ([secView isKindOfClass:[UITextField class]]) {
                searchTextField = (UITextField *)secView;
                break;
            }
        }
    }
    
    if (searchTextField) {
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicatorView.center = searchTextField.leftView.center;
        indicatorView.hidesWhenStopped = YES;
        self.activityIndicatorView = indicatorView;
        [indicatorView release];
        
        [searchTextField.leftView addSubview:self.activityIndicatorView];
    }
}

- (void) startActivity
{
    [self.activityIndicatorView startAnimating];
    [self.searchBar setImage:[[[UIImage alloc] init] autorelease] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
}

- (void) stopActivity
{
    [self.activityIndicatorView stopAnimating];
    [self.searchBar setImage:nil forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
}


#pragma mark - UISearchBar delegate

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length > 2) {
        [self startActivity];
        [self.locationManager cancelConnection];
        [self.locationManager search:searchText maxRows:10];
    }
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self startActivity];
    [self.locationManager cancelConnection];
    [self.locationManager search:searchBar.text maxRows:10];
    [searchBar resignFirstResponder];
}

#pragma mark - UITableView delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocationCell"];
    
    MWLocation * item = self.items[indexPath.row];
    
    if ([indexPath isEqual:self.checkedIndexPath])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    cell.textLabel.text = item.cityName;
    cell.detailTextLabel.text = item.regionName;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.doneButton.enabled = YES;
    if (self.checkedIndexPath) {
        UITableViewCell *checkedCell = [tableView cellForRowAtIndexPath:self.checkedIndexPath];
        checkedCell.accessoryType = UITableViewCellAccessoryNone;
    }
    self.checkedIndexPath = indexPath;
    curLocation = self.items[indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - MWLocationManager Delegate

-(void)locationManager:(MWLocationManager *)handler didFinishWithLocations:(NSArray *)locations
{
    [self stopActivity];
    self.items = locations;
    self.checkedIndexPath = nil;
    [self.locationsTableView reloadData];
}

-(void)locationManager:(MWLocationManager *)handler didFinishWithError:(NSError *)error
{
    [UIAlertView showAlertViewWithCustomErrorMessage:error.localizedDescription title:@"Server Error"];
    [self stopActivity];
}

#pragma mark - Actions

- (IBAction)cancelPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)donePressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    if ([self.delegate respondsToSelector:@selector(addLocation:didDisappearWithLocation:)]) {
        [self.delegate addLocation:self didDisappearWithLocation:curLocation];
    }
}

- (void)dismissKeyboard
{
    [self.view endEditing:YES];
}
@end
