<#--Author: Michael Wang | mwang@netsuite.com-->
<#--PNC Payable Advantages Flat File-->

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
<#--- Filed Header Record (010) --->
<#--P01-->010<#rt><#--Record Identifier-->
<#--P02-->${setLength(cbank.custpage_eft_custrecord_2663_bank_comp_id,15)}<#rt><#--Sender Identification Number-->
<#--P03-->${setLength(cbank.custpage_eft_custrecord_2663_bank_code,3)}<#rt><#--Business Application Format-->
<#--P04-->${setLength(cbank.custrecord_2663_print_company_name,16)}<#rt><#--Customer Name-->
<#--P05-->${pfa.custrecord_2663_file_creation_timestamp?string("yyyyMMdd")}<#rt><#--Transmission Date (yyyyMMdd)-->
<#--P06-->${pfa.custrecord_2663_file_creation_timestamp?string("HHmm")}<#rt><#--Transmission Time (HHmm)-->
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
<#elseif payment.custbody_2663_eft_payment_method == "Wire">
<#--- Wire Payment Record (060) --->
    <#assign WirePayAmount = getAmount(payment)>
    <#assign WireTotalAmount = WireTotalAmount + WirePayAmount>
    <#assign WireRecordCount = WireRecordCount + 1>
<#--P01-->060<#rt><#--Record ID (060)-->
<#--P02-->FWT<#rt><#--Payment Type (FWT)-->
<#--P03-->${setLength(" ",15)}<#rt><#--Filler-->
<#--P04-->${setLength("USD",3)}<#rt><#--Currency Type-->
<#--P05-->${setLength(" ",10)}<#rt><#--Filler-->
<#--P06-->${setLength(pfa.custrecord_2663_process_date?string("yyyyMMdd"),8)}<#rt><#--Payment Effective Date-->
<#--P07-->${setPadding(formatAmount(WirePayAmount),"left","0",13)}<#rt><#--Payment Amount-->
<#--P08-->${setPadding(buildEntityName(entity),"right"," ",35)}<#rt><#--Beneficiary Name-->
<#--P09-->${setLength(" ",35)}<#rt><#--IBAN Account  Number (BOP and PRO only)-->
<#--P10-->${setLength(" ",35)}<#rt><#--Beneficiary Address 1-->
<#--P11-->${setLength(" ",35)}<#rt><#--Beneficiary Address 2-->
<#--P12-->${setLength(" ",35)}<#rt><#--Beneficiary Address 3-->
<#--P13-->${setLength(" ",1)}<#rt><#--Internal Use Only Client Should Send Spaces-->
<#--P14-->${setLength(" ",20)}<#rt><#--Internal Use Only Client Should Send Spaces-->
<#--P15-->${setLength(" ",21)}<#rt><#--Filler-->
<#--P16-->${setLength("00001",5)}<#rt><#--Number of Remittance Lines-->
<#--P17-->${setPadding(ebank.custrecord_2663_entity_bank_no,"right"," ",12)}<#rt><#--Beneficiary Bank ID-->
<#--P18-->${setPadding(ebank.custrecord_2663_entity_acct_no,"right"," ",17)}<#rt><#--Beneficiary Account Number-->
<#--P19-->${setLength("A",1)}<#rt><#--Beneficiary Bank Type (ABA = A)-->
<#--P20-->${setLength(" ",3)}<#rt><#--Filler-->
<#--P21-->${setLength("D",1)}<#rt><#--Beneficiary Account Type-->
<#--P22-->${setLength(" ",8)}<#rt><#--Repetitive Wire Code-->
<#--P23-->${setLength(" ",30)}<#rt><#--Client Transaction ID-->
<#--P24-->${setLength(" ",1)}<#rt><#--Filler-->
${"\r\n"}<#--Line Break--><#rt>
<#--- Wire Payment Record (080) --->
<#--P01-->080<#rt><#--Record ID (080)-->
<#--P02-->${setLength(" ",35)}<#rt><#--Originator to Beneficiary Text 1-->
<#--P03-->${setLength(" ",35)}<#rt><#--Originator to Beneficiary Text 2-->
<#--P04-->${setLength(" ",35)}<#rt><#--Originator to Beneficiary Text 3-->
<#--P05-->${setLength(" ",35)}<#rt><#--Originator to Beneficiary Text 4-->
<#--P06-->${setLength(" ",16)}<#rt><#--Reference for Beneficiary-->
<#--P07-->${setLength(" ",3)}<#rt><#--Advice Code-->
<#--P08-->${setLength(" ",35)}<#rt><#--Advice Description -->
<#--P09-->${setLength(" ",153)}<#rt><#--Filler-->
${"\r\n"}<#--Line Break--><#rt>
<#--- Wire Payment Record (085) --->
<#--P01-->085<#rt><#--Record ID (085)-->
<#--P02-->${setLength(" ",35)}<#rt><#--Receiving Bank Name-->
<#--P03-->${setLength(" ",35)}<#rt><#--Receiving Bank Address 1-->
<#--P04-->${setLength(" ",35)}<#rt><#--Receiving Bank Address 2-->
<#--P05-->${setLength(" ",35)}<#rt><#--Receiving Bank City-->
<#--P06-->${setLength(" ",2)}<#rt><#--Filler-->
<#--P07-->${setLength(" ",1)}<#rt><#--Receiving Bank Type-->
<#--P08-->${setLength(" ",12)}<#rt><#--Receiving Bank ID-->
<#--P09-->${setLength(" ",35)}<#rt><#--Beneficiary Bank Name-->
<#--P10-->${setLength(" ",35)}<#rt><#--Beneficiary Bank Address 1-->
<#--P11-->${setLength(" ",35)}<#rt><#--Beneficiary Bank Address 2-->
<#--P12-->${setLength(" ",35)}<#rt><#--Beneficiary Bank City-->
<#--P13-->${setLength(" ",52)}<#rt><#--Filler-->
${"\r\n"}<#--Line Break--><#rt>
<#elseif payment.custbody_2663_eft_payment_method == "Check">
<#--- Check Payment Record (060) --->
    <#assign CHKPayAmount = getAmount(payment)>
    <#assign CHKTotalAmount = CHKTotalAmount + CHKPayAmount>
    <#assign CHKRecordCount = CHKRecordCount + 1>
    <#-- Calculate Remittance Numbers for Field P21 -->
    <#assign RemitNumber = 0>
    <#assign paidTransactions = transHash[payment.internalid]>
       <#list paidTransactions as transaction>
          <#assign RemitNumber = RemitNumber + 1>
       </#list>
<#--P01-->060<#rt><#--Record ID (060)-->
<#--P02-->CHK<#rt><#--Payment Type (CHK)-->
<#--P03-->X<#rt><#--Check Instruction (X)-->
<#--P04-->${setLength(" ",10)}<#rt><#--Vendor Number-->
<#--P05-->UM<#rt><#--Mail Instruction (UM)-->
<#--P06-->${setLength(" ",2)}<#rt><#--Bulk Mail Address Code-->
<#--P07-->USD<#rt><#--Currency Type (USD)-->
<#--P08-->${setPadding("0","left","0",10)}<#rt><#--Check Serial Number-->
<#--P09-->${setLength(pfa.custrecord_2663_process_date?string("yyyyMMdd"),8)}<#rt><#--Effective Date of Check-->
<#--P10-->${setPadding(formatAmount(CHKPayAmount),"left","0",13)}<#rt><#--Payment Amount-->
<#--P11-->${setPadding(entity.billaddressee,"right"," ",35)}<#rt><#--Payee Name 1-->
<#--P12-->${setPadding(" ","right"," ",35)}<#rt><#--Payee Name 2 -->
<#--P13-->${setPadding(entity.billaddress1,"right"," ",35)}<#rt><#--Payee Address 1-->
<#--P14-->${setPadding(entity.billaddress2,"right"," ",35)}<#rt><#--Payee Address 2-->
<#--P15-->${setPadding(" ","right"," ",35)}<#rt><#--Payee Address 3-->
<#--P16-->${setPadding(entity.billcity,"right"," ",27)}<#rt><#--Payee City-->
<#--P17-->${setPadding(entity.billstate,"right"," ",2)}<#rt><#--Payee State-->
<#--P18-->${setPadding(entity.billzipcode?replace("-",""),"right"," ",9)}<#rt><#--Payee Zip Code-->
<#--P19-->${setLength(" ",1)}<#rt><#--Filler-->
<#--P20-->${setPadding(getCountryCode(entity.billcountry),"right"," ",3)}<#rt><#--Payee Country-->
<#--P21-->${setPadding(RemitNumber,"left","0",5)}<#rt><#--Number of Remittance Lines-->
<#--P22-->${setLength(" ",10)}<#rt><#--Filler-->
<#--P23-->${setLength(" ",50)}<#rt><#--Payment data-->
<#--P24-->${setLength(" ",13)}<#rt><#--Filler-->
<#--- CHK Remittance Header Record : 070-01  (One record per payment (060) Record) --->
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
</#if>
</#list>
<#--- File Trailer Record (090) --->
<#assign TotalAmount = 0>
<#assign TotalRecordCount = 0>
<#assign TotalAmount = ACHTotalAmount + WireTotalAmount + CHKTotalAmount>
<#assign TotalRecordCount = ACHRecordCount + WireRecordCount + CHKRecordCount>
<#--P01-->090<#rt><#--Record Identifier-->
<#--P02-->${setPadding(formatAmount(CHKTotalAmount),"left","0",13)}<#rt><#--Total Dollar amount of Checks-->
<#--P03-->${setPadding(CHKRecordCount,"left","0",7)}<#rt><#--Total Records, Checks-->
<#--P04-->${setPadding(formatAmount(ACHTotalAmount),"left","0",13)}<#rt><#--Total Dollar amount of ACHs-->
<#--P05-->${setPadding(ACHRecordCount,"left","0",7)}<#rt><#--Total Records, ACHs-->
<#--P06-->${setPadding(formatAmount(WireTotalAmount),"left","0",13)}<#rt><#--Total Dollar amount of Wires-->
<#--P07-->${setPadding(WireRecordCount,"left","0",7)}<#rt><#--Total Records, Wire-->
<#--P08-->${setPadding("0","left","0",13)}<#rt><#--Total Dollar amount of Cards-->
<#--P09-->${setPadding("0","left","0",7)}<#rt><#--Total Records,  Cards-->
<#--P10-->${setPadding(formatAmount(TotalAmount),"left","0",13)}<#rt><#--Total Payment Dollar Amounts-->
<#--P11-->${setPadding(TotalRecordCount,"left","0",7)}<#rt><#--Total Payment Records-->
<#--P12-->${setPadding(formatAmount(TotalAmount),"left","0",13)}<#rt><#--Total File Dollar Amounts-->
<#--P13-->${setPadding(TotalRecordCount,"left","0",7)}<#rt><#--Total File Records-->
<#--P14-->${setLength(" ",227)}<#rt><#--Filler-->
${"\r\n"}<#--Line Break--><#rt>
#OUTPUT END#
