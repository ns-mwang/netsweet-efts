<#--Author: Michael Wang | mwang@netsuite.com-->
<#-- Global Remit Layout (File Spec) v1.6.2 -->

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
<#--- Filed Header Record (00) --->
<#--P01-->00<#rt><#--Record Type-->
<#--P02-->${setLength(cbank.custpage_eft_custrecord_2663_bank_comp_id,15)}<#rt><#--Submitter Identifier-->
<#--P03-->${pfa.custrecord_2663_file_creation_timestamp?string("yyyyMMdd")}<#rt><#--File Creation Date-->
<#--P04-->${pfa.custrecord_2663_file_creation_timestamp?string("HHmmss")}<#rt><#--File Creation Time-->
<#--P05-->TT<#rt><#--Test File Indicator (Test File=TT;Production=Blank)-->
<#--P06-->${setPadding(payment.tranid,"right"," ",20)}<#rt><#--File ID-->
<#--P07-->${setLength(" ",347)}<#rt><#--Filler-->
${"\r\n"}<#--Line Break--><#rt>
<#--- Payment Records --->
<#assign TotalAmount = 0>
<#assign RecordCount = 0>
<#-- Payment Records Loop -->
<#list payments as payment>
    <#assign ebank = ebanks[payment_index]>
    <#assign entity = entities[payment_index]>
    <#assign PayAmount = getAmount(payment)>
    <#assign TotalAmount = TotalAmount + PayAmount>
    <#assign RecordCount = RecordCount + 1>
    <#-- Calculate Remittance Numbers for Field P22 -->
    <#assign RemitNumber = 0>
    <#assign paidTransactions = transHash[payment.internalid]>
       <#list paidTransactions as transaction>
          <#assign RemitNumber = RemitNumber + 1>
       </#list>   
<#--- Remittance Detail (01) --->
<#--P01-->01<#rt><#--Record Type (01)-->
<#--P02-->+<#rt><#--Credit or Debit Identifier-->
<#--P03-->${setPadding(formatAmount(PayAmount),"left","0",20)}<#rt><#--Remittance Amount-->
<#--P04-->2<#rt><#--Remittance Decimal Places-->
<#--P05-->${setLength("0",42)}<#rt><#--Filler-->
<#--P06-->${setPadding("123456789000000","left","0",20)}<#rt><#--Corporate Card Number-->
<#--P07-->${setPadding("0","left","0",19)}<#rt><#--Requesting Control Account ***NEEDS REVIEW***-->
<#--P08-->${setPadding("0","left","0",19)}<#rt><#--Basic Control Account-->${setLength(pfa.custrecord_2663_process_date?string("yyyyMMdd"),8)}
<#--P09-->${setPadding("0","left","0",19)}<#rt><#--Amex Market Code ***NEEDS REVIEW***-->
<#--P10-->${setPadding(formatAmount(ACHPayAmount),"left","0",10)}<#rt><#--Global Client Origin Identifier-->
<#--P11-->${setPadding("0","left","0",19)}<#rt><#--Sender ID or Load Number ***NEEDS REVIEW***-->${setPadding(buildEntityName(entity),"right"," ",22)}
<#--P12-->${setLength(" ",13)}<#rt><#--Book Number-->
<#--P13-->${setLength(" ",15)}<#rt><#--ISO 4217 Currency Code-->
<#--P14-->${setLength(" ",20)}<#rt><#--ISO 3166-1 Country Code-->
<#--P15-->${setLength(" ",35)}<#rt><#--Remittance Message Code Line 1-->
<#--P16-->${setLength(" ",35)}<#rt><#--Descriptive Message Code Line 2-->
<#--P17-->${setLength(" ",35)}<#rt><#--Company Data Line 2-->
<#--P18-->${setLength(" ",27)}<#rt><#--Descriptive Message Code Line 3-->
<#--P19-->${setLength(" ",2)}<#rt><#--Company Data Line 3-->
<#--P20-->${setLength(" ",9)}<#rt><#--Descriptive Message Code Line 4-->
<#--P21-->${setLength(" ",4)}<#rt><#--Company Data Line 4-->
<#--P22-->${setPadding(RemitNumber,"left","0",5)}<#rt><#--Card Number Disguising Control Account Number-->
<#--P23-->${setLength(" ",10)}<#rt><#--Filler-->
${"\r\n"}<#--Line Break--><#rt>

<#--- Payment Summary (02) --->
<#--P01-->02<#rt><#--Record Type (02)-->
<#--P02-->01<#rt><#--Amex Market Code-->
<#--P03-->${setLength(" ",10)}<#rt><#--ISO 3166-1 Country Code-->
<#--P04-->${setLength(" ",30)}<#rt><#--Sender ID or Load Number-->
<#--P05-->${setLength(" ",1)}<#rt><#--Book Number-->
<#--P06-->${setLength(" ",20)}<#rt><#--ISO 4217 Currency Code-->
<#--P07-->${setLength(" ",284)}<#rt><#--Resubmit Version Number-->
<#--P23-->${setLength(" ",10)}<#rt><#--Filler-->
<#--P23-->${setLength(" ",10)}<#rt><#--Record Count-->
<#--P23-->${setLength(" ",10)}<#rt><#--Total Remittance-->
<#--P23-->${setLength(" ",10)}<#rt><#--Total Remittance Amount Decimal Places-->
<#--P23-->${setLength(" ",10)}<#rt><#--Payment Posting Date-->
<#--P23-->${setLength(" ",10)}<#rt><#--Transaction Reference Bank Number-->
<#--P23-->${setLength(" ",10)}<#rt><#--Bank Code-->
<#--P23-->${setLength(" ",10)}<#rt><#--Bank Agency Code-->
<#--P23-->${setLength(" ",10)}<#rt><#--Bank Account Number-->
<#--P23-->${setLength(" ",10)}<#rt><#--Sub Account Number-->
<#--P23-->${setLength(" ",10)}<#rt><#--Global Payment Reference-->
<#--P23-->${setLength(" ",248)}<#rt><#--Filler-->
${"\r\n"}<#--Line Break--><#rt>


<#assign paidTransactions = transHash[payment.internalid]>
   <#list paidTransactions as transaction>
<#-- ACH Remittance Detail Record : 070-06 -->
<#--P01-->070<#rt><#--Record Identifier (070)-->
<#--P02-->06<#rt><#--Sub-Record Identifier (06)-->
<#--P03-->${setLength(transaction.trandate?string("yyyyMMdd"),8)}<#rt><#--Invoice Date-->
<#--P04-->${setLength(transaction.tranid,20)}<#rt><#--Invoice Number-->
<#--P05-->${setLength("Memo: " + transaction.memo,30)}<#rt><#--Descriptive Text-->
<#--P06-->${setPadding(formatAmount(transaction.total),"left","0",13)}<#rt><#--Invoice Gross Amount-->
<#--P07-->${setPadding("0","left","0",13)}<#rt><#--Adjusted Amount-->
<#--P08-->${setPadding(formatAmount(transaction.total),"left","0",13)}<#rt><#--Net Amount-->
<#--P09-->${setLength(" ",248)}<#rt><#--Filler-->
${"\r\n"}<#--Line Break--><#rt>
   </#list>
   
<#-- ACH Remittance Trailer Record: 070-09 -->
<#--P01-->070<#rt><#--Record Identifier (070)-->
<#--P02-->09<#rt><#--Sub-record Identifier (09)-->
<#--P03-->${setPadding("0","left","0",26)}<#rt><#--Zeros-->
<#--P04-->${setLength(" ",319)}<#rt><#--Filler-->
${"\r\n"}<#--Line Break--><#rt>

<#--- File Summary Trailer Record Type (09) --->
<#assign TotalAmount = 0>
<#assign TotalRecordCount = 0>
<#assign TotalAmount = ACHTotalAmount + WireTotalAmount + CHKTotalAmount>
<#assign TotalRecordCount = ACHRecordCount + WireRecordCount + CHKRecordCount>
<#--P01-->090<#rt><#--Record Type-->
<#--P02-->${setPadding(formatAmount(CHKTotalAmount),"left","0",13)}<#rt><#--Record Count-->
<#--P03-->${setLength(" ",383)}<#rt><#--Filler-->
${"\r\n"}<#--Line Break--><#rt>
#OUTPUT END#
