<?xml version="1.0"?><!DOCTYPE pdf PUBLIC "-//big.faceless.org//report" "report-1.1.dtd">
<pdf>
<head>
	<link name="NotoSans" type="font" subtype="truetype" src="${nsfont.NotoSans_Regular}" src-bold="${nsfont.NotoSans_Bold}" src-italic="${nsfont.NotoSans_Italic}" src-bolditalic="${nsfont.NotoSans_BoldItalic}" bytes="2" />
	<#if .locale == "zh_CN">
		<link name="NotoSansCJKsc" type="font" subtype="opentype" src="${nsfont.NotoSansCJKsc_Regular}" src-bold="${nsfont.NotoSansCJKsc_Bold}" bytes="2" />
	<#elseif .locale == "zh_TW">
		<link name="NotoSansCJKtc" type="font" subtype="opentype" src="${nsfont.NotoSansCJKtc_Regular}" src-bold="${nsfont.NotoSansCJKtc_Bold}" bytes="2" />
	<#elseif .locale == "ja_JP">
		<link name="NotoSansCJKjp" type="font" subtype="opentype" src="${nsfont.NotoSansCJKjp_Regular}" src-bold="${nsfont.NotoSansCJKjp_Bold}" bytes="2" />
	<#elseif .locale == "ko_KR">
		<link name="NotoSansCJKkr" type="font" subtype="opentype" src="${nsfont.NotoSansCJKkr_Regular}" src-bold="${nsfont.NotoSansCJKkr_Bold}" bytes="2" />
	<#elseif .locale == "th_TH">
		<link name="NotoSansThai" type="font" subtype="opentype" src="${nsfont.NotoSansThai_Regular}" src-bold="${nsfont.NotoSansThai_Bold}" bytes="2" />
	</#if>
    <macrolist>
        <macro id="nlheader"><img src="https://system.na2.netsuite.com/core/media/media.nl?id=7918&amp;c=4776752&amp;h=80993e94c7d36186963e&amp;whence=" style="width: 600px; height: 50px;" />
<table border="0" cellpadding="3" cellspacing="1" class="header" style="width:100%;"><tr>
	<td>&nbsp;</td>
	</tr>
  <tr>
    <td style="font-weight: bold; font-size: 10pt;">TAX INVOICE</td>
  </tr>
    <tr>
     <td colspan="2" align="left"><span style="text-align: left; font-size:12px; font-family:times new roman,times,serif;">${record.custbody_subsidiary_address}</span></td>
      <td align="right"><span style="text-align: right; font-family:times new roman,times,serif; font-size:12px;"><#setting date_format = "MMMM dd, yyyy">${record.trandate}</span></td>
    </tr>
    <tr>
      <td colspan="3" align="right"><span style="text-align: right; font-family:times new roman,times,serif; font-size:12px;">Invoice #: ${record.tranid}</span></td>
	</tr>
</table>
        </macro>
        <macro id="nlfooter">
            <p><img src="https://system.na2.netsuite.com/core/media/media.nl?id=7919&amp;c=4776752&amp;h=d8bcc6ed1f5aa0ea0aff&amp;whence=" style="width: 600px; height: 50px;" /></p>
        </macro>
    </macrolist>
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
            <!-- table-layout: fixed; -->
        }
        th {
            font-weight: bold;
            font-size: 8pt;
            vertical-align: middle;
            padding: 5px 6px 3px;
            background-color: #e3e3e3;
            color: #333333;
        }
        td {
            padding: 4px 6px;
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
<body header="nlheader" header-height="15%" footer="nlfooter" footer-height="20pt" padding="0.5in 0.75in 0.5in 1in" size="Letter">
    <table border="0" style="width: 100%; margin-top: 10px;">
      <tr><td>&nbsp;</td></tr>
      <tr><td>&nbsp;</td></tr>
      <tr><td>&nbsp;</td></tr>
    <tr>
	<td class="addressheader" colspan="3"><span style="font-size:12px;"><span style="font-family:times new roman,times,serif;">${record.billaddress@label}</span></span>:</td>
	</tr>
	<tr>
	<td class="address" colspan="3" rowspan="2"><span style="font-size:12px;"><span style="font-family:times new roman,times,serif;">${record.billaddress}</span></span><br /><span style="font-size:12px;"><span style="font-family:times new roman,times,serif;">Attn: ${record.custbody5}</span></span></td>
	</tr></table>

<hr />
<table class="body" style="width: 100%; margin-top: 10px;"><tr>
	<td><span style="font-size:12px; font-family:times new roman,times,serif; font-weight: bold;">${record.memo} ${record.otherrefnum}</span></td>
	</tr></table>
<#if record.item?has_content>

<table class="itemtable" style="width: 100%; margin-top: 10px;"><!-- start items --><#list record.item as item><#if item_index==0>
<thead>
	<tr>
	<th colspan="12"><span style="font-size:12px;"><span style="font-family:times new roman,times,serif;">${item.item@label}</span></span></th>
	<th align="right" colspan="4"><span style="font-size:12px;"><span style="font-family:times new roman,times,serif;">${item.amount@label}</span></span></th>
	</tr>
</thead>
</#if><tr>
	<td colspan="12"><span style="font-size:12px;"><span style="font-family:times new roman,times,serif;">${item.description}</span></span></td>
	<td align="right" colspan="4"><span style="font-size:12px;"><span style="font-family:times new roman,times,serif;">${item.amount}</span></span></td>
	</tr>
	</#list><!-- end items --></table>
&nbsp;

<hr /></#if>
<table class="total" style="width: 100%; margin-top: 10px;">
    <tr>
	<td colspan="4" align="right"><span style="font-size:12px;"><span style="font-family:times new roman,times,serif;"><b>SUB TOTAL</b> ${record.subtotal}</span></span></td>
  </tr>
  <tr>
	<td colspan="4" align="right"><span style="font-size:12px;"><span style="font-family:times new roman,times,serif;"><b>GST</b> ${record.taxtotal}</span></span></td>
  </tr>
  <tr class="totalrow">
	<td colspan="4" align="right"><span style="font-size:12px;"><span style="font-family:times new roman,times,serif;"><b>TOTAL</b> ${record.total}</span></span></td>
	</tr></table>
&nbsp;

<table cellpadding="1" cellspacing="1" style="width:500px;"><tr>
	<td><span style="background-color: rgb(255, 255, 255);"><span style="font-family: &quot;times new roman&quot;, times, serif;"><strong>Terms: </strong>&nbsp;</span></span><span style="font-size:12px;"><span style="font-family:times new roman,times,serif;">Our terms require payment 7 days from date of invoice.</span></span></td>
	</tr>
	<tr>
	<td><span style="font-family:times new roman,times,serif;">Email remittance to <strong>accounts@morrowsodali.com</strong></span></td>
	</tr>
  <tr>
    <td><span style="font-family:times new roman,times,serif;">Please remit payment directly to our account and include payment ref.<br /><br /></span></td>
  </tr>
    <tr>
    <td><span style="font-family:times new roman,times,serif;">${record.custbody9}</span></td>
  </tr>
        <tr>
    <td><span style="font-family:times new roman,times,serif;"><strong>Inv. Ref: </strong>${record.tranid}</span></td>
  </tr>
  </table>
</body>
</pdf>
