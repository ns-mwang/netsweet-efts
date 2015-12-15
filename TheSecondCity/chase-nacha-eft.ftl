<#--Author: Michael Wang | mwang@netsuite.com-->
<#--Chase Nacha Format: CCS Application; Transaction Type CCD-->
<#-- cached values -->
<#assign totalAmount = formatAmount(computeTotalAmount(payments),"dec")>
<#-- template building -->
#OUTPUT START#
<#--- Filed Header Record (1) --->
<#--P01-->1<#rt><#--Record Type Code (1)-->
<#--P02-->01<#rt><#--Priority Code-->
<#--P03--> 021000021<#rt><#--Immediate Destination b021000021 (b = blank)-->
<#--P04-->0000000000<#rt><#--Imedediate Origin (Assigned by JPMC)-->
<#--P05-->${pfa.custrecord_2663_file_creation_timestamp?string("yyMMdd")}<#rt><#--File Creation Date (yyMMdd)-->
<#--P06-->${pfa.custrecord_2663_file_creation_timestamp?string("HHmm")}<#rt><#--File Creation Time (HHmm)-->
<#--P07-->A<#rt><#--File ID Modifier-->
<#--P08-->094<#rt><#--Record Size-->
<#--P09-->10<#rt><#--Blocking Factor-->
<#--P10-->1<#rt><#--Format Code-->
<#--P11-->${setLength("JPMORGAN CHASE",23)}<#rt><#--Immediate Destination Name-->
<#--P12-->${setLength(cbank.custrecord_2663_print_company_name,23)}<#rt><#--Immediate Origin Name (Company Name Long)-->
<#--P13-->${setLength(" ",8)}<#rt><#--Reference Code - Leave Blank-->
${"\r"}<#--Line Break-->
<#--- Batch Header Record (5) --->
<#--P01-->5<#rt><#--Record Type Code (5)-->
<#--P02-->200<#rt><#--Service Class Code-->
<#--P03-->${setLength(cbank.custrecord_2663_legal_name,16)}<#rt><#--Your Company Name (Short)-->
<#--P04-->${setLength(" ",20)}<#rt><#--Company Discretionary Data - Leave Blank (20)-->
<#--P05-->${setLength(cbank.custpage_eft_custrecord_2663_bank_comp_id,10)}<#--ACH Company Identification. Assigned by JPMC-->
<#--P06-->CCD<#rt><#--Standard Entry Class Code-->
<#--P07-->${setLength("SecondCity",10)}<#rt><#--Company Entry Description (Show's on receiving bank statement)-->
<#--P08-->${pfa.custrecord_2663_process_date?string("yyMMdd")}<#rt><#--Company Descriptive Date (Show's on receiving bank statement)-->
<#--P09-->${pfa.custrecord_2663_process_date?string("yyMMdd")}<#rt><#--Effective Entry Date (Show's on receiving bank statement)-->
<#--P10-->   <#rt><#--(3) Settlement Date (Left blank, JPMC to fill in automatically-->
<#--P11-->1<#rt><#--Originator Status Code = 1-->
<#--P12-->${cbank.custpage_eft_custrecord_2663_bank_num}<#rt><#--Originating Financial Institution, Chase Routing Number-->
<#--P13-->${setPadding(pfa.id,"left","0",7)}<#rt><#--Batch Number-->
${"\r"}<#--Line Break-->
<#--- Entry Detail Record (6) --->
<#assign totalPayments = 0>
<#assign recordCount = 0>
<#assign entryHash = 0>
<#list payments as payment>
    <#assign ebank = ebanks[payment_index]>
    <#assign entity = entities[payment_index]>
    <#assign payAmount = getAmount(payment)>
    <#assign totalPayments = totalPayments + 1>
    <#assign recordCount = recordCount + 1>
    <#assign paidTransactions = transHash[payment.internalid]>
    <#--Entry Hash Calculation sum(P5 to P11)-->
    <#assign P5 = ebank.custrecord_2663_entity_acct_no>
    <#assign p6 = formatAmount(payAmount)>
    <#assign p7 = ebank.custrecord_2663_entity_bank_code>
    <#assign p10 = 0>
    <#assign P11 = payment.tranid>
    <#assign entryHash = entryHash + P5 + P6 + P7 + P10 + P11>
    <#--Entry Hash Calculation End-->
<#--P01-->6<#rt><#--Record Type Code (6)-->
<#--P02-->27<#rt><#--Transaction Code (27: Checking Dollars)-->
<#--P03-->${ebank.custrecord_2663_entity_bank_no?substring(0, 7)}<#rt><#--Receiving DFI ID (Routing Number)-->
<#--P04-->${ebank.custrecord_2663_entity_bank_no?substring(8)}<#rt><#--Check Digit the 9th digit of routing number-->
<#--P05-->${setPadding(custrecord_2663_entity_acct_no,"right"," ",17)}<#rt><#--DFI Account Number-->
<#--P06-->${setPadding(formatAmount(payAmount),"left","0",10)}<#rt><#--Dollar Amount-->
<#--P07-->${setPadding(ebank.custrecord_2663_entity_bank_code,"right"," ",15)}<#rt><#--Individual Identification Number-->
<#--P08-->${setPadding(buildEntityName(entity),"right"," ",22)}<#rt><#--Individual Name-->
<#--P09-->${setLength(recordCount,2)}<#rt><#--Discretionary Data-->
<#--P10-->0<#rt><#--Addenda Record Indicatior (0:No 1:Yes)-->
<#--P11-->${setPadding(payment.tranid,"left","0",15)}<#rt><#--Trace Number-->
${"\r"}<#--Line Break--><#rt>
</#list>
<#--- Batch Control Record (8) --->
<#--P01-->8<#rt><#--Record Type Code (8)-->
<#--P02-->200<#rt><#--Service Class Code-->
<#--P03-->${recordCount}<#rt><#--Entry/Addenda Count-->
<#--P04-->${entryHash}<#rt><#--Entry Hash-->
<#--P05-->000000000000<#rt><#--Total Debit Entry Dollar Amount-->
<#--P06-->${setPadding(totalAmount,"left","0",12)}<#rt><#--Total Credit Entry Dollar Amount-->
<#--P07-->${cbank.custpage_eft_custrecord_2663_bank_comp_id}<#rt><#--Company Identification-->
<#--P08-->${setLength(" ",19)}<#rt><#--Message Authentication Code Leave Blank (19)-->
<#--P09-->${setLength(" ",6)}<#rt><#--Reserved Leave Blank (6)-->
<#--P10-->${cbank.custpage_eft_custrecord_2663_bank_num}<#rt><#--Originating Financial Institution, Chase Routing Number 8 digits without check digit-->
<#--P11-->${setPadding(pfa.id,"left","0",7)}<#rt><#--Batch Number-->
${"\r"}<#--Line Break-->
<#--- File Control Record (9) --->
<#--Entry Hash Value sum of P4 to P11-->
<#--P01-->9<#rt><#--Record Type Code (9)-->
<#--P02-->1<#rt><#--Batch Count-->
<#--P03-->1<#rt><#--Block Count-->
<#--P04-->${setPadding(recordCount,"left","0",8)}<#rt><#--Entry/Addenda Count-->
<#--P05-->${setPadding(entryHash,"left","0",10)}<#rt><#--Entry Hash-->
<#--P06-->000000000000<#rt><#--Total Debit Entry Dollar Amount in File-->
<#--P07-->${setPadding(totalAmount,"left","0",12)}<#rt><#--Total Credit Entry Dollar Amount in File-->
<#--P08-->${setLength(" ",39)}<#rt><#--Leave Blank (39)-->
#OUTPUT END#