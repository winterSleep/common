//
//  NBCollectionViewModel+Private.h
//  Fish
//
//  Created by Li Zhiping on 5/29/15.
//  Copyright (c) 2015 Li Zhiping. All rights reserved.
//

@interface NBCollectionViewModel ()

@property (nonatomic, strong) NSArray* sections; // Array of NITableViewModelSection

- (void)_resetCompiledData;
- (void)_compileDataWithListArray:(NSArray *)listArray;
- (void)_compileDataWithSectionedArray:(NSArray *)sectionedArray;

@end
