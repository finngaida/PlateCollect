//
//  FGDetailViewController.m
//  PlateCollect
//
//  Created by Niklas Riekenbrauck on 07.09.13.
//  Copyright (c) 2013 Finn Gaida. All rights reserved.
//

#import "FGDetailViewController.h"

@interface FGDetailViewController ()

@end

@implementation FGDetailViewController
@synthesize stone = _stone;


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidLoad];
    [self createNameView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SpecialCell"];
    self.tableView.tableFooterView = [UIView new];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor darkGrayColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont fontWithName:@"Helvetica" size:20];
    title.text = @"Details";
    [self.navigationController.navigationBar addSubview:title];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    backButton.frame = CGRectMake(3, 0, 80, 40);
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:backButton.frame];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.text = @"Back";
    [backButton addSubview:titleLabel];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:backButton];
    
}

- (void)goBack {                                // TODODODODODODODOD

}

-(void)createNameView {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 44)];
    label.textColor = [UIColor blackColor];
    
    //Design des Textes
    NSMutableAttributedString* nameString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", _stone.lastName, _stone.firstName]];
    int nameEndIndex = [_stone.lastName length] - 1;
    NSRange namePosition = NSMakeRange(0, nameEndIndex);
    
    
    NSString *boldFontName = [[UIFont boldSystemFontOfSize:12] fontName];
    
    [nameString beginEditing];
    [nameString addAttribute:NSFontAttributeName
                       value:boldFontName
                       range:namePosition];
    [nameString endEditing];
    
    [label setAttributedText:nameString];
    label.textAlignment = NSTextAlignmentCenter;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [headerView addSubview:label];

    [self.tableView insertSubview:headerView atIndex:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 4;
    } else {
        int count = _stone.deportations.count;
        if (_stone.placeOfDeath && _stone.dayOfDeath) {
            count++;
        }
        return count;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Allgemein";
    } else {
        return @"Daten";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Dynamische Zelllen sind die für Deportationen etc.
    static NSString *CellIdentifier = @"SpecialCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //Statische Zellen werden automatisch gesetzt
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: {
                cell.textLabel.text = @"Geburtsname";
                cell.detailTextLabel.text = _stone.bornName;
                break;
            }
            case 1: {
                cell.textLabel.text = @"Geburstag";
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"dd.MM.YY"];
                cell.detailTextLabel.text = [formatter stringFromDate:_stone.birthday];
                break;
            }
            case 2: {
                cell.textLabel.text = @"Adresse";
                cell.detailTextLabel.text = _stone.address;
                break;
            }
            case 3: {
                cell.textLabel.text = @"Ortsteil";
                cell.detailTextLabel.text = _stone.quarter;
                break;
            }
                
            default:
                break;
        }
    } else {
        //ImageView für das TimeLineBild
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView setFrame:CGRectMake(0, 0, 44, 44)];
        [cell.backgroundView addSubview:imageView];
        
        if (indexPath.row < _stone.deportations.count) {
            //Bild für die Timeline setzen
            UIImage *image = [UIImage imageNamed:@"timline_deporatation.png"];
            [imageView setImage:image];
            
            //Text für Deporatationen
            cell.textLabel.text = [NSString stringWithFormat:@"%i. Deport.", indexPath.row];
            
            NSDictionary *dict = [_stone.deportations objectAtIndex:indexPath.row];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"dd.MM.YY"];
            NSString *date = [formatter stringFromDate:dict[@"date"]];
            NSString *detailTextLabel = [NSString stringWithFormat:@"%@ (%@)",dict[@"place"], date];
            cell.detailTextLabel.text = detailTextLabel;
        } else {
            UIImage *image = [UIImage imageNamed:@"timline_death.png"];
            [imageView setImage:image];
            
            //Text für Tod setzen
            cell.textLabel.text = @"Tod";
            if (_stone.dayOfDeath && _stone.placeOfDeath) {
                NSString *detailText;
                if (_stone.placeOfDeath) {
                    detailText = _stone.placeOfDeath;
                    if (_stone.dayOfDeath) {
                        NSString *dayOfDeathFormatted = [NSString stringWithFormat:@" (%@)", _stone.dayOfDeath];
                        detailText = [detailText stringByAppendingString:dayOfDeathFormatted];
                    }
                } else {
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"dd.MM.YY"];
                    detailText = [formatter stringFromDate:_stone.dayOfDeath];
                }
                
            } else {
                cell.detailTextLabel.text = @"Keine Angaben";
            }
        }

    }
    return cell;

}
@end
