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

    <#function computeTotalRecords recordCount>
        <#assign value = ((recordCount + 4) / 10) >
        <#assign value = value?ceiling >    
        <#return value>
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
Payee|<#rt>
Payee Address 1|<#rt>
Payee Address 2|<#rt>
Payee Address 3|<#rt>
Payee City|<#rt>
Payee State|<#rt>
Payee Zip|<#rt>
Payee Country|<#rt>
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
    <#assign totalPayments = totalPayments + 1>
    <#assign recordCount = recordCount + 2>
    <#assign traceNumber = cbank.custpage_eft_custrecord_2663_bank_num?string?substring(0, 8) + setPadding(recordCount,"left","0",7)?string>
    <#assign paidTransactions = transHash[payment.internalid]>
    <#--Entry Hash Calculation sum(P5 to P11)-->
    <#assign P5 = ebank.custrecord_2663_entity_acct_no>
    <#assign p6 = payAmount>
    <#assign p7 = ebank.custrecord_2663_entity_bank_code>
    <#assign p10 = 0>
    <#assign P11 = traceNumber?number>
    <#assign entryHash = entryHash + P5 + P6 + P7 + P10 + P11>
    <#--Entry Hash Calculation End-->
<#--P01-->${setMaxLength(pfa.custrecord_2663_process_date?string("yyMMdd"),10)}<#rt><#--Check Date-->
<#--P02-->${setMaxLength(pfa.custrecord_2663_process_date?string("yyMMdd"),10)}<#rt><#--Check Number-->
<#--P03-->${ebank.custrecord_2663_entity_bank_no?string?substring(8)}<#rt><#--Check Amount-->
<#--P04-->${setMaxLength(buildEntityName(entity),"right"," ",22)}<#rt><#--Payee Name-->
<#--P05-->${setMaxLength(ebank.custrecord_2663_entity_acct_no,"right"," ",17)}<#rt><#--Payee ID-->
<#--P06-->${setMaxLength(entity.billaddress1, 40)}<#rt><#--Payee Address 1-->
<#--P07-->${setMaxLength(entity.billaddress1, 40)}<#rt><#--Payee Address 2-->
<#--P08-->${setMaxLength(entity.billaddress1, 40)}<#rt><#--Payee Address 3-->
<#--P09-->${setMaxLength(entity.billcity, 15)}<#rt><#--Payee City-->
<#--P10-->${setMaxLength(entity.billstate, 15)}<#rt><#--Payee State-->
<#--P11-->${setMaxLength(entity.billzip, 10)}<#rt><#--Payee Zip-->
<#--P12-->${setMaxLength(entity.billcountry, 20)}<#rt><#--Payee Country-->
<#--P13-->0<#rt><#--Mail Code-->
<#--P14-->1<#rt><#--Handling Code-->
${"\r\n"}<#--Line Break-->
</#list>




<#--- Batch Control Record (8) --->
<#--P01-->8<#rt><#--Record Type Code (8)-->
<#--P02-->220<#rt><#--Service Class Code-->
<#--P03-->${recordCount}<#rt><#--Entry/Addenda Count-->
<#--P04-->${entryHash}<#rt><#--Entry Hash-->
<#--P05-->000000000000<#rt><#--Total Debit Entry Dollar Amount-->
<#--P06-->${setPadding(totalAmount,"left","0",12)}<#rt><#--Total Credit Entry Dollar Amount-->
<#--P07-->${cbank.custpage_eft_custrecord_2663_bank_comp_id}<#rt><#--Company Identification-->
<#--P08-->${setLength(" ",19)}<#rt><#--Message Authentication Code Leave Blank (19)-->
<#--P09-->${setLength(" ",6)}<#rt><#--Reserved Leave Blank (6)-->
<#--P10-->${cbank.custpage_eft_custrecord_2663_bank_num?string?substring(0, 8)}<#rt><#--Originating Financial Institution, Chase Routing Number 8 digits without check digit-->
<#--P11-->${setPadding(pfa.id,"left","0",7)}<#rt><#--Batch Number-->
${"\r\n"}<#--Line Break-->
<#--- File Control Record (9) --->
<#--Entry Hash Value sum of P4 to P11-->
<#--P01-->9<#rt><#--Record Type Code (9)-->
<#--P02-->1<#rt><#--Batch Count-->
<#--P03-->${setPadding(computeTotalRecords(recordCount),"left","0",6)}<#rt><#--Block Count-->
<#--P04-->${setPadding(recordCount,"left","0",8)}<#rt><#--Entry/Addenda Count-->
<#--P05-->${setPadding(entryHash,"left","0",10)}<#rt><#--Entry Hash-->
<#--P06-->000000000000<#rt><#--Total Debit Entry Dollar Amount in File-->
<#--P07-->${setPadding(totalAmount,"left","0",12)}<#rt><#--Total Credit Entry Dollar Amount in File-->
<#--P08-->${setLength(" ",39)}<#rt><#--Leave Blank (39)-->
#OUTPUT END#
