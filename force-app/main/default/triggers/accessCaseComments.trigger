trigger accessCaseComments on CaseComment (before insert) {
    System.debug('Inside Case Comments *** ');
    /*if(trigger.isInsert){
        Map<Id, CaseComment> mapCaseComments = new Map<Id, CaseComment>(); // Map holds current Inserting CaseComment
        for(CaseComment comment : trigger.new){
            mapCaseComments.put(comment.ParentId,comment);
        }
        if(mapCaseComments.size() > 0){
            AccessCaseCommentsHandler.commentInsertHandler(mapCaseComments);
        }
    }
    
    if(trigger.isUpdate){
        Map<Id, CaseComment> mapCaseCommentsUpdate = new Map<Id, CaseComment>();
        for(CaseComment comment : trigger.new){
            mapCaseCommentsUpdate.put(comment.ParentId,comment);
        }
        if(mapCaseCommentsUpdate.size() > 0){
            AccessCaseCommentsHandler.commentUpdateHandler(mapCaseCommentsUpdate);
        }
    }*/
}