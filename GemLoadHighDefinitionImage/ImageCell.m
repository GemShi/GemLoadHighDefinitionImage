//
//  ImageCell.m
//  GemLoadHighDefinitionImage
//
//  Created by GemShi on 2017/3/10.
//  Copyright © 2017年 GemShi. All rights reserved.
//

#import "ImageCell.h"
#define k_WIDTH [UIScreen mainScreen].bounds.size.width
#define k_HEIGHT [UIScreen mainScreen].bounds.size.height

@implementation ImageCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)createUI
{
    self.imgView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, k_WIDTH / 3, 100)];
    [self.contentView addSubview:_imgView1];
    
    self.imgView2 = [[UIImageView alloc]initWithFrame:CGRectMake(k_WIDTH / 3, 0, k_WIDTH / 3, 100)];
    [self.contentView addSubview:_imgView2];
    
    self.imgView3 = [[UIImageView alloc]initWithFrame:CGRectMake((k_WIDTH / 3) * 2, 0, k_WIDTH / 3, 100)];
    [self.contentView addSubview:_imgView3];
}

@end
