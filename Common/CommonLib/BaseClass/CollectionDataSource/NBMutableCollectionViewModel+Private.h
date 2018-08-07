//
//  NBMutableCollectionViewModel(Private).h
//  Fish
//
//  Created by Li Zhiping on 5/29/15.
//  Copyright (c) 2015 Li Zhiping. All rights reserved.
//

@interface NBMutableCollectionViewModel (Private)

@property (nonatomic, strong) NSMutableArray* sections; // Array of NBCollectionViewModelSection
@property (nonatomic, strong) NSMutableArray* sectionIndexTitles;
@property (nonatomic, strong) NSMutableDictionary* sectionPrefixToSectionIndex;

@end

@interface NBCollectionViewModelSection (Mutable)

- (NSMutableArray *)mutableRows;

@end
