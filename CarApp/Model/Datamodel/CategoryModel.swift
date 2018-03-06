//
//  CategoryModel.swift
//  HashTagApp
//
//  Created by GLB-312-PC on 10/01/18.
//  Copyright © 2018 GLB-312-PC. All rights reserved.
//

import UIKit

struct Response: Decodable {
    
    let status: Int?
    let message: String?
    let banner_ios: [bannerADdetails]?
    let data: [Category]?
}

struct Category: Decodable {

    let category_id: Int?
    let category_name: String?
    let category_icon: String?
    let subcat_details: [SubCategory]?
    let keyphrasesDetails:[keyphrasesDetails]?
    
}

struct SubCategory: Decodable {
    
    let subcat_id: Int?
    let subcategory_name: String?
    let subcategory_icon: String?
    let hashtags_en: [hashtagsEnglishDetails]?
    let hashtags_ru: [hashtagsRussianDetails]?
    let hashtag_all : [hashtagsAllDetails]?
    let hasSubSubcatDetails: Bool?
    let sub_subcat_details:[SubCategoryDetails]?
}


struct SubCategoryDetails: Decodable {
    
    let subcat_id: Int?
    let sub_subcat_name: String?
    let sub_subcat_icon: String?
    let hashtags_en: [hashtagsEnglishDetails]?
    let hashtags_ru: [hashtagsRussianDetails]?
    let hashtag_all : [hashtagsAllDetails]?
}

struct hashtagsEnglishDetails: Codable {
    
    let hashtagName: String?
    let postCount: Int?
    let hashtagId: String?
    
}

struct hashtagsRussianDetails: Codable {
    
    let hashtagName: String?
    let postCount: Int?
    let hashtagId: String?
}
struct hashtagsAllDetails: Codable {
    
    let hashtagName: String?
    let postCount: Int?
    let hashtagId: String?
}

struct  bannerADdetails : Codable {
    let banner_url: String?
    let banner_img: String?
}

struct keyphrasesDetails : Codable {
    let keyphraseId : Int?
    let keyphraseName : String?
    let keyphraseIcon : String?
    let  keyphrasesArr : [keyphrasesArray]?
}

struct keyphrasesArray : Codable {
    let keyphraseId  : String?
    let keyphrases : String?
}
