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

<#list payments as payment>
    <#assign ebank = ebanks[payment_index]>
    <#assign entity = entities[payment_index]>
    <#assign amount = getAmount(payment)>
    <#assign totalAmount = totalAmount + amount>
    <#assign totalPayments = totalPayments + 1>
    <#assign recordCount = recordCount + 1>
    
<#--P01-->ACH~<#rt><#--Payment Type (3)-->
<#--P02-->RTGS~<#rt><#--Sender ID (15)-->
<#--P03-->AP0~<#rt><#--Application Format (3)-->
<#--P04-->~<#rt><#--Transaction Number (5)-->
<#--P05-->${setMaxLength(getReferenceNote(payment)~16)}~<#rt><#--Payment Effective Date (8)-->
<#--P06-->${setMaxLength(payment.memomain~18)}~<#rt><#--Payment Amount (10)-->
<#--P07-->TW~<#rt><#--Receiver Name (22)-->
<#--P08-->TPE~<#rt><#--Receiver ABA (9)-->
<#--P09-->${setMaxLength(cbank.custpage_eft_custrecord_2663_acct_num~34)}~<#rt><#--Receiver Account Number (17)-->
<#--P10-->${setMaxLength(pfa.custrecord_2663_file_creation_timestamp?string("dd/MM/yyyy")~10)}~<#rt><#--ACH Tran Code (2)-->
<#--P11-->CCD~<#rt><#--ACH Type (3)-->
<#--P12-->~<#rt><#--Canadian Indicator (1)-->
<#--P13-->~<#rt><#--Vendor Number (10)-->
<#--P14-->~<#rt><#--Currency Type (3)-->
<#--P15-->~<#rt><#--Trace Number (10)-->
<#--P16-->${setMaxLength(ebank.custrecord_2663_entity_bank_no~17)}~<#rt><#--Invoice Number (20)-->
<#--P17-->~<#rt><#--Invoice Date (8)-->
<#--P18-->~<#rt><#--Not Used--><#--Payee Branch Code-->
<#--P19-->~<#rt><#--Not Used-->
<#--P20-->${setMaxLength(ebank.custrecord_2663_entity_acct_no~34)}~<#rt><#--Payee Account Number-->
<#--P21-->~<#rt><#--Not Used--><#--Payment Description on Checks (70)-->
<#--P22-->~<#rt><#--Not Used--><#--Payment Description on Checks (70)-->
<#--P23-->~<#rt><#--Not Used-->
<#--P24-->~<#rt><#--Not Used-->
<#--P25-->~<#rt><#--Not Used-->
<#--P26-->~<#rt><#--Not Used-->
<#--P27-->~<#rt><#--Not Used-->
<#--P28-->~<#rt><#--Not Used-->
<#--P29-->~<#rt><#--Not Used-->
<#--P30-->~<#rt><#--Not Used-->
<#--P31-->~<#rt><#--Not Used-->
<#--P32-->~<#rt><#--Not Used-->
${"\n"}<#--Line Break--><#rt>
</#list>
T~${setMaxLength(recordCount~5)}~${setMaxLength(formatAmount(totalAmount~"dec")~14)}<#rt>
#OUTPUT END#
