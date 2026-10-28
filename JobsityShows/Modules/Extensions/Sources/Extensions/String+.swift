//
//  String+.swift
//  JobsityShows
//
//  Created by Joan Wilson Oliveira on 17/04/25.
//

import Foundation

public extension String {
    func removingHTMLTags() -> String {
        return self.replacingOccurrences(
            of: "<[^>]+>",
            with: "",
            options: .regularExpression
        )
    }

    func usingHTTPS() -> String {
        guard hasPrefix("http://") else { return self }
        return "https://" + dropFirst("http://".count)
    }
}
