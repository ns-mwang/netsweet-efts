<#--Author: Michael Wang | mwang@netsuite.com-->
<#--EFD Bulk Payments – CSV File Format-->

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
<#---Header Record--->
<#--P00-->BULKCSV,<#rt><#--File Type-->
<#--P01-->${setMaxLength(cbank.custrecord_2663_print_company_name,35)},<#rt><#--Company Name-->
<#--P02-->${setMaxLength(cbank.custpage_eft_custrecord_2663_bank_comp_id,10)},<#rt><#--Company ID-->
<#--P03-->${setMaxLength(cbank.custpage_eft_custrecord_2663_bank_code,4)},<#rt><#--Company EFT Key-->
<#--P04-->${pfa.custrecord_2663_file_creation_timestamp?string("yyyyMMdd")},<#rt><#--Creation Date (CCYYMMDD)-->
<#--P05-->,<#rt><#--File Name-->
<#--P06-->TEST,<#rt><#--Test/Production indicator-->
<#--P07-->${setLength(" ",10)}<#rt><#--Client File ID-->
<#--P08-->${setLength(" ",291)}<#rt><#--Filler-->
${"\r\n"}<#--Line Break--><#rt>
<#--- Payment Records --->
<#assign ACHTotalAmount = 0>
<#assign ACHRecordCount = 0>
<#assign CHKTotalAmount = 0>
<#assign CHKRecordCount = 0>
<#assign WireTotalAmount = 0>
<#assign WireRecordCount = 0>
<#-- Payment Records Loop -->
<#list payments as payment>
    <#assign ebank = ebanks[payment_index]>
    <#assign entity = entities[payment_index]>
<#if payment.custbody_2663_eft_payment_method = "ACH"> 
    <#assign ACHPayAmount = getAmount(payment)>
    <#assign ACHTotalAmount = ACHTotalAmount + ACHPayAmount>
    <#assign ACHRecordCount = ACHRecordCount + 1>
    <#-- Calculate Remittance Numbers for Field P22 -->
    <#assign RemitNumber = 0>
    <#assign paidTransactions = transHash[payment.internalid]>
       <#list paidTransactions as transaction>
          <#assign RemitNumber = RemitNumber + 1>
       </#list>   
<#--- ACH Payment Record (060) --->
<#--P01-->060<#rt><#--Record ID (060)-->
<#--P02-->ACH<#rt><#--Payment Type (ACH)-->
<#--P03--> <#rt><#--Canadian Indicator (C or Space)-->
<#--P04-->${setLength(" ",10)}<#rt><#--Vendor Number (OPT)-->
<#--P05-->${setLength(" ",4)}<#rt><#--Filler-->
<#--P06-->${setLength("USD",3)}<#rt><#--Currency Type-->
<#--P07-->${setPadding("0","left","0",10)}<#rt><#--Trace Number-->
<#--P08-->${setLength(pfa.custrecord_2663_process_date?string("yyyyMMdd"),8)}<#rt><#--Payment Effective Date-->
<#--P09-->${setLength(" ",3)}<#rt><#--Filler-->
<#--P10-->${setPadding(formatAmount(ACHPayAmount),"left","0",10)}<#rt><#--Payment Amount-->
<#--P11-->${setPadding(buildEntityName(entity),"right"," ",22)}<#rt><#--Receiver Name-->
<#--P12-->${setLength(" ",13)}<#rt><#--Filler-->
<#--P13-->${setLength(" ",15)}<#rt><#--Individual ID-->
<#--P14-->${setLength(" ",20)}<#rt><#--Filler-->
<#--P15-->${setLength(" ",35)}<#rt><#--Receiver Address 1-->
<#--P16-->${setLength(" ",35)}<#rt><#--Receiver Address 2-->
<#--P17-->${setLength(" ",35)}<#rt><#--Receiver Address 3-->
<#--P18-->${setLength(" ",27)}<#rt><#--Receiver City-->
<#--P19-->${setLength(" ",2)}<#rt><#--Receiver State-->
<#--P20-->${setLength(" ",9)}<#rt><#--Receiver Zip-->
<#--P21-->${setLength(" ",4)}<#rt><#--Filler-->
<#--P22-->${setPadding(RemitNumber,"left","0",5)}<#rt><#--Number of Remittance Lines-->
<#--P23-->${setLength(" ",10)}<#rt><#--Filler-->
<#--P24-->${setPadding(ebank.custrecord_2663_entity_bank_no,"left","0",9)}<#rt><#--Receiver ABA (Transit Routing)-->
<#--P25-->${setLength(" ",3)}<#rt><#--Filler-->
<#--P26-->${setPadding(ebank.custrecord_2663_entity_acct_no,"right"," ",17)}<#rt><#--Receiver Account Number-->
<#--P27-->${setLength("22",2)}<#rt><#--ACH Tran Code (22)-->
<#--P28-->${setLength("CTX",3)}<#rt><#--ACH Type-->
<#--P29-->${setLength(" ",20)}<#rt><#--Discretionary Data-->
<#--P30-->${setLength(" ",9)}<#rt><#--Filler-->
${"\r\n"}<#--Line Break--><#rt>
<#--- ACH Remittance Header Record : 070-01  (One record per payment (060) Record) --->
<#--P01-->070<#rt><#--Record Identifier (070)-->
<#--P02-->01<#rt><#--Sub-Record Identifier (01)-->
<#--P03-->${setLength(" ",10)}<#rt><#--Vendor Number-->
<#--P04-->${setLength(" ",30)}<#rt><#--Client Transaction ID-->
<#--P05-->${setLength(" ",1)}<#rt><#--Filler-->
<#--P06-->${setLength(" ",20)}<#rt><#--Filler-->
<#--P07-->${setLength(" ",284)}<#rt><#--Filler-->
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
</#list>

<#--Footer Record-->
<#assign TotalAmount = 0>
<#assign TotalRecordCount = 0>
<#assign TotalAmount = ACHTotalAmount + WireTotalAmount + CHKTotalAmount>
<#assign TotalRecordCount = ACHRecordCount + WireRecordCount + CHKRecordCount>
<#--P00-->BULKCSVTRAILER,<#rt><#--Record Type-->
<#--P01-->090<#rt><#--Record Identifier-->
<#--P02-->${setMaxLength(TotalRecordCount,10)},<#rt><#--Transaction Count-->
<#--P03-->${setMaxLength(formatAmount(TotalAmount),15)},<#rt><#--Amount Hash Total-->
${"\r\n"}<#--Line Break--><#rt>
#OUTPUT END#
