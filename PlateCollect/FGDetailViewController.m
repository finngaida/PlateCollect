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
@synthesize deportationInfos = _deportationInfos;
@synthesize dayOfDeath = _dayOfDeath;
@synthesize deathPlace = _deathPlace;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Design auf die View Elemente anwenden
    NSMutableAttributedString* nameString = self.nameLabel.attributedText.mutableCopy;
    NSArray *words = [self.nameLabel.text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    int nameEndIndex = [[words objectAtIndex:0] length] - 1;
    NSRange namePosition = NSMakeRange(0, nameEndIndex);
    
    NSString *boldFontName = [[UIFont boldSystemFontOfSize:12] fontName];

    [nameString beginEditing];
    [nameString addAttribute:NSFontAttributeName
                       value:boldFontName
                       range:namePosition];
    [nameString endEditing];
    self.nameLabel.attributedText = nameString;
    
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
        int count = _deportationInfos.count;
        if (_deathPlace && _dayOfDeath) {
            count++;
        }
        return count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Statische Zellen werden automatisch gesetzt
    if (indexPath.section == 0) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    } else {
        //ImageView für das TimeLineBild
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView setFrame:CGRectMake(0, 0, 44, 44)];
        
        //Dynamische Zelllen sind die für Deportationen etc.
        static NSString *CellIdentifier = @"specialCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                                forIndexPath:indexPath];
        if (indexPath.row < _deportationInfos.count) {
            //Bild für die Timeline setzen
            UIImage *image = [UIImage imageNamed:@"timline_deporatation.png"];
            [imageView setImage:image];
            
            //Text für Deporatationen
            cell.textLabel.text = [NSString stringWithFormat:@"%i. Deport.", indexPath.row];
            
            NSDictionary *dict = [_deportationInfos objectAtIndex:indexPath.row];
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
            if (_dayOfDeath && _deathPlace) {
                NSString *detailText;
                if (_deathPlace) {
                    detailText = _deathPlace;
                    if (_dayOfDeath) {
                        NSString *dayOfDeathFormatted = [NSString stringWithFormat:@" (%@)", _dayOfDeath];
                        detailText = [detailText stringByAppendingString:dayOfDeathFormatted];
                    }
                } else {
                    detailText = _dayOfDeath;
                }
                
            } else {
                cell.detailTextLabel.text = @"Keine Angaben";
            }
        }

        return cell;
    }
}
@end
