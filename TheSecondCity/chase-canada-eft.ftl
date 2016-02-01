<#--Author: Michael Wang | mwang@netsuite.com-->
<#--Chase Global ACH Canada GDFF-->
<#-- cached values -->
<#assign totalAmount = formatAmount(computeTotalAmount(payments))>
<#-- template building -->
#OUTPUT START#
<#--- Filed Header Record (FH) --->
<#--P01-->FH,<#rt><#--Record Type Code (FH)-->
<#--P02-->,<#rt><#--Importing Client ID NOT USED (AN10)-->
<#--P03-->${pfa.custrecord_2663_file_creation_timestamp?string("yyyyMMdd")},<#rt><#--File Creation Date (yyyyMMdd)-->
<#--P04-->${pfa.custrecord_2663_file_creation_timestamp?string("HHmmss")},<#rt><#--File Creation Time (HHmmss)--><#rt>
<#--P05-->01100<#rt><#--Format Version 11.00-->
${"\r"}<#--Line Break-->
<#--- Transaction Record (TR) --->
<#assign totalPayments = 0>
<#assign recordCount = 0>
<#assign entryHash = 0>
<#list payments as payment>
    <#assign ebank = ebanks[payment_index]>
    <#assign entity = entities[payment_index]>
    <#assign payAmount = formatAmount(getAmount(payment))>
    <#assign totalPayments = totalPayments + 1>
    <#assign recordCount = recordCount + 1>
    <#assign paidTransactions = transHash[payment.internalid]>
<#--P01-->TR,<#rt><#--Record Type Code (TR)-->
<#--P02-->${payment.memo?replace("/","_")},<#rt><#--Customer defined reference number. Bill Payment Memo ex. 00000001_1-->
<#--P03-->${pfa.custrecord_2663_process_date?string("yyyyMMdd")},<#rt><#--Value Date (yyyyMMdd)-->
<#--P04-->CA,<#rt><#--Destination Country Code-->
<#--P05-->,<#rt><#--Reserved-->
<#--P06-->${ebank.custrecord_2663_entity_bank_code},<#rt><#--Destination Bank ID. 099999999 Bank + Branch Transit-->
<#--P07-->${setPadding(ebank.custrecord_2663_entity_acct_no,"left","0",12)},<#rt><#--Destination Account Number-->
<#--P08-->,<#rt><#--Reserved-->
<#--P09-->${setPadding(payAmount,"left","0",10)},<#rt><#--Transaction Amount-->
<#--P10-->${getCurrencySymbol(payment.currency)},<#rt><#--Payment Currency USD or CAD-->
<#--P11-->GIR,<#rt><#--Payment Method. Always GIR-->
<#--P12-->01,<#rt><#--Transaction Type 01: Direct Credit-->
<#--P13-->,<#rt><#--Reserved-->
<#--P14-->${cbank.custpage_eft_custrecord_2663_acct_num},<#rt><#--Originator Account Number (AN10)-->
<#--P15-->,<#rt><#--Reserved-->
<#--P16-->,<#rt><#--Reserved-->
<#--P17-->${setMaxLength(buildEntityName(entity),30)},<#rt><#--Destination Account Name (Beneficiary). (Max Length 30)-->
<#--P18-->,<#rt><#--Reserved-->
<#--P19-->,<#rt><#--Reserved-->
<#--P20-->,<#rt><#--Reserved-->
<#--P21-->,<#rt><#--Reserved-->
<#--P22-->,<#rt><#--Reserved-->
<#--P23-->,<#rt><#--Reserved-->
<#--P24-->,<#rt><#--Reserved-->
<#--P25-->,<#rt><#--Reserved-->
<#--P26-->,<#rt><#--Reserved-->
<#--P27-->,<#rt><#--Reserved-->
<#--P28-->${payment.memo?replace("/","_")},<#rt><#--Sender's Text 1. Payment Details Line 1 (AN15). Optional-->
<#--P29-P41-->,,,,,,,,,,,,,<#rt><#--Reserved Field 29 to 41 -->
<#--P42-->452,<#rt><#--Canadian Payment Association Transaction Code (Code 452 - Expense Payment)-->
<#--P43-P54-->,,,,,,,,,,,<#rt><#--Reserved Field 43 to 54, Field 54 is the last field no comma -->
${"\r"}<#--Line Break--><#rt>
</#list>
<#--- File Trailer Record (FT) --->
<#--P01-->FT,<#rt><#--Record Type Code (9)-->
<#--P02-->${recordCount},<#rt><#--Number of transactions in file-->
<#--P03-->${recordCount + 2},<#rt><#--Number of lines in file, including FH and FT-->
<#--P04-->${formatAmount(computeTotalAmount(payments),"dec")}<#rt><#--Total payment amount in file-->
#OUTPUT END#
