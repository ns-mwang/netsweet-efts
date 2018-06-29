<html xmlns="http://www.w3.org/1999/xhtml"><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title></title>
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<style type="text/css">table {
				<#if .locale == "zh_CN">
				  font-family: stsong, sans-serif;
        <#elseif .locale == "zh_TW">
          font-family: msung, sans-serif;
        <#elseif .locale == "ja_JP">
          font-family: heiseimin, sans-serif;
        <#elseif .locale == "ko_KR">
          font-family: hygothic, sans-serif;
        <#elseif .locale == "ru_RU">
          font-family: verdana;
        <#else>
          font-family: sans-serif;
        </#if>
				font-size: 9pt;
				margin-top: 10px;
				table-layout: fixed;
				width: 100%;
			}
			th {
				font-size: 8pt;
				vertical-align: middle;
				padding-right: 6px;
				padding-left: 6px;
				padding-bottom: 3px;
				padding-top: 5px;
				background-color: #542678;
				color: #ffffff;
			}
			td {
				padding-right: 6px;
				padding-left: 6px;
				padding-bottom: 4px;
				padding-top: 4px;
			}
			b {
				font-weight: bold;
				color: #333333;
			}
			table.header td {
				padding: 0px;
				font-size: 10pt;
			}
			table.footer td {
				padding: 0px;
				font-size: 8pt;
			}
			table.itemtable th {
				padding-bottom: 10px;
				padding-top: 10px;
			}
			table.body td {
				padding-top: 2px;
			}
			table.total {
				page-break-inside: avoid;
			}
			tr.totalrow {
				background-color: #e3e3e3;
				line-height: 200%;
			}
			td.totalboxtop {
				font-size: 12pt;
				background-color: #e3e3e3;
			}
			td.addressheader {
				font-size: 8pt;
				padding-top: 6px;
				padding-bottom: 2px;
			}
			td.address {
				padding-top: 0px;
			}
			td.totalboxmid {
				font-size: 28pt;
				padding-top: 20px;
				background-color: #e3e3e3;
			}
			td.totalboxbot {
				background-color: #e3e3e3;
				font-weight: bold;
			}
			span.title {
				font-size: 28pt;
			}
			span.number {
				font-size: 16pt;
			}
			span.itemname {
				font-weight: bold;
				line-height: 150%;
			}
			hr {
				width: 100%;
				color: #d3d3d3;
				background-color: #d3d3d3;
				height: 1px;
			}
</style>
</head>
<div><#assign aDateTime = .now><#assign aDateTime = aDateTime?string("MMMM dd, yyyy")>
<p>${aDateTime}</p>
<br />
<#if contact??>Dear ${contact.salutation} <b>${contact.firstname} ${contact.middlename} ${contact.lastname}</b>,<br />
<#else> <#if customer.isperson == "T"> Dear ${customer.salutation} <b>${customer.firstname} ${customer.middlename} ${customer.lastname}</b>,<br />
<#else> Dear <b>${customer.companyname}</b>,<br />
</#if> </#if>
<p>This is a friendly reminder that the following invoice(s) are now past due:</p>
<span> <#if invoicelist?has_content> </span>

<table class="body">
<tbody>
	<tr>
	<th><span>Invoice #</span></th>
	<th><span>Invoice Date</span></th>
	<th><span>Due Date</span></th>
	<th><span>Days Late</span></th>
	<th><span>Advertiser</span></th>
	<th><span>Capaign Name</span></th>
	<th><span>IO Number</span></th>
	<th><span>Invoice Amount</span></th>
	<th><span>Open Balance</span></th>
	</tr>
	<#assign invoiceTotal = 0><#assign openBalance = 0><#list invoicelist as invoice><#assign invoiceTotal = invoiceTotal + invoice.fxamount?string.number><#assign openBalanceTotal = openBalanceTotal + invoice.fxamountremaining?string.number>
	<tr>
	<td><span>${invoice.tranid}<#if invoice.custbody_3805_dunning_procedure != "">*</#if></span></td>
	<td><span>${invoice.trandate}</span></td>
	<td><span>${invoice.duedate}</span></td>
	<td><span>${invoice.daysoverdue}</span></td>
	<td><span>${invoice.custbody_advertiser}</span></td>
	<!-- Advertiser -->
	<td><span>${invoice.custbody1}</span></td>
	<!-- Campaign Name -->
	<td><span>${invoice.custbody6}</span></td>
	<!-- IO Number -->
	<td align="right"><span>${invoice.fxamount?string.number}</span></td>
	<td align="right"><span>${invoice.fxamountremaining?string.number}</span></td>
	</tr>
	</#list>
</tbody>
</table>
<span> <#elseif invoice??> <!-- for invoice dunning --> </span>

<table class="body">
<tbody>
	<tr>
	<th><span>Invoice #</span></th>
	<th><span>Invoice Date</span></th>
	<th><span>Due Date</span></th>
	<th><span>Days Late</span></th>
	<th><span>Advertiser</span></th>
	<th><span>Capaign Name</span></th>
	<th><span>IO Number</span></th>
	<th><span>Invoice Amount</span></th>
	<th><span>Open Balance</span></th>
	</tr>
	<#assign invoiceTotal = 0><#assign openBalance = 0><#assign invoiceTotal = invoiceTotal + invoice.fxamount?string.number><#assign openBalanceTotal = openBalanceTotal + invoice.fxamountremaining?string.number>
	<tr>
	<td><span>${invoice.tranid}<#if invoice.custbody_3805_dunning_procedure != "">*</#if></span></td>
	<td><span>${invoice.trandate}</span></td>
	<td><span>${invoice.duedate}</span></td>
	<td><span>${invoice.daysoverdue}</span></td>
	<td><span>${invoice.custbody_advertiser}</span></td>
	<!-- Advertiser -->
	<td><span>${invoice.custbody1}</span></td>
	<!-- Campaign Name -->
	<td><span>${invoice.custbody6}</span></td>
	<!-- IO Number -->
	<td align="right"><span>${invoice.amount?string.number}</span></td>
	<td align="right"><span>${invoice.amountremaining?string.number}</span></td>
	</tr>
</tbody>
</table>

<table class="total">
<tbody>
	<tr>
	<td><span><b>Total</b></span></td>
	<td align="right"><span>${invoiceTotal}</span></td>
	<td align="right"><span>${openBalanceTotal}</span></td>
	</tr>
</tbody>
</table>
</#if>

<p>We would greatly appreciate it if you would respond to this email and confirm receipt of this invoice(s), as well as provide an update regarding payment status. If payment has already been sent, thank you very much, and please provide the check number and check date so we may update our records.</p>

<p>If you have any questions or need additional information, please feel free to respond to this email. Thank you in advance for your time and attention to this matter.</p>

<p>Kind Regards,<br />
&nbsp;</p>

<p>PlaceIQ</p>
</div>
</html>
