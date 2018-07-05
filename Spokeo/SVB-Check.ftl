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
Payee Address 3|<#rt>
Payee Address City|<#rt>
Payee Address State|<#rt>
Payee Address Zip|<#rt>
Payee Address Country|<#rt>
Mail Code|<#rt>
Handling Code|<#rt>
Memo<#rt>
${"\r\n"}<#--Line Break-->
<#-- Check Information -->
<#assign totalPayments = 0>
<#assign recordCount = 0>
<#assign entryHash = 0>
<#list payments as payment>
    <#assign ebank = ebanks[payment_index]>
    <#assign entity = entities[payment_index]>
    <#assign payAmount = formatAmount(getAmount(payment))>
    <#assign paidTransactions = transHash[payment.internalid]>
<#--P01-->${setMaxLength(pfa.custrecord_2663_process_date?string("yyMMdd"),10)}|<#rt><#--Check Date-->
<#--P02-->${setMaxLength(payment.tranid,10)}|<#rt><#--Check Number-->
<#--P03-->${setMaxLength(payAmount, 14)}|<#rt><#--Check Amount-->
<#--P04-->${setMaxLength(buildEntityName(entity),60)}|<#rt><#--Payee Name-->
<#--P05-->${setMaxLength(entity.entityid, 20)}|<#rt><#--Payee ID-->
<#--P06-->${setMaxLength(entity.billaddr1, 40)}|<#rt><#--Payee Address 1-->
<#--P07-->${setMaxLength(entity.billaddr2, 40)}|<#rt><#--Payee Address 2-->
<#--P08-->${setMaxLength(entity.billaddr3, 40)}|<#rt><#--Payee Address 3-->
<#--P09-->${setMaxLength(entity.billcity, 15)}|<#rt><#--Payee City-->
<#--P10-->${setMaxLength(entity.billstate, 15)}|<#rt><#--Payee State-->
<#--P11-->${setMaxLength(entity.billzip, 10)}|<#rt><#--Payee Zip-->
<#--P12-->${setMaxLength(entity.billcountry, 20)}|<#rt><#--Payee Country-->
<#--P13-->0|<#rt><#--Mail Code-->
<#--P14-->1|<#rt><#--Handling Code-->
<#--P15-->${setMaxLength(payment.memo, 40)}|<#rt><#--Memo-->
${"\r\n"}<#--Line Break-->
</#list>
#OUTPUT END#
