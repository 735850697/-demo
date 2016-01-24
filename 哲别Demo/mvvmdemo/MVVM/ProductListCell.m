//
//  ProductListCell.m
//  MVVM
//
//  Created by develop on 15/9/18.
//  Copyright (c) 2015年 songhailiang. All rights reserved.
//

#import "ProductListCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ProductListCell ()

@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productClassLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *profitLabel;
@property (weak, nonatomic) IBOutlet UILabel *productTermLabel;
@property (weak, nonatomic) IBOutlet UILabel *productAmtLabel;

@end

@implementation ProductListCell

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    //数据绑定，相互影响
    if (self) {
        @weakify(self);
        [RACObserve(self, viewModel) subscribeNext:^(id x) {
            
            @strongify(self);
            self.productNameLabel.text = self.viewModel.ProductName;
            self.bankNameLabel.text = self.viewModel.ProductBank;
            self.profitLabel.text = self.viewModel.ProductProfit;
            self.saleStatusLabel.text = self.viewModel.SaleStatusCn;
            self.productTermLabel.text = self.viewModel.ProductTerm;
            self.productAmtLabel.text = self.viewModel.ProductAmt;
            
        }];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
