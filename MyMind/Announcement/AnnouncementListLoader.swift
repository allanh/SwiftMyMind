//
//  AnnouncementListLoader.swift
//  MyMind
//
//  Created by Chijung Chan on 2021/8/20.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import PromiseKit

protocol AnnouncementListLoader {
    func loadAnnouncementList(with announcementListQueryInfo: AnnouncementListQueryInfo?) -> Promise<AnnouncementList>
}
