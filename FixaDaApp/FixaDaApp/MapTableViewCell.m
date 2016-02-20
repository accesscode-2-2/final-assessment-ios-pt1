//
//  MapTableViewCell.m
//  FixaDaApp
//
//  Created by Diana Elezaj on 2/20/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

#import "MapTableViewCell.h"

@implementation MapTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (IBAction)phoneNumberClicked:(UIButton *)sender {
    NSString *cleanedString = [[self.phoneNumber.titleLabel.text componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", cleanedString]];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
