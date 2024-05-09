trigger accessFeeds on FeedItem (after insert, after update) {
    if(trigger.isInsert && trigger.isAfter){
        Map<Id,FeedItem> afterInsertAccessFeedsId = new Map<Id,FeedItem>();
        for(FeedItem accFeedRec : trigger.new){
            afterInsertAccessFeedsId.put(accFeedRec.Id,accFeedRec);
        }
        if(afterInsertAccessFeedsId.size() > 0){
            AccessCaseCommentsHandler.feedsInsertHandler(afterInsertAccessFeedsId);
        }
    }
    
    if(trigger.isUpdate && trigger.isAfter){
        Map<Id,FeedItem> afterUpdateAccessFeedsId = new Map<Id,FeedItem>();
        for(FeedItem accFeedRec : trigger.new){
            afterUpdateAccessFeedsId.put(accFeedRec.Id,accFeedRec);
        }
        if(afterUpdateAccessFeedsId.size() > 0){
            AccessCaseCommentsHandler.afterUpdateFeedsHandler(afterUpdateAccessFeedsId);
        }
    }
}