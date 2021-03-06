<#--Author: Michael Wang | mwang@netsuite.com-->
<#--SVB tAG Check Print-->

<#function getReferenceNote payment>
        <#assign paidTransactions = transHash[payment.internalid]>
        <#assign referenceNote = "">
        <#assign paidTransactionsCount = paidTransactions?size>
        <#if (paidTransactionsCount >= 1)>
            <#list paidTransactions as transaction>
                <#if transaction.tranid?has_content>
                    <#if referenceNote?has_content>
                        <#assign referenceNote = referenceNote + ", " + transaction.tranid>
                    <#else>
                        <#assign referenceNote = transaction.tranid>
                    </#if>
                </#if>
            </#list>
        </#if>
        <#return referenceNote>
    </#function>
    
<#function buildEntityBillingAddress entity>
<#assign address = "">
<#if entity.billaddress1?has_content >
<#assign address = entity.billaddress1 >
<#elseif entity.shipaddress1?has_content >
<#assign address = entity.shipaddress1 >
<#elseif entity.address1?has_content >
<#assign address = entity.address1 >
</#if>
<#return address>
</#function>

<#function getReferenceNote payment>
<#assign paidTransactions = transHash[payment.internalid]>
<#assign referenceNote = "">
<#assign paidTransactionsCount = paidTransactions?size>
<#if (paidTransactionsCount >= 1)>
<#list paidTransactions as transaction>
<#if transaction.tranid?has_content>
<#if referenceNote?has_content>
<#assign referenceNote = referenceNote + ", " + transaction.tranid>
<#else>
<#assign referenceNote = transaction.tranid>
</#if>
</#if>
</#list>
</#if>
<#return referenceNote>
</#function>

<#-- cached values -->
<#assign totalAmount = formatAmount(computeTotalAmount(payments))>
<#-- template building -->
#OUTPUT START#
<#-- Check Print Headers -->
Check Date|<#rt>
Check Number|<#rt>
Check Amount|<#rt>
Payee/Vendor Name|<#rt>
Payee/Vendor Number|<#rt>
Payee Address 1|<#rt>
Payee Address 2|<#rt>
Payee Address City|<#rt>
Payee Address State|<#rt>
Payee Address Zip|<#rt>
Payee Address Country|<#rt>
Mail Code|<#rt>
Handling Code|<#rt>
Memo|<#rt>
Invoice Number|<#rt>
Invoice Date|<#rt>
Invoice Description|<#rt>
Invoice Net Amount<#rt>
${"\r\n"}<#rt><#--Line Break-->
<#-- Calculate Total Original Bill Amount -->
<#list payments as payment>
    <#assign ebank = ebanks[payment_index]>
    <#assign entity = entities[payment_index]>
    <#assign TotalOrigAmount = 0>
    <#assign paidTransactions = transHash[payment.internalid]>
    <#list paidTransactions as transaction>
        <#assign TotalOrigAmount = TotalOrigAmount + transaction.total>
    </#list>
</#list>
<#-- Check Information -->
<#list payments as payment>
    <#assign ebank = ebanks[payment_index]>
    <#assign entity = entities[payment_index]>
    <#assign billcount = 0>
    <#assign payAmount = getAmount(payment)>
    <#assign TotalCredits = TotalOrigAmount - payAmount>
    <#assign paidTransactions = transHash[payment.internalid]>
    <#list paidTransactions as transaction>
    <#assign billcount = billcount + 1>
<#--P01-->${setMaxLength(pfa.custrecord_2663_process_date?string("MMddyyyy"),10)}|<#rt><#--Check Date-->
<#--P02-->${setMaxLength(payment.tranid,15)}|<#rt><#--Check Number-->
<#--P03-->${setMaxLength(formatAmount(getAmount(payment),"dec"), 14)}|<#rt><#--Check Amount-->
<#--P04-->${setMaxLength(buildEntityName(entity),60)}|<#rt><#--Payee Name-->
<#--P05-->${setMaxLength(payment.entity, 20)}|<#rt><#--Payee ID-->
<#--P06-->${setMaxLength(entity.billaddress1, 40)}|<#rt><#--Payee Address 1-->
<#--P07-->${setMaxLength(entity.billaddress2, 40)}|<#rt><#--Payee Address 2-->
<#--P08-->${setMaxLength(entity.billcity, 15)}|<#rt><#--Payee City-->
<#--P09-->${setMaxLength(entity.billstate, 15)}|<#rt><#--Payee State-->
<#--P10-->${setMaxLength(entity.billzipcode, 10)}|<#rt><#--Payee Zip-->
<#--P11-->${setMaxLength(entity.billcountry, 20)}|<#rt><#--Payee Country-->
<#--P12-->0|<#rt><#--Mail Code-->
<#--P13-->1|<#rt><#--Handling Code-->
<#--P14-->${setMaxLength(payment.memo, 50)}|<#rt><#--Memo-->
<#--P15-->${setMaxLength(transaction.tranid, 20)}|<#rt><#--Invoice Number (20)-->
<#--P16-->${setMaxLength(transaction.trandate?string("MMddyyyy"), 10)}|<#rt><#--Invoice Date-->
<#--P17-->${setMaxLength(transaction.memo, 20)}|<#rt><#--Invoice Description (20)-->
<#--P18-->${setMaxLength(formatAmount(transaction.amount,"dec"), 14)}<#rt><#--Invoice Discount Amount-->
<#--P19-->${setMaxLength(formatAmount(transaction.amount,"dec"), 14)}<#rt><#--Invoice Gross Amount-->
<#--P20-->${setMaxLength(formatAmount(transaction.amount,"dec"), 14)}<#rt><#--Invoice Net Amount-->
${"\r\n"}<#rt><#--Line Break-->
   </#list>
</#list>
#OUTPUT END#
