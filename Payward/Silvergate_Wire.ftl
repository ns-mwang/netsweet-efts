<#--Author: Michael Wang | mwang@netsuite.com-->
<#--Silvergate Wire CSV File-->

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

<#-- cached values -->
<#assign totalAmount = formatAmount(computeTotalAmount(payments))>

<#-- template building -->
#OUTPUT START#
<#-- Payment Records Loop -->
<#list payments as payment>
    <#assign ebank = ebanks[payment_index]>
    <#assign entity = entities[payment_index]>
<#--Debit Field Properties Information-->
<#--P01-->${setLength(cbank.custpage_eft_custrecord_2663_bank_num,9)},<#rt><#--ABA/TRC-->
<#--P02-->C,<#rt><#--Account Type-->
<#--P03-->${setMaxLength(cbank.custpage_eft_custrecord_2663_acct_num,35)},<#rt><#--Account Number-->
<#--P04-->$formatAmount(getAmount(payment),"dec")},<#rt><#--Amount-->
<#--P05-->${pfa.custrecord_2663_process_date?string("yyyyMMdd")},<#rt><#--Send on Date-->
<#--P06-->${setLength(getCurrencySymbol(payment.currency),3)},<#rt><#--Currency-->
<#--Recipient Field Properties Information-->
<#--P07-->${setMaxLength(ebank.custrecord_2663_bankidtype,5)},<#rt><#--Bank ID type-->
<#--P08-->${setMaxLength(ebank.custrecord_2663_entity_bank_no,11)},<#rt><#--Bank ID-->
<#--P09-->${setMaxLength(ebank.custrecord_2663_entity_acct_no,35)},<#rt><#--Recipient account-->
<#--P10-->${setMaxLength(ebank.custrecord_2663_entity_bank_name,35)},<#rt><#--Bank name-->
<#--P11-->${setMaxLength(ebank.custrecord_2663_entity_address1,35)},<#rt><#--Bank address 1-->
<#--P12-->${setMaxLength(ebank.custrecord_2663_entity_address2,35)},<#rt><#--Bank address 2-->
<#--P13-->${setMaxLength(ebank.custrecord_2663_entity_address3,35)},<#rt><#--Bank address 3-->
<#--P14-->${setMaxLength(buildEntityName(entity),35)},<#rt><#--Recipient name-->
<#--P15-->${setMaxLength(entity.billaddress1,35)},<#rt><#--Recipient address 1-->
<#--P16-->${setMaxLength(entity.billaddress2,35)},<#rt><#--Recipient address 2-->
<#--P17-->${setMaxLength(entity.billaddress3,35)},<#rt><#--Recipient address 3-->
<#--P18-->${setMaxLength(getReferenceNote(payment),140)},<#rt><#--Additional information for recipient-->
<#if ebank.custrecord_2663_first_bankidtype?has_content>
<#--First Intermediary Field Properties Information-->
<#--P19-->${setMaxLength(ebank.custrecord_2663_first_bankidtype,5)},<#rt><#--Bank ID type-->
<#--P20-->${setMaxLength(ebank.custrecord_2663_first_bankid,11)},<#rt><#--Bank ID-->
<#--P21-->${setMaxLength(ebank.custrecord_2663_first_bankacct,35)},<#rt><#--Intermediary account-->
<#--P22-->${setMaxLength(ebank.custrecord_2663_first_bankname,35)},<#rt><#--Bank name-->
<#--P23-->${setMaxLength(ebank.custrecord_2663_first_bankaddr1,35)},<#rt><#--Bank address 1-->
<#--P24-->${setMaxLength(ebank.custrecord_2663_first_bankaddr2,35)},<#rt><#--Bank address 2-->
<#--P25-->${setMaxLength(ebank.custrecord_2663_first_bankaddr3,35)},<#rt><#--Bank address 3-->
</#if>
<#if ebank.custrecord_2663_second_bankidtype?has_content>
<#--Secondary Intermediary Field Properties Information-->
<#--P26-->${setMaxLength(ebank.custrecord_2663_second_bankidtype,5)},<#rt><#--Bank ID type-->
<#--P27-->${setMaxLength(ebank.custrecord_2663_second_bankid,11)},<#rt><#--Bank ID-->
<#--P28-->${setMaxLength(ebank.custrecord_2663_second_bankacct,35)},<#rt><#--Intermediary account-->
<#--P29-->${setMaxLength(ebank.custrecord_2663_second_bankname,35)},<#rt><#--Bank name-->
<#--P30-->${setMaxLength(ebank.custrecord_2663_second_bankaddr1,35)},<#rt><#--Bank address 1-->
<#--P31-->${setMaxLength(ebank.custrecord_2663_second_bankaddr2,35)},<#rt><#--Bank address 2-->
<#--P32-->${setMaxLength(ebank.custrecord_2663_second_bankaddr3,35)},<#rt><#--Bank address 3-->
</#if>
${"\r\n"}<#--Line Break--><#rt>
</#list>
#OUTPUT END#

<#--Wire Initiator Field Properties Information-->
<#--P33-->${setLength(" ",291)},<#rt><#--Wire initiator name-->
<#--P34-->${setLength(" ",291)},<#rt><#--Wire initiator address 1-->
<#--P35-->${setLength(" ",291)},<#rt><#--Wire initiator address 2-->
<#--P36-->${setLength(" ",291)},<#rt><#--Wire initiator address 3-->

REFERENCE FIELDS
<refFields type="Silvergate Wire">
	<refField id="custrecord_2663_acct_num" label="Account Number" mandatory="false" helptext="Enter your company's bank account number."/>
	<refField id="custrecord_2663_bank_num" label="Routing Number" mandatory="false" helptext="Enter the bank's transit routing number (9)."/>
	<refField id="custrecord_2663_bank_acct_type" label="Bank Account Type" helptext="Select Checking or Savings to indicate the bank account type."/>
</refFields>

ENTITY REFERENCE FIELDS
<refFields type='Silvergate Wire'>
  <refField id='custrecord_2663_entity_acct_no' label='Recipient Bank Account Number' mandatory='true' />
  <refField id='custrecord_2663_bankidtype' mandatory='true' label='Recipient Bank ID Type'/>
  <refField id='custrecord_2663_entity_bank_no' label='Recipient Bank ID' mandatory='true' />
  <refField id='custrecord_2663_entity_bank_name' mandatory='true' label='Recipient Bank Name'/>
  <refField id='custrecord_2663_entity_address1' mandatory='true' label='Bank address 1'/>
  <refField id='custrecord_2663_entity_address2' mandatory='false' label='Bank address 2'/>
  <refField id='custrecord_2663_entity_address3' mandatory='false' label='Bank address 3'/>
  <refField id='custrecord_2663_first_bankidtype' mandatory='false' label='First Intermediary Bank ID Type'/>
  <refField id='custrecord_2663_first_bankid' mandatory='false' label='First Intermediary Bank ID'/>
  <refField id='custrecord_2663_first_bankacct' mandatory='false' label='First Intermediary Bank Account'/>
  <refField id='custrecord_2663_first_bankname' mandatory='false' label='First Intermediary Bank Name'/>
  <refField id='custrecord_2663_first_bankaddr1' mandatory='false' label='First Intermediary Bank Address 1'/>
  <refField id='custrecord_2663_first_bankaddr2' mandatory='false' label='First Intermediary Bank Address 2'/>
  <refField id='custrecord_2663_first_bankaddr3' mandatory='false' label='First Intermediary Bank Address 3'/>
  <refField id='custrecord_2663_second_bankidtype' mandatory='false' label='Second Intermediary Bank ID Type'/>
  <refField id='custrecord_2663_second_bankid' mandatory='false' label='Second Intermediary Bank ID'/>
  <refField id='custrecord_2663_second_bankacct' mandatory='false' label='Second Intermediary Bank Account'/>
  <refField id='custrecord_2663_second_bankname' mandatory='false' label='Second Intermediary Bank Name'/>
  <refField id='custrecord_2663_second_bankaddr1' mandatory='false' label='Second Intermediary Bank Address 1'/>
  <refField id='custrecord_2663_second_bankaddr2' mandatory='false' label='Second Intermediary Bank Address 2'/>
  <refField id='custrecord_2663_second_bankaddr3' mandatory='false' label='Second Intermediary Bank Address 3'/>
</refFields>
