trigger AmountOpportunityHandler on Opportunity (after insert, after update, before delete) {

    if (Trigger.isAfter && Trigger.isInsert) {
        OpportunityCrudForAccount.OpportunityCreate(Trigger.new);
    }

    if (Trigger.isAfter && Trigger.isUpdate) {
        OpportunityCrudForAccount.OpportunityUpdate(Trigger.old,Trigger.new);
    }

    if (Trigger.isBefore && Trigger.isDelete) {
        OpportunityCrudForAccount.OpportunityDetele(Trigger.old);
    }
}