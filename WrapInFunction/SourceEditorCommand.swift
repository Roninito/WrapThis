//
//  SourceEditorCommand.swift
//  WrapInFunction
//
//  Created by Leerie Simpson on 10/31/16.
//  Copyright © 2016 Leerie Simpson. All rights reserved.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        
        guard let selection = invocation.buffer.selections.firstObject as? XCSourceTextRange else {
            completionHandler(NSError(domain: "Extension", code: 0, userInfo: nil ))
            return
        }
        
        // prepare the prefix and postfix
        let functionPrefix = "func <#name#> (<#params#>) -> <#returnedType#> {\n"
        let functionPostfix = "}"
        
        // insert them
        invocation.buffer.lines.insert(functionPrefix, at: selection.start.line)
        invocation.buffer.lines.insert(functionPostfix, at: selection.end.line + 1)
        
        // find the new selection after the insertion by moving up a line and out a couple column spaces on the end.
        var newEndPosition = selection.end
        var newStartPosition = selection.start
        newStartPosition.line -= 1
        newStartPosition.column = 0
        newEndPosition.column += 2
        
        // use those enw XCSourceTextPosition's to generate a new text range.
        let newSelectionXCSTR = XCSourceTextRange(start: newStartPosition, end: newEndPosition)

        // clear the selections and add our new selection
        invocation.buffer.selections.removeAllObjects()
        invocation.buffer.selections.add(newSelectionXCSTR)
        
        completionHandler(nil)
    }
    
}
