<#-- Author: Michael Wang | mwang@netsuite.com -->
<#-- Bank Format: RBI File Format -->
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
          <#assign referenceNote = referenceNote + ", " + transaction.tranid>
        <#else>
          <#assign referenceNote = transaction.tranid>
      </#if>
     </#if>
    </#list>
</#if>
<#return referenceNote>
</#function>

<#-- Assign Initial Variables -->
<#assign recordCount = 0>

<#-- template building -->
#OUTPUT START#

<#list payments as payment>
    <#assign ebank = ebanks[payment_index]>
    <#assign entity = entities[payment_index]>
    <#assign amount = getAmount(payment)>
    <#assign recordCount = recordCount + 1>
<#if cbank.custpage_eft_custrecord_2663_bank_name == ebank.custrecord_2663_entity_bank_name> <#-- If Bank Name is HDFC then display the letter (I) -->
<#--P01-->I,<#rt><#--Transaction Type-->
<#else>
<#--P01-->N,<#rt><#--Transaction Type-->
</#if>
<#--P02-->${recordCount},<#rt><#--Beneficiary Code (Sequence Number)-->
<#--P03-->${ebank.custrecord_2663_entity_acct_no},<#rt><#--Beneficiary Account Number-->
<#--P04-->${formatAmount(getAmount(payment),"dec")},<#rt><#--Instrument Amount-->
<#--P05-->${setMaxLength(buildEntityName(entity),22)},<#rt><#--Beneficiary Name-->
<#--P06-->${setMaxLength(payment.memomain,20)},<#rt><#--Instruction Reference Number-->
<#--P07-->${setMaxLength(getReferenceNote(payment),20)},<#rt><#--Customer Reference Number-->
<#--P08-->${pfa.custrecord_2663_process_date?string("dd/MM/yyyy")},<#rt><#--Cheque Date-->
<#--P09-->${ebank.custrecord_2663_entity_bank_no},<#rt><#--IFSC COD-->
<#--P10-->${setMaxLength(ebank.custrecord_2663_entity_bank_name,20)},<#rt><#--BENE BANK-->
<#--P11-->${cbank.custpage_eft_custrecord_2663_jumio_bene_email}<#rt><#--Bene Email Id-->
${"\r\n"}<#--Line Break--><#rt>
</#list>
#OUTPUT END#
