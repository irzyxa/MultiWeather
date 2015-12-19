//
//  MWSettingsViewController.m
//  MultiWeather
//
//  Created by AIrza on 17/06/14.
//  Copyright (c) 2014 AIrza Inc. All rights reserved.
//

#import "MWSettingsViewController.h"
#import "MWSettings.h"
#import "MWManager.h"

const int defaultLocationGroupIndex = 0;
const int weatherServicesGroupIndex = 1;
const int temperatureUnitsGroupIndex = 2;

@interface MWSettingsViewController ()

@property (nonatomic, retain) MWLocation *defaultLocation;
@property (nonatomic, retain) NSMutableArray *weatherServices;
@property (nonatomic, assign) TemperatureUnits defaultTemperatureUnit;

@end

@implementation MWSettingsViewController


#pragma mark - Life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];

    UINib *nibWeatherServicesCell = [UINib nibWithNibName:@"MWWeatherServiceCell" bundle:nil];
    [self.tableView registerNib:nibWeatherServicesCell forCellReuseIdentifier:@"WeatherServiceCell"];

    UINib *nibTemperatureUnitsCell = [UINib nibWithNibName:@"MWTemperatureUnitsCell" bundle:nil];
    [self.tableView registerNib:nibTemperatureUnitsCell forCellReuseIdentifier:@"MWTemperatureUnitsCell"];
    
    self.tableView.editing = YES;
    [self loadParameters];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_weatherServices release];
    [_defaultLocation release];
    [super dealloc];
}

#pragma mark - Segues

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"DefaultLocationSegue"]) {
        UINavigationController *addLocationNC = segue.destinationViewController;
        MWAddLocationViewController *addLocationVC = addLocationNC.viewControllers[0];
        addLocationVC.delegate = self;
    }
}

#pragma mark - TableView Delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == defaultLocationGroupIndex) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultLocationCell"];
        if (!cell) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"DefaultLocationCell"] autorelease];
        }
        cell.textLabel.text = self.defaultLocation.cityName;
        cell.detailTextLabel.text = self.defaultLocation.regionName;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    } else if (indexPath.section == weatherServicesGroupIndex) {
        MWWeatherServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeatherServiceCell"];
        cell.delegate = self;
        cell.logoImageView.image = [UIImage imageNamed:self.weatherServices[indexPath.row][MW_SERVICE_LOGO]];
        cell.nameLabel.text = self.weatherServices[indexPath.row][MW_SERVICE_NAME];
        cell.useSwitch.on = [self.weatherServices[indexPath.row][MW_SERVICE_USE] boolValue];
        return cell;
    } else {
        MWTemperatureUnitsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MWTemperatureUnitsCell"];
        cell.delegate = self;
        cell.defaultTemperatureUnitSegControl.selectedSegmentIndex = self.defaultTemperatureUnit;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == defaultLocationGroupIndex && indexPath.row == 0) {
        [self performSegueWithIdentifier:@"DefaultLocationSegue" sender:nil];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == defaultLocationGroupIndex) {
        return 1;
    } else if (section == weatherServicesGroupIndex) {
        return self.weatherServices.count;
    } else {
        return 1;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == defaultLocationGroupIndex && indexPath.row == 0)
        return YES;
    else
        return NO;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == weatherServicesGroupIndex)
        return YES;
    else
        return NO;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == weatherServicesGroupIndex)
        return YES;
    else
        return NO;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    if (sourceIndexPath.row < self.weatherServices.count &&
        destinationIndexPath.row < self.weatherServices.count) {

        NSDictionary *item = [self.weatherServices[sourceIndexPath.row] retain];
        [self.weatherServices removeObjectAtIndex:sourceIndexPath.row];
        [self.weatherServices insertObject:[item autorelease] atIndex:destinationIndexPath.row];
        [self.tableView reloadData];
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

-(BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

-(NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if (sourceIndexPath.section != proposedDestinationIndexPath.section) {
        return [NSIndexPath indexPathForRow:0 inSection:sourceIndexPath.section];
    }
    return proposedDestinationIndexPath;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == defaultLocationGroupIndex) {
        return @"Default Location";
    } else if (section == weatherServicesGroupIndex) {
        return @"Weather Services";
    } else if (section == temperatureUnitsGroupIndex) {
        return @"Temperature Units";
    } else
        return nil;
}

#pragma mark - AddLocation Delegate

-(void)addLocation:(MWAddLocationViewController *)sender didDisappearWithLocation:(MWLocation *)location
{
    self.defaultLocation = location;
    [self.tableView reloadData];
}

#pragma mark - Actions

- (IBAction)camcelPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)savePressed:(id)sender {
    [self saveParameters];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Advanced methods

-(void)loadParameters
{
    self.defaultLocation = [MWSettings getDefaultLocation];
    self.weatherServices = [MWSettings getWeatherServices];
    self.defaultTemperatureUnit = [MWSettings getDefaultTemperatureUnit];
    [self.tableView reloadData];
}

-(void)saveParameters
{
    [MWSettings setDefaultLocation:self.defaultLocation];
    [MWSettings setWeatherServices:self.weatherServices];
    [MWSettings setDefaultTemperatureUnit:self.defaultTemperatureUnit];
    [MWManager sharedManager].defaultLocation = self.defaultLocation;
}

#pragma mark - MWWeatherServiceDelegate

-(void)weatherServiceCell:(MWWeatherServiceCell *)cell useSwitchDidChangeStatusTo:(BOOL)status
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath) {
        [self.weatherServices[indexPath.row] setObject:[NSNumber numberWithBool:status] forKey:@"ServiceUse"];
        [self.tableView reloadData];
    }
}

#pragma mark - MWTemperatureUnitsDelegate

-(void)temperatureUnitsCell:(MWTemperatureUnitsCell *)cell defaultTemperatureUnitChangedTo:(TemperatureUnits)defaultUnit
{
    self.defaultTemperatureUnit = defaultUnit;
    [self.tableView reloadData];
}

@end
