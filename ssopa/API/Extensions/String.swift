//
//  String.swift
//  ssopa
//
//  Created by Jiho Seo on 2023/04/20.
//

import Foundation


extension String
{
    func encodeUrl() -> String?
    {
        return self.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
    }
    func decodeUrl() -> String?
    {
        return self.removingPercentEncoding
    }
}
