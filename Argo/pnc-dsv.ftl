<#-- Author: Michael Wang | mwang@netsuite.com -->
<#-- Bank Format: PNC Payables Advantage Standard DSV Format File -->
<#-- format specific processing -->
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
<#assign referenceNote = referenceNote + "~ " + transaction.tranid>
<#else>
<#assign referenceNote = transaction.tranid>
</#if>
</#if>
</#list>
</#if>
<#return referenceNote>
</#function>

<#-- Assign Initial Variables -->
<#assign totalAmount = 0>
<#assign totalPayments = 0>
<#assign recordCount = 0>

<#-- template building -->
#OUTPUT START#

<#-- ACH Payment -->
<#list payments as payment>
    <#assign ebank = ebanks[payment_index]>
    <#assign entity = entities[payment_index]>
    <#assign amount = getAmount(payment)>
    <#assign totalAmount = totalAmount + amount>
    <#assign totalPayments = totalPayments + 1>
    <#assign recordCount = recordCount + 1>

${setMaxLength(payment.memomain~18)}
${setMaxLength(getReferenceNote(payment),16)}
${setMaxLength(ebank.custrecord_2663_entity_bank_no~17)}

<#--P01-->ACH~<#rt><#--Payment Type (3)-->
<#--P02-->${setMaxLength(cbank.custpage_eft_custrecord_2663_bank_code,15)}~<#rt><#--Sender ID (15)-->
<#--P03-->AP0~<#rt><#--Application Format (3)-->
<#--P04-->${setMaxLength(payment.tranid,5)}~<#rt><#--Transaction Number (5)-->
<#--P05-->~<#rt><#--Payment Effective Date (8)-->
<#--P06-->~<#rt><#--Payment Amount (10)-->
<#--P07-->~<#rt><#--Receiver Name (22)-->
<#--P08-->~<#rt><#--Receiver ABA (9)-->
<#--P09-->${setMaxLength(cbank.custpage_eft_custrecord_2663_acct_num~34)}~<#rt><#--Receiver Account Number (17)-->
<#--P10-->${setMaxLength(pfa.custrecord_2663_file_creation_timestamp?string("dd/MM/yyyy")~10)}~<#rt><#--ACH Tran Code (2)-->
<#--P11-->CCD~<#rt><#--ACH Type (3)-->
<#--P12-->~<#rt><#--Canadian Indicator (1)-->
</#list>
${setMaxLength(formatAmount(totalAmount~"dec")~14)}<#rt>


<#-- Wire Payment -->
<#list payments as payment>
    <#assign ebank = ebanks[payment_index]>
    <#assign entity = entities[payment_index]>
    <#assign amount = getAmount(payment)>
    <#assign totalAmount = totalAmount + amount>
    <#assign totalPayments = totalPayments + 1>
    <#assign recordCount = recordCount + 1>
    
<#--P01-->FWT~<#rt><#--Payment Type (3)-->
<#--P02-->${setMaxLength(cbank.custpage_eft_custrecord_2663_bank_code,15)}~<#rt><#--Sender ID (15)-->
<#--P03-->AP0~<#rt><#--Application Format (3)-->
<#--P04-->${setMaxLength(payment.tranid,5)}~<#rt><#--Transaction Number (5)-->
<#--P05-->~<#rt><#--Payment Effective Date (8)-->
<#--P06-->~<#rt><#--Payment Amount (10)-->
<#--P07-->~<#rt><#--Receiver Name (22)-->
<#--P08-->~<#rt><#--Receiver ABA (9)-->
<#--P09-->${setMaxLength(cbank.custpage_eft_custrecord_2663_acct_num~34)}~<#rt><#--Receiver Account Number (17)-->
<#--P10-->${setMaxLength(pfa.custrecord_2663_file_creation_timestamp?string("dd/MM/yyyy")~10)}~<#rt><#--ACH Tran Code (2)-->
<#--P11-->CCD~<#rt><#--ACH Type (3)-->
<#--P12-->~<#rt><#--Canadian Indicator (1)-->
</#list>
T~${setMaxLength(recordCount~5)}~${setMaxLength(formatAmount(totalAmount~"dec")~14)}<#rt>

<#-- Check Payment -->
<#list payments as payment>
    <#assign ebank = ebanks[payment_index]>
    <#assign entity = entities[payment_index]>
    <#assign amount = getAmount(payment)>
    <#assign totalAmount = totalAmount + amount>
    <#assign totalPayments = totalPayments + 1>
    <#assign recordCount = recordCount + 1>
    
<#--P01-->CHK~<#rt><#--Payment Type (3)-->
<#--P02-->${setMaxLength(cbank.custpage_eft_custrecord_2663_bank_code,15)}~<#rt><#--Sender ID (15)-->
<#--P03-->AP0~<#rt><#--Application Format (3)-->
<#--P04-->${setMaxLength(payment.tranid,5)}~<#rt><#--Transaction Number (5)-->
<#--P05-->~<#rt><#--Payment Effective Date (8)-->
<#--P06-->~<#rt><#--Payment Amount (10)-->
<#--P07-->~<#rt><#--Receiver Name (22)-->
<#--P08-->~<#rt><#--Receiver ABA (9)-->
<#--P09-->${setMaxLength(cbank.custpage_eft_custrecord_2663_acct_num~34)}~<#rt><#--Receiver Account Number (17)-->
<#--P10-->${setMaxLength(pfa.custrecord_2663_file_creation_timestamp?string("dd/MM/yyyy")~10)}~<#rt><#--ACH Tran Code (2)-->
<#--P11-->CCD~<#rt><#--ACH Type (3)-->
<#--P12-->~<#rt><#--Canadian Indicator (1)-->
</#list>
#OUTPUT END#
