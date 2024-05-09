@isTest
public with sharing class TestDataFactory 
{
    /**
    * @description createAccount Create an Account
    * @return {Account} account
    */
    public static Account createAccount()
    {
        Account acc = new Account(
            Name = 'TestAccount'
        );
        
        insert acc;
        return acc;
    }

    /**
    * @description createDirectionSalesUser Create a new Direction Sales User
    * @return {User}
    */
    public static User createDirectionSalesUser()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Direction & Sales'];
        String key = EncodingUtil.convertToHex(crypto.generateAesKey(128));
        String userEmailPrefix = key.substring(0, 10);

        User u = new User(
            Alias = 'standt', 
            LastName = 'Test',
            FirstName = 'Test',
            Email =  userEmailPrefix+'@ekinops.com',
            EmailEncodingKey = 'UTF-8', 
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US', 
            ProfileId = p.Id,
            TimeZoneSidKey = 'Europe/Paris', 
            UserName = userEmailPrefix+'@ekinops.com'
        );
        insert u;
        return u;
    }

    /**
     * @description createProduct Create and return a Product
     * @return {Product2}
     */
    public static Product2 createProduct()
    {
        Product2 prod = new Product2(
            Name = 'Product X',
            ProductCode = 'Pro-X',
            isActive = true,
            GroupProductHierarchyLabelL1Pick__c = 'H/W Products',
            GroupProductHierarchyLabelL2Pick__c = 'DWDM - Infrastructure',
            GroupProductHierarchyLabelL3Pick__c = 'DWDM OPTICAL ADD/DROP/MUX'
        );
        insert prod;
        return prod;
    }

    /**
     * @description createPricebookEntry description
     * @param {String} pricebookId
     * @param {Product2} prod
     * @return {PricebookEntry}
     */
    public static PricebookEntry createPricebookEntry(String pricebookId, Product2 prod)
    {
        PricebookEntry pbEntry = new PricebookEntry(
            Pricebook2Id = pricebookId,
            Product2Id = prod.Id,
            UnitPrice = 100.00,
            IsActive = true,
            CurrencyIsoCode = 'EUR'
        );
        insert pbEntry;
        return pbEntry;
    }

    /**
     * @description createOpportunity Create and Return an Opportunity
     * @param {String} userId
     * @return {Opportunity}
     */
    public static Opportunity createOpportunity(String userId) 
    {
        return createOpportunity([SELECT Id FROM User WHERE Id = :userId]);
    }

    /**
     * @description createOpportunity Create and Return an Opportunity
     * @param {User} user
     * @return {Opportunity}
     */
    public static Opportunity createOpportunity(User user) 
    {
        return createOpportunity(user, [SELECT Id FROM Account LIMIT 1], 'Proposal');
    }

    /**
     * @description createOpportunity Create and Return an Opportunity
     * @param {User} user
     * @param {Account} acc
     * @param {String} stageName
     * @return {Opportunity}
     */
    public static Opportunity createOpportunity(User user, Account acc, String stageName) 
    {
        Opportunity opp = new Opportunity(
            PLM_Ref__c = user?.Id,
            Name = 'Test',
            StageName = stageName,
            CloseDate = Date.today(),
            AccountId = acc?.Id,
            CurrencyIsoCode = 'EUR',
            TechnicalAccountManagerRef__c = user?.Id
        );

        insert opp;
        return opp;
    }

    /**
     * @description createOpportunityLineItem Create an Opportunity Line Item
     * @param {Opportunity} opp
     * @param {PricebookEntry} pbEntry
     * @param {Integer} qty 
     * @return {OpportunityLineItem}
     */ 
    public static OpportunityLineItem createOpportunityLineItem(Opportunity opp, PricebookEntry pbEntry, Integer qty)
    {
        OpportunityLineItem oli = new OpportunityLineItem(
            OpportunityId = opp.Id,
            Quantity = qty,
            PricebookEntryId = pbEntry.Id,
            UnitPrice = qty * pbEntry.UnitPrice,
            Product2Id = pbEntry.Product2Id
        );
        insert oli;
        return oli;
    }

    /**
     * @description createRequest Create and Return a Request
     * @param {Opportunity} opp
     * @return {Request__c}
     */
    public static Request__c createRequest(Opportunity opp) 
    {
        Request__c req = new Request__c(
            OpportunityRef__c = opp.Id,
            Type__c = 'Quote'
        );

        insert req;
        return req;
    }

    /**
     * @description createOrderIntake Create an Order Intake (SalesAgreement)
     * @param {Opportunity} opp
     * @param {PricebookEntry} pbEntry
     * @return {SalesAgreement}
     */
    public static SalesAgreement createOrderIntake(Opportunity opp, PricebookEntry pbEntry)
    {
        SalesAgreement sa = new SalesAgreement(
            Name = 'Test Order Intake',
            AccountId = opp?.AccountId,
            Opportunity__c = opp?.Id,
            StartDate = Date.today(),
            PricebookId = pbEntry?.Pricebook2Id,
            ProductLevel = 'Product',
            CurrencyIsoCode = pbEntry?.CurrencyIsoCode,
            ScheduleCount = 4,
            ScheduleFrequency = 'Monthly',
            BypassOrderIntakeProductCreation__c = true
        );

        insert sa;
        return sa;
    }

    /**
     * @description createOrderIntakeProduct Create an Order Intake Product (SalesAgreementProduct)
     * @param {SalesAgreement} sa
     * @param {Product2} prod
     * @param {OpportunityLineItem} oli
     * @return {SalesAgreementProduct}
     */
    public static SalesAgreementProduct createOrderIntakeProduct(SalesAgreement sa, Product2 prod, OpportunityLineItem oli)
    {
        SalesAgreementProduct sap = new SalesAgreementProduct(
            SalesAgreementId = sa.Id,
            CurrencyIsoCode = 'EUR',
            InitialPlannedQuantity = oli.Quantity != null ? oli.Quantity.intValue() : null,
            Name = prod.Name,
            Opportunity_Product__c = oli.Id,
            Opportunity__c = oli.OpportunityId,
            PricebookEntryId = oli.PricebookEntryId,
            SalesPrice = oli.UnitPrice
        );
        insert sap;
        return sap;
    }
}