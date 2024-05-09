trigger accessFeedComments on FeedComment (after insert, after update) {
    
    if(trigger.isInsert && trigger.isAfter){
        Map<Id,FeedComment> afterInsertAccessFeedCommentsId = new Map<Id,FeedComment>();
        for(FeedComment accFeedCommentRec : trigger.new){
            afterInsertAccessFeedCommentsId.put(accFeedCommentRec.Id,accFeedCommentRec);
        }
        if(afterInsertAccessFeedCommentsId.size() > 0){
            AccessCaseCommentsHandler.feedCommentsInsertHandler(afterInsertAccessFeedCommentsId);
        }
    }
    
    if(trigger.isUpdate && trigger.isAfter){
        Map<Id,FeedComment> afterUpdateAccessFeedCommentsId = new Map<Id,FeedComment>();
        for(FeedComment accFeedCommentRec : trigger.new){
            afterUpdateAccessFeedCommentsId.put(accFeedCommentRec.Id,accFeedCommentRec);
        }
        if(afterUpdateAccessFeedCommentsId.size() > 0){
            AccessCaseCommentsHandler.feedCommentsUpdateHandler(afterUpdateAccessFeedCommentsId);
        }
    }
}