<?xml version="1.0"?><!DOCTYPE pdf PUBLIC "-//big.faceless.org//report" "report-1.1.dtd">
<#assign billcontact = record.custbody_cor_billing_contact>
<#assign createdfrom = record.createdfrom>
<pdfset>

<#if record.entity.custentity_order_management_system?contains("Search &amp; Watch")>

<pdf>

	<#if record.entity.custentity_cor_pdf_language == 'German'>
		<#setting locale="de_DE">
	<#elseif record.entity.custentity_cor_pdf_language == 'French'>
		<#setting locale="fr_FR">
	<#elseif record.entity.custentity_cor_pdf_language == 'Dutch'>
		<#setting locale="nl_NL">
	</#if>

	<head>

		<macrolist>
			<macro id="cs-cover-header">
				<table class="cs-header" style="width: 100%;">
					<tr>
						<td colspan="2">

							<#if record.entity.subsidiary?contains('Citizen')>
								<img class="comp-logo" src="https://system.netsuite.com/core/media/media.nl?id=923&amp;c=4322318_SB1&amp;h=62a0d0dcdf4c4723d31b" />
							<#else>
								<img class="comp-logo" src="https://system.netsuite.com/core/media/media.nl?id=400&amp;c=4322318_SB1&amp;h=429e3d8096829346bfdd" />
							</#if>
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td align="right" class="cover-font"><blockquote><b>${record.shipaddress}</b><br /><br /><b>${createdfrom.trandate?string.long}</b></blockquote></td>
					</tr>
				</table>
			</macro>

			<macro id="cs-cover-footer">
	            <table class="footer" style="width: 100%;">

	            	<tr>
	            		<td  colspan="2" class="footerinfo">${record.custbody_cs_coverletter.custrecord_cs_footer_info}</td>
	            	</tr>

				</table>
        	</macro>

		</macrolist>

		<style type="text/css">

			* {
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

		hr {
			border:1px solid #12946d;
			width: 100%;
		}



		body {
			font-family: 'Open Sans', sans-serif;
		}


		table {
			font-size: 12px;
			table-layout: fixed;
		}
        th {
            font-weight: bold;
            font-size: 12px;
            vertical-align: middle;
            padding: 5px 6px 3px;
            background-color: #fff;
            color: #333333;
        }

        td.recordTitle {
        	padding: 0 0 15px;

        }


        td {
            padding: 4px 6px;
        }
		td p { align:left }
        b {
            font-weight: bold;
            color: #333333;
        }
        table.header td {
            padding: 0;
            font-size: 10px;
        }

        td.recordTitle span {
        	font-size: 24px;
        	font-weight: bold;
        }
        table.footer td {
            padding: 5px;
            font-size: 12px;
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
            font-size: 12px;
            background-color: #e3e3e3;
        }
        td.addressheader {
            font-size: 12px;
            padding-top: 6px;
            padding-bottom: 2px;
        }
        td.address {
            padding-top: 0px;
        }
        td.totalboxmid {
            font-size: 12px;
            padding-top: 20px;
            background-color: #e3e3e3;
        }
        td.totalboxbot {
            background-color: #e3e3e3;
            font-weight: bold;
        }
        span.title {
            font-size: 12px;
        }
        span.number {
            font-size: 12px;
        }
        span.itemname {
            font-weight: bold;
            line-height: 150%;
        }

        td.recordLabels {

        }

        p.labeled {

        	font-weight: bold;
        	margin: 0 0 2px;
        }

        p.labeled span {
        	width: 200px;
        	padding-right: 7px;
        }

        .test .header {
        	display: none;
        }

        .bold {
        	font-weight: bold;
        }

        tr.headerlabel th {
        font-size: 9px;
        }

        tr.datascreen td {
        font-size: 10px;
        }

        tr.sectionHeader {

        }

        tr.sectionHeader th {
        	text-align: center;
        }

        span.capitalize {
        	text-transform: uppercase;
        }

        td.footerinfo {
        	font-size: 10px;
        }

        table.itemtable {

        }

			body {
				font-faimly: NotoSans, sans-serif;;
			}

			hr {
				border:1px solid #12946d;
				width: 100%;
			}

			td.cover-font {
				font-size: 12px;
			}

        	table.footer td {
            padding: 5px;
            font-size: 12px;
        }



		</style>
	</head>


	<body header="cs-cover-header" header-height="20%"  footer="cs-cover-footer" footer-height="10%" padding="0.5in 0.5in 0.5in 0.5in" size="A4">

		<hr />

      <table style="width: 100%; margin-top: 0;">
      	<tr>
      		<td>N/Ref: ${record.custbody_cor_tran_id_ref_num}</td>
      	</tr>
      	<tr>
      		<td><br /><br /></td>
      	</tr>
      	<tr>
      		<td>
      			${record.custbody_cs_coverletter.custrecord_cs_coverletter}
      		</td>
      	</tr>
      	<tr>
      		<td>
      			<!-- <h1>${record.taxtotal}</h1> -->
      		</td>
      	</tr>
      </table>



    </body>
</pdf>


</#if>

<!-- START OF THE LANGUAGE CONDITION -->

<#if record.entity.custentity_cor_pdf_language == 'German'>

<#setting locale='de_DE'>

	<!-- GERMAN LANGUAGE INVOICE: start of document -->
<pdf>
<head>

    <macrolist>
        <macro id="nlheader">


            <table class="header" style="width: 100%;">
            	<tr>
					<td colspan="2">

						<img class="comp-logo" src="https://system.netsuite.com/core/media/media.nl?id=400&amp;c=4322318_SB1&amp;h=429e3d8096829346bfdd" />

					</td>
					<td class="recordTitle" align="right" valign="bottom"><span>Rechnung</span></td>
				</tr>
				<tr>
					<td colspan="3"><br /><br /><br /></td>
				</tr>


				<tr>
					<td class="recordLabels" align="left">
						<p class="labeled"><span>Rechnungsnummer:</span>${record.tranid}</p>
						<p class="labeled"><span>Rechnungsdatum:</span>${record.trandate?string.long}</p>
						<p class="labeled"><span>Auftragsnummer:</span>${createdfrom.tranid}</p>
						<p class="labeled"><span>Auftragsdatum:</span>${createdfrom.trandate?string.long}</p>
					</td>
					<td>
						<p class="labeled"><span>Kunden-Referenznummer - 1: </span>${record.custbody_cor_matter_number}</p>
                      
						<p class="labeled"><span>Angefordert von: </span>${billcontact.firstname}&nbsp;${billcontact.lastname}</p>
					</td>
					<td align="right" valign="top">
						<p class="bold"><span class="nameandaddress">${record.billaddress}<#if record.vatregnum?has_content><br />Ihr - IdNr.: ${record.vatregnum}</#if></span></p>
					</td>

				</tr>

			</table>


        </macro>
        <macro id="nlfooter">
            <table class="footer" style="width: 100%;">
				<tr>
                  <td colspan="7" class="footerinfo"><p>Bitte beachten Sie, dass sich unser Rechnungsformat geändert hat. Besuchen Sie <a href="https://www.corsearch.com/billingfaq">https://www.corsearch.com/billingfaq</a> für weitere Informationen.</p></td>
                </tr>
            	<tr>
	            	<td  colspan="7" class="footerinfo">${record.custbody_cs_coverletter.custrecord_cs_footer_info}</td>
                  	<td align="right" valign="bottom"><pagenumber/> von  <totalpages/></td>
	            </tr>
			</table>


        </macro>
    </macrolist>

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

		hr {
			border:1px solid #12946d;
			width: 100%;
		}



		body {
			font-family: 'Open Sans', sans-serif;
		}


		table {
			font-size: 12px;
			table-layout: fixed;
		}
        th {
            font-weight: bold;
            font-size: 12px;
            vertical-align: middle;
            padding: 5px 6px 3px;
            background-color: #fff;
            color: #333333;
        }

        td.recordTitle {
        	padding: 0 0 15px;

        }


        td {
            padding: 4px 6px;
        }
		td p { align:left }
        b {
            font-weight: bold;
            color: #333333;
        }
        table.header td {
            padding: 0;
            font-size: 10px;
        }

        td.recordTitle span {
        	font-size: 24px;
        	font-weight: bold;
        }
        table.footer td {
            padding: 5px;
            font-size: 12px;
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
            font-size: 12px;
            background-color: #e3e3e3;
        }
        td.addressheader {
            font-size: 12px;
            padding-top: 6px;
            padding-bottom: 2px;
        }
        td.address {
            padding-top: 0px;
        }
        td.totalboxmid {
            font-size: 12px;
            padding-top: 20px;
            background-color: #e3e3e3;
        }
        td.totalboxbot {
            background-color: #e3e3e3;
            font-weight: bold;
        }
        span.title {
            font-size: 12px;
        }
        span.number {
            font-size: 12px;
        }
        span.itemname {
            font-weight: bold;
            line-height: 150%;
        }

        td.recordLabels {

        }

        p.labeled {

        	font-weight: bold;
        	margin: 0 0 2px;
        }

        p.labeled span {
        	width: 200px;
        	padding-right: 7px;
        }

        .test .header {
        	display: none;
        }

        .bold {
        	font-weight: bold;
        }

        tr.headerlabel th {
        font-size: 9px;
        }

        tr.datascreen td {
        font-size: 10px;
        }

        tr.sectionHeader {

        }

        span.capitalize {
        	text-transform: uppercase;
        }

        td.footerinfo {
        	font-size: 10px;
        }

  		td.vatinfo {
  			font-size: 10px;
  		}


</style>
</head>

<body header="nlheader" header-height="20%" footer="nlfooter" footer-height="10%" padding="0.5in 0.5in 0.5in 0.5in" size="A4">

	<hr />

<#if record.item?has_content>

<table class="itemtable" style="width: 100%;">

<!-- start items -->
	<tr>
	  <td><span style="font-size: 12px"><b>Gesamtksoten</b></span></td>
      <td><span style="font-size: 12px"><b>Beschreibung</b></span></td>
      <td align="right"><span style="font-size: 12px"><b>Kosten</b></span></td>
	</tr>


	<#assign quantity = 0>
    <#assign subtotal = 0>
	<#list record.item as item>
		<#if item.itemtype != "Discount">
      <#assign itemid = item.item.id>
		  <#assign quantity = quantity + item.quantity>
      <#if item.custcol_cor_summary_desc?has_content>
		    <#assign description = item.custcol_cor_summary_desc>
      <#else>
        <#assign description = item.item>
      </#if>
      <#assign subtotal = subtotal + item.amount>
		</#if>
	</#list>

<!-- end items -->

	<tr>
		<td>
      		${quantity}
		</td>
		<td align="left">
			${description}
		</td>
		<td align="right">
			${record.custbody_cor_subtotal} ${record.currency}
		</td>
	</tr>
</table>

</#if>


<hr />

<table class="total" style="width: 100%; margin-top: 10px;">
	<tr>
		<td colspan="4"></td>
		<td colspan="3" style="border-bottom: 1px solid #12946d"></td>
	</tr>
	<tr>
		<td colspan="4">&nbsp;</td>
		<td align="right" colspan="2"><b>Zwischensumme</b></td>
		<td align="right">${record.custbody_cor_subtotal} ${record.currency}</td>
	</tr>
  
  	<tr>
		<td colspan="4">&nbsp;</td>
		<td align="right" colspan="2"><span><b>Nachlass</b></span></td>
		<td align="right">
			${record.custbody_cor_discount_total} ${record.currency}
		</td>
	</tr>
	<tr>
		<td colspan="4">&nbsp;</td>
		<td align="right" colspan="2"><b>Gesamtsteuerbetrag (${record.custbody_cor_tax_rate})</b></td>
		<td align="right">${record.taxtotal} ${record.currency}</td>
	</tr>

	<tr class="totalrow">
		<td background-color="#ffffff" colspan="4">&nbsp;</td>
		<td align="right" colspan="2"><span><b>Rechnungsbetrag</b></span></td>
		<td align="right">${record.custbody_cor_net_total} ${record.currency}</td>
	</tr>
	<tr>
		<td colspan="4"></td>
		<td colspan="3" style="border-top: 1px solid #12946d"></td>
	</tr>

	<#assign vatnum = record.taxtotal> <!-- If vatnum is greater than zero, there is VAT, therefore tax language is disaplayed. -->
	<#if vatnum gt 0>
    <tr>
        <td colspan="7" class="vatinfo">${record.custbody_cs_coverletter.custrecord_cs_vat_info}</td>
    </tr>
    <tr>
        <td colspan="7" class="vatinfo">${record.custbody_cs_coverletter.custrecord_cs_after_vat_info}</td>
    </tr>

	</#if><!-- end of tax language -->


	<tr>
		<td colspan="7" class="vatinfo">${record.custbody_cs_coverletter.custrecord_cs_remit_info}</td>
	</tr>
      <tr>
      <td colspan="7" class="vatinfo">Bitte bei Bezahlung angeben : ${record.custbody_cor_matter_number} / ${record.tranid}</td>
    </tr>

	<tr>
		<td colspan="7" style="height: 3em">&nbsp;</td>
	</tr>

	<#if record.custbody_cor_wire_transfer_info?has_content>

	<tr>
		<td colspan="7" style="height: 2em;"><span><b>Anweisungen für die Überweisung:</b></span></td>
	</tr>

	<tr>
		<td colspan="7" class="vatinfo">${record.custbody_cor_wire_transfer_info}</td>
	</tr>

	</#if>

</table>


<table style="width: 100%">
    <tr>
        <td>${record.custbody_cs_coverletter.custrecord_cs_message_near_footer}</td>
    </tr>
</table>

<pbr size="A4"  />



<table class="itemtable" style="width: 100%; margin-top: 10px; border-top: 1px solid #12946d"><!-- start items -->

		<thead>

		<tr class="sectionHeader">
			<th>&nbsp;</th>
	</tr>
			<#if itemid == "48">
			<tr class="headerlabel">
				<th colspan="2" align="center">Screen<br />User</th>
				<th colspan="4" align="center">Client<br />Reference</th>
				<th colspan="4" align="center">Trademark</th>
				<th colspan="3" align="center">Database</th>
				<th colspan="3" align="center">Date</th>
				<th colspan="3" align="center">Advantage<br />Service</th>
				<th colspan="4" align="center">Records<br />Purchased</th>
				<th colspan="3" align="center"> Total Cost</th>
			</tr>
			</#if>

	<#assign lineitem = 0>

	<#list record.item as item>
		<#if item.custcol_integer_column != 244>
			<#assign lineitem = lineitem + 1>
		</#if>
		<#if item_index==0>


</thead>
	</#if>

	<#if item.custcol_integer_column == 48>

	<tr class="datascreen">
		<td colspan="2" align="center">${item.custcol_cor_scruser}</td>
		<td colspan="4" align="center">${item.custcol_cs_matter_number}</td>
		<td colspan="4" align="center">${item.custcol_cor_mark}</td>
		<td colspan="3" align="center">${item.custcol_cor_mark}</td>
		<td colspan="3" align="center">${item.custcol_cor_scrdate}</td>
		<td colspan="3" align="center">${item.class}</td>
		<td colspan="4" align="center">${item.quantity}</td>
		<td colspan="3" align="right">${item.amount} ${record.currency}</td>
	</tr>

	<#else>
	<tr>
		<td align="center" colspan="3" line-height="150%"><#if item.custcol_integer_column != 244>${lineitem}</#if></td>
		<#if item.custcol_integer_column == 244>
		<td colspan="12">
			<span class="itemname">${item.item}<br /></span>
		</td>
		<#else>
		<td colspan="12">
          	<#if item.custcol_cor_mark?has_content>
				<span class="itemname">${item.custcol_cor_mark}</span><br />
            </#if>
			<#if item.custcolcustcol_international_class?has_content>
				International Class: ${item.custcolcustcol_international_class}<br />
			</#if>
			<#if item.custcolcustcol_registers?has_content>
				${item.custcolcustcol_registers}<br />
			</#if>
			<#if item.description?has_content>
				${item.description}<br />
			</#if>
			<#if item.register?has_content>
				${item.register}<br />
			</#if>
			<#if item.custcol_cor_your_ref?has_content>
				${item.custcol_cor_your_ref}<br />
			</#if>
			<#if item.custcol_cor_product_type?has_content>
				${item.custcol_cor_product_type}<#if item.custcol_cor_turnaround?has_content> (${item.custcol_cor_turnaround})</#if><br />
            <#if item.class == "Screening" || item.class == "Watching">
            	Subscription Period: ${item.custcol_revenue_start_date} - ${item.custcol_revenue_end_date}
            </#if>
		  </#if>
		</td>
		</#if>
		<td colspan="3"></td>
		<td align="right" colspan="4"></td>
		<td align="right" colspan="4">${item.amount} ${record.currency}</td>
	</tr>
	</#if>
</#list><!-- end items -->
</table>

<table style="width: 100%">
	<tr>
		<td>${record.custrecord_cs_vat_info}</td>
	</tr>
</table>





<hr />





</body>
</pdf>

	<!-- GERMAN LANGUAGE INVOICE: end of document -->

<#elseif record.entity.custentity_cor_pdf_language == 'Dutch'>

	<!-- DUTCH LANGUAGE INVOICE: start of document -->

<pdf>
<head>

    <macrolist>
        <macro id="nlheader">


            <table class="header" style="width: 100%;">
            	<tr>
					<td colspan="2">
						<#if record.entity.subsidiary?contains('Citizen')>
							<img class="comp-logo" src="https://system.netsuite.com/core/media/media.nl?id=923&amp;c=4322318_SB1&amp;h=62a0d0dcdf4c4723d31b" />
						<#else>
							<img class="comp-logo" src="https://system.netsuite.com/core/media/media.nl?id=400&amp;c=4322318_SB1&amp;h=429e3d8096829346bfdd" />
						</#if>
					</td>
					<td class="recordTitle" align="right" valign="bottom"><span>Factuur</span></td>
				</tr>
				<tr>
					<td colspan="3"><br /><br /><br /></td>
				</tr>


				<tr>
					<td class="recordLabels" align="left">
						<p class="labeled"><span>Factuur nummer:</span>${record.tranid}</p>
						<p class="labeled"><span>Factuur datum:</span>${record.trandate?string.long}</p>
						<p class="labeled"><span>Bestelnummer:</span>${createdfrom.tranid}</p>
						<p class="labeled"><span>Besteldatum:</span>${createdfrom.trandate?string.long}</p>
					</td>
					<td>
						<p class="labeled"><span>Referentie klant (1): </span>${record.custbody_cor_matter_number}</p>
						<p class="labeled"><span>Aangevraagd door: </span>${billcontact.firstname}&nbsp;${billcontact.lastname}</p>
					</td>
					<td align="right">
						<p class="bold"><span class="nameandaddress">${record.billaddress}<#if record.vatregnum?has_content><br />U/BTW: ${record.vatregnum}</#if></span></p>
					</td>

				</tr>

			</table>


        </macro>
        <macro id="nlfooter">
            <table class="footer" style="width: 100%;">
				<tr>
                  <td colspan="7"><p>
                    Gelieve te noteren dat ons factuurformaat gewijzigd werd.  Ga naar <a href="https://www.corsearch.com/billingfaq">https://www.corsearch.com/billingfaq</a> voor meer informatie.
                    </p>
                  </td>
              </tr>
            	<tr>
	            	<td  colspan="2" class="footerinfo">${record.custbody_cs_coverletter.custrecord_cs_footer_info}</td>
	            </tr>
            	<tr>
            		<td colspan="2" class="footerinfo">${record.custbody_info_related_company}</td>
            	</tr>
            	<tr>
					<td>&nbsp;</td>
					<td align="right"><pagenumber/> van  <totalpages/></td>
				</tr>
			</table>


        </macro>
    </macrolist>

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

		hr {
			border:1px solid #12946d;
			width: 100%;
		}



		body {
			font-family: 'Open Sans', sans-serif;
		}


		table {
			font-size: 12px;
			table-layout: fixed;
		}
        th {
            font-weight: bold;
            font-size: 12px;
            vertical-align: middle;
            padding: 5px 6px 3px;
            background-color: #fff;
            color: #333333;
        }

        td.recordTitle {
        	padding: 0 0 15px;

        }


        td {
            padding: 4px 6px;
        }
		td p { align:left }
        b {
            font-weight: bold;
            color: #333333;
        }
        table.header td {
            padding: 0;
            font-size: 10px;
        }

        td.recordTitle span {
        	font-size: 24px;
        	font-weight: bold;
        }
        table.footer td {
            padding: 5px;
            font-size: 12px;
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
            font-size: 12px;
            background-color: #e3e3e3;
        }
        td.addressheader {
            font-size: 12px;
            padding-top: 6px;
            padding-bottom: 2px;
        }
        td.address {
            padding-top: 0px;
        }
        td.totalboxmid {
            font-size: 12px;
            padding-top: 20px;
            background-color: #e3e3e3;
        }
        td.totalboxbot {
            background-color: #e3e3e3;
            font-weight: bold;
        }
        span.title {
            font-size: 12px;
        }
        span.number {
            font-size: 12px;
        }
        span.itemname {
            font-weight: bold;
            line-height: 150%;
        }

        td.recordLabels {

        }

        p.labeled {

        	font-weight: bold;
        	margin: 0 0 2px;
        }

        p.labeled span {
        	width: 200px;
        	padding-right: 7px;
        }

        .test .header {
        	display: none;
        }

        .bold {
        	font-weight: bold;
        }

        tr.headerlabel th {
        font-size: 9px;
        }

        tr.datascreen td {
        font-size: 10px;
        }

        tr.sectionHeader {

        }

        span.capitalize {
        	text-transform: uppercase;
        }


			td.footerinfo {
        		font-size: 10px;
        	}



</style>
</head>

<body header="nlheader" header-height="20%" footer="nlfooter" footer-height="10%" padding="0.5in 0.5in 0.5in 0.5in" size="A4">

	<hr />

<#if record.item?has_content>

<table class="itemtable" style="width: 100%;">

<!-- start items -->
	<tr>
		<td><span style="font-size: 12px"><b>Totale kosten</b></span></td>
    	<td><span style="font-size: 12px"><b>Beschrijving</b></span></td>
    	<td align="right"><span style="font-size: 12px"><b>Kosten</b></span></td>
	</tr>

	<#assign quantity = 0>
  	<#assign subtotal = 0>

	<#list record.item as item>
		<#if item.itemtype != "Discount">
      <#assign itemid = item.item.id>
		  <#assign quantity = quantity + item.quantity>
      <#if item.custcol_cor_summary_desc?has_content>
		    <#assign description = item.custcol_cor_summary_desc>
      <#else>
        <#assign description = item.item>
      </#if>
      <#assign subtotal = subtotal + item.amount>
		</#if>
	</#list>
	<tr>
		<td>${quantity}</td>
		<td align="left">${description}</td>
		<td align="right">${record.custbody_cor_subtotal} ${record.currency}</td>
	</tr>
</table>

</#if>


<hr />

<table class="total" style="width: 100%; margin-top: 10px;">
	<tr>
		<td colspan="4"></td>
		<td colspan="3" style="border-bottom: 1px solid #12946d"></td>
	</tr>
	<tr>
		<td colspan="4">&nbsp;</td>
		<td align="right" colspan="2"><span><b>Subtotaal</b></span></td>
		<td align="right">${record.custbody_cor_subtotal} ${record.currency}</td>
	</tr>
  
	<tr>
		<td colspan="4">&nbsp;</td>
		<td align="right" colspan="2"><span><b>Korting</b></span></td>
		<td align="right">
			${record.custbody_cor_discount_total} ${record.currency}
		</td>
	</tr>

	<tr>
		<td colspan="4">&nbsp;</td>
		<td align="right" colspan="2"><b>Totaal excl. BTW (${record.custbody_cor_tax_rate})</b></td>
		<td align="right">${record.taxtotal} ${record.currency}</td>
	</tr>
	<tr class="totalrow">
		<td background-color="#ffffff" colspan="4">&nbsp;</td>
		<td align="right" colspan="2"><span><b>Totaal</b></span></td>
		<td align="right">${record.custbody_cor_net_total} ${record.currency}</td>
	</tr>
	<tr>
		<td colspan="4"></td>
		<td colspan="3" style="border-top: 1px solid #12946d"></td>
	</tr>

	<tr>
		<td colspan="7" style="height: 3em">&nbsp;</td>
	</tr>

	<#assign vatnum = record.taxtotal>
	<#if vatnum gt 0>
    <tr>
        <td colspan="7" class="vatinfo">${record.custbody_cs_coverletter.custrecord_cs_vat_info}</td>
    </tr>
    <tr>
        <td colspan="7" class="vatinfo">${record.custbody_cs_coverletter.custrecord_cs_after_vat_info}</td>
    </tr>
    <tr>
		<td colspan="7" style="height: 3em">&nbsp;</td>
	</tr>
	</#if>

	<tr>
		<td colspan="7">${record.custbody_cs_coverletter.custrecord_cs_remit_info}</td>
	</tr>

	<tr>
		<td colspan="7" style="height: 3em">&nbsp;</td>
	</tr>

	<#if record.custbody_cor_wire_transfer_info?has_content>

	<tr>
		<td colspan="7" style="height: 2em;"><span><b>Instructies voor de overdracht:</b></span></td>
	</tr>

	<#if record.entity.subsidiary?contains('Luxem') && record.entity.country?contains('Belgium') && record.entity.language?contains('English')>
	<tr>
		<td colspan="2">&nbsp;</td>
		<td colspan="3">
			<p>Account: 310-1039354-85</p>
		</td>
		<td colspan="2">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td>
		<td valign="right">Bank:</td>
		<td colspan="2"><p style="align: left"> ING Business Branch Marnix<br />
                  Rue du Trône, 1<br />
                   1000 Bruxelles</p></td>
		<td colspan="2">&nbsp;</td>
	</tr>
	<#elseif record.entity.subsidiary?contains('Luxem') && record.entity.country != "Belgium" && record.entity.language?contains('English')>
	<tr>
		<td colspan="2">&nbsp;</td>
		<td valign="right">Bank:</td>
		<td colspan="2"><p style="align: left"> ING Business Branch Marnix<br />
                  IBAN: BE89 310 1039354 85<br />
                  BIC / Swift Code: BBRUBEBB</p></td>
		<td colspan="2">&nbsp;</td>
	</tr>
	<#else>
		<tr>
		<td>
			&nbsp;
		</td>
	</tr>
	</#if>


	<tr>
		<td colspan="7">${record.custbody_cor_wire_transfer_info}</td>
	</tr>
	</#if>
  <tr>
      <td colspan="7" class="vatinfo">
    Gelieve volgende referentie te gebruiken : ${record.custbody_cor_matter_number} / ${record.tranid}
      </td>
  </tr>

</table>

<table style="width: 100%">
    <tr>
        <td>${record.custbody_cs_coverletter.custrecord_cs_message_near_footer}</td>
    </tr>
</table>

<pbr size="A4"  />


	<table class="itemtable" style="width: 100%; margin-top: 10px; border-top: 1px solid #12946d"><!-- start items -->

		<thead>

		<tr class="sectionHeader">
			<th>&nbsp;</th>
	</tr>
			<#if itemid == "48">
			<tr class="headerlabel">
				<th colspan="2" align="center">Screen<br />User</th>
				<th colspan="4" align="center">Client<br />Reference</th>
				<th colspan="4" align="center">Trademark</th>
				<th colspan="3" align="center">Database</th>
				<th colspan="3" align="center">Date</th>
				<th colspan="3" align="center">Advantage<br />Service</th>
				<th colspan="4" align="center">Records<br />Purchased</th>
				<th colspan="3" align="center"> Total Cost</th>
			</tr>
			</#if>

	<#assign lineitem = 0>

	<#list record.item as item>
		<#if item.custcol_integer_column != 244>
			<#assign lineitem = lineitem + 1>
		</#if>
		<#if item_index==0>


</thead>
	</#if>

	<#if item.custcol_integer_column == 48>

	<tr class="datascreen">
		<td colspan="2" align="center">${item.custcol_cor_scruser}</td>
		<td colspan="4" align="center">${item.custcol_cs_matter_number}</td>
		<td colspan="4" align="center">${item.custcol_cor_mark}</td>
		<td colspan="3" align="center">${item.custcol_cor_mark}</td>
		<td colspan="3" align="center">${item.custcol_cor_scrdate}</td>
		<td colspan="3" align="center">${item.class}</td>
		<td colspan="4" align="center">${item.quantity}</td>
		<td colspan="3" align="right">${item.amount} ${record.currency}</td>
	</tr>

	<#else>
	<tr>
		<td align="center" colspan="3" line-height="150%"><#if item.custcol_integer_column != 244>${lineitem}</#if></td>
		<#if item.custcol_integer_column == 244>
		<td colspan="12">
			<span class="itemname">${item.item}</span>
		</td>
		<#else>
		<td colspan="12">
			<span class="itemname">${item.custcol_cor_mark}</span>
			<#if item.custcolcustcol_international_class?has_content>
				<br />International Class: ${item.custcolcustcol_international_class}
			</#if>
			<#if item.custcolcustcol_registers?has_content>
				<br />${item.custcolcustcol_registers}
			</#if>
			<#if item.description?has_content>
				<br />${item.description}
			</#if>
			<#if item.register?has_content>
				<br />${item.register}
			</#if>
			<#if item.custcol_cor_your_ref?has_content>
				<br />${item.custcol_cor_your_ref}
			</#if>
			<#if item.custcol_cor_product_type?has_content>
				<br />${item.custcol_cor_product_type}
				<#if item.custcol_cor_turnaround?has_content>
					(${item.custcol_cor_turnaround})
				</#if>
                <#if item.class == "Screening" || item.class == "Watching">
                	<br />Subscription Period: ${item.custcol_revenue_start_date} - ${item.custcol_revenue_end_date}
                </#if>
			</#if>
		</td>
		</#if>
		<td colspan="3"></td>
		<td align="right" colspan="4"></td>
		<td align="right" colspan="4">${item.amount} ${record.currency}</td>
	</tr>
	</#if>
</#list><!-- end items -->
</table>

<table style="width: 100%">
	<tr>
		<td>${record.custrecord_cs_vat_info}</td>
	</tr>
</table>





<hr />





</body>
</pdf>

	<!-- DUTCH LANGUAGE INVOICE: end of document -->

<#elseif record.entity.custentity_cor_pdf_language == 'French'>

	<!-- FRENCH LANGUAGE INVOICE: start of document -->

<pdf>
<head>

    <macrolist>
        <macro id="nlheader">


            <table class="header" style="width: 100%;">
            	<tr>
					<td colspan="2">
						<#if record.entity.subsidiary?contains('Citizen')>
							<img class="comp-logo" src="https://system.netsuite.com/core/media/media.nl?id=923&amp;c=4322318_SB1&amp;h=62a0d0dcdf4c4723d31b" />
						<#else>
							<img class="comp-logo" src="https://system.netsuite.com/core/media/media.nl?id=400&amp;c=4322318_SB1&amp;h=429e3d8096829346bfdd" />
						</#if>
					</td>
					<td class="recordTitle" align="right" valign="bottom"><span>Facture</span></td>
				</tr>
				<tr>
					<td colspan="3"><br /><br /><br /></td>
				</tr>


				<tr>
					<td class="recordLabels" align="left">
						<p class="labeled"><span>Numéro de facture:</span>${record.tranid}</p>
						<p class="labeled"><span>Date Facture:</span>${record.trandate?string.long}</p>
						<p class="labeled"><span>Numéro de commande:</span>${createdfrom.tranid}</p>
						<p class="labeled"><span>Date de la commande:</span>${createdfrom.trandate?string.long}</p>
					</td>
					<td>
						<p class="labeled"><span>Référence client (1): </span>${record.custbody_cor_matter_number}</p>
						<p class="labeled"><span>Demandeur: </span>${billcontact.firstname}&nbsp;${billcontact.lastname}</p>
					</td>
					<td align="left">
						<p class="bold"><span class="nameandaddress">${record.billaddress}</span><#if record.vatregnum?has_content><br />V/ nº TVA: ${record.vatregnum}</#if></p>
					</td>

				</tr>

			</table>


        </macro>
        <macro id="nlfooter">
            <table class="footer" style="width: 100%;">
				<tr>
                  <td colspan="7">
                    <p>
                      Veuillez noter que notre format de facture a été adapté.  Visitez <a href="https://www.corsearch.com/billingfaq">https://www.corsearch.com/billingfaq</a> pour plus d'informations.
                    </p>
                  </td>
              </tr>
            	<tr>
	            		<td  colspan="2" class="footerinfo">${record.custbody_cs_coverletter.custrecord_cs_footer_info}</td>
	            	</tr>
            	<tr>
            		<td colspan="2" class="footerinfo">${record.custbody_info_related_company}</td>
            	</tr>
            	<tr>
					<td>&nbsp;</td>
					<td align="right"><pagenumber/> de  <totalpages/></td>
				</tr>
			</table>


        </macro>
    </macrolist>

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

		hr {
			border:1px solid #12946d;
			width: 100%;
		}



		body {
			font-family: 'Open Sans', sans-serif;
		}


		table {
			font-size: 12px;
			table-layout: fixed;
		}
        th {
            font-weight: bold;
            font-size: 12px;
            vertical-align: middle;
            padding: 5px 6px 3px;
            background-color: #fff;
            color: #333333;
        }

        td.recordTitle {
        	padding: 0 0 15px;

        }


        td {
            padding: 4px 6px;
        }
		td p { align:left }
        b {
            font-weight: bold;
            color: #333333;
        }
        table.header td {
            padding: 0;
            font-size: 10px;
        }

        td.recordTitle span {
        	font-size: 24px;
        	font-weight: bold;
        }
        table.footer td {
            padding: 5px;
            font-size: 12px;
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
            font-size: 12px;
            background-color: #e3e3e3;
        }
        td.addressheader {
            font-size: 12px;
            padding-top: 6px;
            padding-bottom: 2px;
        }
        td.address {
            padding-top: 0px;
        }
        td.totalboxmid {
            font-size: 12px;
            padding-top: 20px;
            background-color: #e3e3e3;
        }
        td.totalboxbot {
            background-color: #e3e3e3;
            font-weight: bold;
        }
        span.title {
            font-size: 12px;
        }
        span.number {
            font-size: 12px;
        }
        span.itemname {
            font-weight: bold;
            line-height: 150%;
        }

        td.recordLabels {

        }

        p.labeled {

        	font-weight: bold;
        	margin: 0 0 2px;
        }

        p.labeled span {
        	width: 200px;
        	padding-right: 7px;
        }

        .test .header {
        	display: none;
        }

        .bold {
        	font-weight: bold;
        }

        tr.headerlabel th {
        font-size: 9px;
        }

        tr.datascreen td {
        font-size: 10px;
        }

        tr.sectionHeader {

        }


        span.capitalize {
        	text-transform: uppercase;
        }

        table.itemtable {
        	border-top: 1px solid #12946d;
        }

			td.footerinfo {
        		font-size: 10px;
        	}

</style>
</head>

<body header="nlheader" header-height="20%" footer="nlfooter" footer-height="10%" padding="0.5in 0.5in 0.5in 0.5in" size="A4">

	<hr />

<#if record.item?has_content>

<#assign sum = 0>

	<#list record.item as item>
		<#assign sum = sum + item.quantity>
		<#assign label = item.item>
	</#list>

	<#if record.item?has_content>

	<#list record.item as item>
		<#assign clatssin = item.custcol_integer_column>

	</#list>


		<#if clatssin == 202>

			<#assign cstiteleheader = "Transactional Screening">

		<#elseif clatssin == 189>

			<#assign cstiteleheader = "Pre-Paid Screening Subscription">

		<#elseif clatssin == 167>

			<#assign cstiteleheader = "Data License">

		<#elseif clatssin == 190>

			<#assign cstiteleheader = "Domain Management Subscription">

		<#elseif clatssin == 204 || clatssin == 173>


		<#elseif clatssin == 200>

			<#assign cstiteleheader = "Forfait: Accès aux 'Recherches en ligne' sur www.corsearch.com">

		<#elseif clatssin == 203>

			<#assign cstiteleheader = "Rapport de recherche">

		<#elseif clatssin == 201>

			<#assign cstiteleheader = "dénomination(s) surveillée(s)">

		<#elseif clatssin == 198>

			<#assign cstiteleheader = "WorldSuite: Maintenance annuelle 2018">

		<#elseif clatssin == 171 >

			<#assign cstiteleheader = "Domain Management Transactional">

		<#elseif clatssin == 199>

			<#assign cstiteleheader = "Digital Brand Protection">

		<#elseif clatssin == 175 >

			<#assign cstiteleheader = "Online Brand Protection Transactional">

		<#elseif clatssin == 172 >

			<#assign cstiteleheader = "Search Type">

		<#else>

		</#if>

</#if>

<table class="itemtable" style="width: 100%;">

<!-- start items -->
	<tr>
    	<td><span style="font-size: 12px"><b>Total</b></span></td>
    	<td><span style="font-size: 12px"><b>Déscription</b></span></td>
    	<td align="right"><span style="font-size: 12px"><b>Cout total</b></span></td>
	</tr>

	<#assign quantity = 0>
	<#assign subtotal = 0>

	<#list record.item as item>
		<#if item.itemtype != "Discount">
      <#assign itemid = item.item.id>
		  <#assign quantity = quantity + item.quantity>
      <#if item.custcol_cor_summary_desc?has_content>
		    <#assign description = item.custcol_cor_summary_desc>
      <#else>
        <#assign description = item.item>
      </#if>
      <#assign subtotal = subtotal + item.amount>
		</#if>
	</#list>
	<tr>
		<td>
      ${quantity}
		</td>
		<td align="left">
			${description}
		</td>
		<td align="right">
			${record.custbody_cor_subtotal} ${record.currency}
		</td>
	</tr>
</table>
</#if>


<hr />


<table class="total" style="width: 100%; margin-top: 10px;">
	<tr>
		<td colspan="4"></td>
		<td colspan="3" style="border-bottom: 1px solid #12946d"></td>
	</tr>
	<tr>
		<td colspan="4">&nbsp;</td>
		<td align="right" colspan="2"><b>Sous-total</b></td>
		<td align="right">${record.custbody_cor_subtotal} ${record.currency}</td>
	</tr>
  
	<tr>
		<td colspan="4">&nbsp;</td>
		<td align="right" colspan="2"><span><b>Remise}</b></span></td>
		<td align="right">
			${record.custbody_cor_discount_total} ${record.currency}
		</td>
	</tr>
  
	<tr>
		<td colspan="4">&nbsp;</td>
		<td align="right" colspan="2"><b>Total de la TVA (${record.custbody_cor_tax_rate})</b></td>
		<td align="right">${record.taxtotal} ${record.currency}</td>
	</tr>

	<tr class="totalrow">
		<td background-color="#ffffff" colspan="4">&nbsp;</td>
		<td align="right" colspan="2"><span><b>Montant total dû</b></span></td>
		<td align="right">${record.custbody_cor_net_total} ${record.currency}</td>
	</tr>
	<tr>
		<td colspan="4"></td>
		<td colspan="3" style="border-top: 1px solid #12946d"></td>
	</tr>

</table>
<table>

	<#assign vatnum = record.taxtotal><!-- checks if it has vat. if it has then info will be displayed -->
	<#if vatnum gt 0>
    <tr>
        <td><br />${record.custbody_cs_coverletter.custrecord_cs_vat_info}<br /></td>
    </tr>

	</#if><!-- End tax language-->

	<#if record.custbody_cs_coverletter.custrecord_cs_remit_info?has_content>

	<!-- French remittance info -->

	<tr>
		<td colspan="7" align="left" class="vatinfo">${record.custbody_cs_coverletter.custrecord_cs_remit_info}</td>
	</tr>
      <tr>
        <td>Veuillez indiquer notre référence de paiement : ${record.custbody_cor_matter_number} / ${record.tranid}</td>
      </tr>

	<tr>
		<td colspan="7" style="height: 3em">&nbsp;</td>
	</tr>
	</#if>

	<#if record.custbody_cor_wire_transfer_info?has_content>

	<tr>
		<td colspan="7" style="height: 2em;"><span><b>Données de versement:</b></span></td>
	</tr>

	<tr>
		<td colspan="7" class="vatinfo">${record.custbody_cor_wire_transfer_info}</td>
	</tr>
	</#if>

</table>

<table style="width: 100%">
    <tr>
        <td>${record.custbody_cs_coverletter.custrecord_cs_message_near_footer}</td>
    </tr>
</table>

<pbr size="A4"  />


<table class="itemtable" style="width: 100%; margin-top: 10px; border-top: 1px solid #12946d"><!-- start items -->

		<thead>

		<tr class="sectionHeader">
			<th>&nbsp;</th>
	</tr>
			<#if itemid == "48">
			<tr class="headerlabel">
				<th colspan="2" align="center">Screen<br />User</th>
				<th colspan="4" align="center">Client<br />Reference</th>
				<th colspan="4" align="center">Trademark</th>
				<th colspan="3" align="center">Database</th>
				<th colspan="3" align="center">Date</th>
				<th colspan="3" align="center">Advantage<br />Service</th>
				<th colspan="4" align="center">Records<br />Purchased</th>
				<th colspan="3" align="center"> Total Cost</th>
			</tr>
			</#if>

	<#assign lineitem = 0>

	<#list record.item as item>
		<#if item.custcol_integer_column != 244>
			<#assign lineitem = lineitem + 1>
		</#if>
		<#if item_index==0>


</thead>
	</#if>

	<#if item.custcol_integer_column == 48>

	<tr class="datascreen">
		<td colspan="2" align="center">${item.custcol_cor_scruser}</td>
		<td colspan="4" align="center">${item.custcol_cs_matter_number}</td>
		<td colspan="4" align="center">${item.custcol_cor_mark}</td>
		<td colspan="3" align="center">${item.custcol_cor_mark}</td>
		<td colspan="3" align="center">${item.custcol_cor_scrdate}</td>
		<td colspan="3" align="center">${item.class}</td>
		<td colspan="4" align="center">${item.quantity}</td>
		<td colspan="3" align="right">${item.amount} ${record.currency}</td>
	</tr>

	<#else>
	<tr>
		<td align="center" colspan="3" line-height="150%"><#if item.custcol_integer_column != 244>${lineitem}</#if></td>
		<#if item.custcol_integer_column == 244>
		<td colspan="12">
			<span class="itemname">${item.item}</span>
		</td>
		<#else>
		<td colspan="12">
			<span class="itemname">${item.custcol_cor_mark}</span>
			<#if item.custcolcustcol_international_class?has_content>
				<br />International Class: ${item.custcolcustcol_international_class}
			</#if>
			<#if item.custcolcustcol_registers?has_content>
				<br />${item.custcolcustcol_registers}
			</#if>
			<#if item.description?has_content>
				<br />${item.description}
			</#if>
			<#if item.register?has_content>
				<br />${item.register}
			</#if>
			<#if item.custcol_cor_your_ref?has_content>
				<br />${item.custcol_cor_your_ref}
			</#if>
			<#if item.custcol_cor_product_type?has_content>
				<br />${item.custcol_cor_product_type}
				<#if item.custcol_cor_turnaround?has_content>
					(${item.custcol_cor_turnaround})
				</#if>
                <#if item.class == "Screening" || item.class == "Watching">
                	<br />Subscription Period: ${item.custcol_revenue_start_date} - ${item.custcol_revenue_end_date}
                </#if>
			</#if>
		</td>
		</#if>
		<td colspan="3"></td>
		<td align="right" colspan="4"></td>
		<td align="right" colspan="4">${item.amount} ${record.currency}</td>
	</tr>
	</#if>
</#list><!-- end items -->
</table>

<table style="width: 100%">
	<tr>
		<td>${record.custrecord_cs_vat_info}</td>
	</tr>
</table>

<hr />





</body>
</pdf>

	<!-- FRENCH LANGUAGE INVOICE: end of document -->


<#else>

<pdf>

<head>

    <macrolist>
        <macro id="nlheader">


            <table class="header" style="width: 100%;">
            	<tr>
					<td colspan="2">
						<#if record.entity.subsidiary?contains('Citizen')>
							<img class="comp-logo" src="https://system.netsuite.com/core/media/media.nl?id=923&amp;c=4322318_SB1&amp;h=62a0d0dcdf4c4723d31b" />
						<#else>
							<img class="comp-logo" src="https://system.netsuite.com/core/media/media.nl?id=400&amp;c=4322318_SB1&amp;h=429e3d8096829346bfdd" />
						</#if>
					</td>
					<td class="recordTitle" align="right" valign="bottom"><span>${record@title}</span></td>
				</tr>
				<tr>
					<td colspan="3"><br /><br /><br /></td>
				</tr>


				<tr>
					<td class="recordLabels" align="left">
						<p class="labeled"><span>Invoice number:</span>${record.tranid}</p>
						<p class="labeled"><span>Invoice date:</span>${record.trandate?string.long}</p>
                      <#if record.createdfrom?has_content>
						<p class="labeled"><span>Order Number:</span>${createdfrom.tranid}</p>
						<p class="labeled"><span>Order Date:</span>${createdfrom.trandate?string.long}</p>
                      </#if>
					</td>
					<td>
						<p class="labeled"><span>Customer Reference: </span>${record.custbody_cor_matter_number}</p>
						<p class="labeled"><span>Requested By: </span>${billcontact.firstname}&nbsp;${billcontact.lastname}</p>
					</td>
					<td align="right">
						<p class="bold"><span class="nameandaddress">${record.billaddress}<#if record.vatregnum?has_content><br />VAT Registration: ${record.vatregnum}</#if></span></p>
					</td>

				</tr>

			</table>


        </macro>
        <macro id="nlfooter">
            <table class="footer" style="width: 100%;">
              <tr>
      			<td colspan="7"><p>Please note our invoice format has changed.  Visit <a href="https://www.corsearch.com/billingfaq">https://www.corsearch.com/billingfaq</a> for more information.</p></td>
    		 </tr>
              
			  <tr>
                
                <td colspan="7" class="footerinfo">
                  <#if record.custbody_cs_coverletter.custrecord_cs_footer_info?has_content>
                  	${record.custbody_cs_coverletter.custrecord_cs_footer_info}
                  <#else>
                  	<p>
                   	 <b>Corsearch, Inc.</b><br />
                   	 220 West 42nd Street, 11th Floor, New York, NY 10036 +1 800 SEARCH1TM (+1 800 732 7241) • corsearch.com Corsearch.UScustomerservice@corsearch.com
                  	</p>
                  </#if>
                </td>
              </tr>
			</table>


        </macro>
    </macrolist>

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

		hr {
			border:1px solid #12946d;
			width: 100%;
		}



		body {
			font-family: 'Open Sans', sans-serif;
		}


		table {
			font-size: 12px;
			table-layout: fixed;
		}
        th {
            font-weight: bold;
            font-size: 12px;
            vertical-align: middle;
            padding: 5px 6px 3px;
            background-color: #fff;
            color: #333333;
        }

        td.recordTitle {
        	padding: 0 0 15px;

        }


        td {
            padding: 4px 6px;
        }
		td p { align:left }
        b {
            font-weight: bold;
            color: #333333;
        }
        table.header td {
            padding: 0;
            font-size: 10px;
        }

        td.recordTitle span {
        	font-size: 24px;
        	font-weight: bold;
        }
        table.footer td {
            padding: 5px;
            font-size: 12px;
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
            font-size: 12px;
            background-color: #e3e3e3;
        }
        td.addressheader {
            font-size: 12px;
            padding-top: 6px;
            padding-bottom: 2px;
        }
        td.address {
            padding-top: 0px;
        }
        td.totalboxmid {
            font-size: 12px;
            padding-top: 20px;
            background-color: #e3e3e3;
        }
        td.totalboxbot {
            background-color: #e3e3e3;
            font-weight: bold;
        }
        span.title {
            font-size: 12px;
        }
        span.number {
            font-size: 12px;
        }
        span.itemname {
            font-weight: bold;
            line-height: 150%;
        }

        td.recordLabels {

        }

        p.labeled {

        	font-weight: bold;
        	margin: 0 0 2px;
        }

        p.labeled span {
        	width: 200px;
        	padding-right: 7px;
        }

        .test .header {
        	display: none;
        }

        .bold {
        	font-weight: bold;
        }

        tr.headerlabel th {
        font-size: 9px;
        }

        tr.datascreen td {
        font-size: 10px;
        }

        tr.sectionHeader {

        }


        table.itemtable {
        	/* border-top: 1px solid #12946d; */
        }


			td.footerinfo {
        		font-size: 10px;
        	}

</style>
</head>

<body header="nlheader" header-height="20%" footer="nlfooter" footer-height="10%" padding="0.5in 0.5in 0.5in 0.5in" size="A4">

	<hr />

<#if record.item?has_content>

<table class="itemtable" style="width: 100%;">

<!-- start items -->

	<tr>
		<td><span style="font-size: 12px"><b>TOTAL CHARGES</b></span></td>
    <td><span style="font-size: 12px"><b>DESCRIPTION</b></span></td>
    <td align="right"><span style="font-size: 12px"><b>COST</b></span></td>
	</tr>

	<#assign quantity = 0>
  <#assign subtotal = 0>
  <#list record.item as item>
    
  </#list>

	<#list record.item as item>
		<#if item.itemtype != "Discount">
		  <#assign quantity = quantity + item.quantity>
      <#if item?index == 0>
        <#assign itemid = item.item.id>
        <#if item.custcol_cor_summary_desc?has_content>
		      <#assign description = item.custcol_cor_summary_desc>
        <#else>
          <#assign description = item.item>
        </#if>
      </#if>
		</#if>
	</#list>
	<tr>
		<td>
          ${quantity}
		</td>
		<td align="left">
			${description}
		</td>
		<td align="right">
			${record.custbody_cor_subtotal} ${record.currency}
		</td>
	</tr>
</table>

</#if>

<!-- LINE 261 -->
<hr />
<table class="total" style="width: 100%; margin-top: 10px;">
	<tr>
		<td colspan="4"></td>
		<td colspan="3" style="border-bottom: 2px solid #12946d"></td>
	</tr>
	<tr>
		<td colspan="4">&nbsp;</td>
		<td align="right" colspan="2"><b>${record.subtotal@label}</b></td>
		<td align="right">${record.custbody_cor_subtotal} ${record.currency}</td>
	</tr>
	<#assign disctotal = 0>
	<#list record.item as item>
		<#if item.custcol_integer_column == 244>
			<#if item.amount?has_content>
				<#assign disctotal = disctotal + item.amount>
			</#if>
		</#if>
	</#list>
      <#if record.custbody_cor_discount_total?has_content>
	<tr>
		<td colspan="4">&nbsp;</td>
		<td align="right" colspan="2"><span><b>${record.discounttotal@label}</b></span></td>
		<td align="right">
			${record.custbody_cor_discount_total} ${record.currency}
		</td>
	</tr>
      </#if>

	<tr>
		<td colspan="4">&nbsp;</td>
		<td align="right" colspan="2"><b>${record.taxtotal@label} (${record.taxrate}%)</b></td>
		<td align="right">${record.taxtotal} ${record.currency}</td>
	</tr>
	<tr class="totalrow">
		<td background-color="#ffffff" colspan="4">&nbsp;</td>
		<td align="right" colspan="2"><b>${record.total@label}</b></td>
		<td align="right">${record.custbody_cor_net_total} ${record.currency}</td>
	</tr>
	<tr>
		<td colspan="4"></td>
		<td colspan="3" style="border-top: 2px solid #12946d"></td>
	</tr>

	<tr>
		<td colspan="7" style="height: 3em">&nbsp;</td>
	</tr>

	<#assign vatnum = record.taxtotal>
	<#if vatnum gt 0>
    <tr>
        <td colspan="7" class="vatinfo">${record.custbody_cs_coverletter.custrecord_cs_vat_info}</td>
    </tr>
    <tr>
        <td colspan="7" class="vatinfo">${record.custbody_cs_coverletter.custrecord_cs_after_vat_info}</td>
    </tr>
    <tr>
		<td colspan="7" style="height: 3em">&nbsp;</td>
	</tr>
	</#if>

	<tr>
		<td colspan="7"></td>
	</tr>
	<tr>
    <td colspan="7">
    	<#if record.subsidiary.id == "6" || record.subsidiary.id == "7" || record.subsidiary.id == "8">
		  ${record.custbody_cor_remit_details}
    	<#else>
      		${record.custbody_cs_coverletter.custrecord_cs_remit_info}
    	</#if>
      </td>
	</tr>

	<tr>
		<td colspan="7" >When paying, please quote : ${record.custbody_cor_matter_number} / ${record.tranid}</td>
	</tr>

</table>
<#assign vatnum = record.taxtotal>
<#if vatnum gt 0>

<table style="width: 100%">
    <tr>
        <td>${record.custbody_cs_coverletter.custrecord_cs_message_near_footer}</td>
    </tr>
</table>
</#if>
<pbr size="A4"  />


<table class="itemtable" style="width: 100%; margin-top: 10px; border-top: 1px solid #12946d"><!-- start items -->

		<thead>

		<tr class="sectionHeader">
			<th>&nbsp;</th>
	</tr>
			<#if itemid == "48">
			<tr class="headerlabel">
				<th colspan="2" align="center">Screen<br />User</th>
				<th colspan="4" align="center">Client<br />Reference</th>
				<th colspan="4" align="center">Trademark</th>
				<th colspan="3" align="center">Database</th>
				<th colspan="3" align="center">Date</th>
				<th colspan="3" align="center">Advantage<br />Service</th>
				<th colspan="4" align="center">Records<br />Purchased</th>
				<th colspan="3" align="center"> Total Cost</th>
			</tr>
			</#if>

	<#assign lineitem = 0>

	<#list record.item as item>
		<#if item.custcol_integer_column != 244>
			<#assign lineitem = lineitem + 1>
		</#if>
		<#if item_index==0>


</thead>
	</#if>

	<#if item.custcol_integer_column == 48>

	<tr class="datascreen">
		<td colspan="2" align="center">${item.custcol_cor_scruser}</td>
		<td colspan="4" align="center">${item.custcol_cs_matter_number}</td>
		<td colspan="4" align="center">${item.custcol_cor_mark}</td>
		<td colspan="3" align="center">${item.custcol_cor_mark}</td>
		<td colspan="3" align="center">${item.custcol_cor_scrdate}</td>
		<td colspan="3" align="center">${item.class}</td>
		<td colspan="4" align="center">${item.quantity}</td>
		<td colspan="3" align="right">${item.amount} ${record.currency}</td>
	</tr>

	<#else>
	<tr>
		<td align="center" colspan="3" line-height="150%"><#if item.custcol_integer_column != 244>${lineitem}</#if></td>
		<#if item.custcol_integer_column == 244>
		<td colspan="12">
			<span class="itemname">${item.item}<br /></span>
		</td>
		<#else>
		<td colspan="12">
          	<#if item.custcol_cor_mark?has_content>
				<span class="itemname">${item.custcol_cor_mark}<br /></span>
            </#if>
			<#if item.custcolcustcol_international_class?has_content>
				International Class: ${item.custcolcustcol_international_class}<br />
			</#if>
			<#if item.custcolcustcol_registers?has_content>
				${item.custcolcustcol_registers}<br />
			</#if>
			<#if item.description?has_content>
				${item.description}<br />
			</#if>
			<#if item.register?has_content>
				${item.register}<br />
			</#if>
			<#if item.custcol_cor_your_ref?has_content>
				${item.custcol_cor_your_ref}<br />
			</#if>
			<#if item.custcol_cor_product_type?has_content>
				${item.custcol_cor_product_type}
				<#if item.custcol_cor_turnaround?has_content>
					(${item.custcol_cor_turnaround})
				</#if>
                <#if item.class == "Screening" || item.class == "Watching">
                	<br />Subscription Period: ${item.custcol_revenue_start_date} - ${item.custcol_revenue_end_date}
                </#if>
			</#if>
		</td>
		</#if>
		<td colspan="3"></td>
		<td align="right" colspan="4"></td>
		<td align="right" colspan="4">${item.amount} ${record.currency}</td>
	</tr>
	</#if>
</#list><!-- end items -->
</table>







<hr />

</body>
</pdf>
</#if> <!--  END OF LANGUAGE CONDITION -->

</pdfset>
