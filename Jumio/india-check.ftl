<?xml version="1.0"?><!DOCTYPE pdf PUBLIC "-//big.faceless.org//report" "report-1.1.dtd">
<pdf>
<head>
	<link name="NotoSans" type="font" subtype="truetype" src="${nsfont.NotoSans_Regular}" src-bold="${nsfont.NotoSans_Bold}" src-italic="${nsfont.NotoSans_Italic}" src-bolditalic="${nsfont.NotoSans_BoldItalic}" bytes="2" />
    <style type="text/css">* {
		<#if .locale == "zh_CN">
			font-family: NotoSans, NotoSansCJKsc, sans-serif;
		<#elseif .locale == "zh_TW">
			font-family: NotoSans, NotoSansCJKtc, sans-serif;
		<#elseif .locale == "ja_JP">
			font-family: NotoSans, NotoSansCJKjp, sans-serif;
		<#elseif .locale == "ko_KR">
			font-family: NotoSans, NotoSansCJKkr, sans-serif;
		<#elseif .locale == "th_TH">
			font-family: NotoSans, NotoSansThai, sans-serif;
		<#else>
			font-family: NotoSans, sans-serif;
		</#if>
		}
        .check table, .voucher1 table, .voucher2 table {
            position: relative;
            overflow: hidden;
            font-size: 8pt;
            padding: 0;
        }
		td p { align:left }
</style>
</head>
<body padding="0in 0in 0in 0in" size="Letter">
    <#list records as check>
<div style="position: relative;font-family: Helvetica,sans-serif;top= -11pt;height: 250pt;width: 612pt;page-break-inside: avoid;font-size: 8pt;">
<!-- <table style="position: absolute;overflow: hidden;left: 530pt;top: 3.5in;height: 7pt;width: 85pt;font-size: 12pt; letter-spacing: 2pt;"><tr>
	<td align="center">${check.checknumber}</td>
	</tr></table> -->

<table style="position: absolute;overflow: hidden;left: 6in;top: 6in;height: 18pt;width: 175pt;"><tr>
  <td>${check.trandate}</td>
  <td>**<#if (check.usertotal?length > 0)>${check.usertotal}<#else>${check.total}</#if></td>
	</tr></table>

<table style="position: absolute;overflow: hidden;left: 0.85in;top: 5.25in;height: 18pt;width: 572pt;"><tr>
	<td>${check.totalwords}*********************************************************************</td>
	</tr></table>

<table style="position: absolute;overflow: hidden;left: 0.85in;top: 6in;height: 18pt;width: 393pt;"><tr>
		<#if check.entity.printoncheckas?length !=0>
    	<td>${check.entity.printoncheckas}</td>
   		<#else>
     	<td>${check.entity}</td>
   		</#if>
        </tr>
  </table>

</div>
</#list>
</body>
</pdf>
