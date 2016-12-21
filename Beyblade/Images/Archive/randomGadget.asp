<%	'Random image picker
	numStart = 0
	numEnd = 14		'Number of character images

	dim imgName		'variable for image filename

	randomize
	numRandom = Int((numEnd + 1) * Rnd)

	select case numRandom

		case 0
			imgName = "2_bladebreakers.gif"
		case 1
			imgName = "2_kai.gif"
		case 2
			imgName = "2_kaiBIT1.gif"
		case 3
			imgName = "2_kaiBIT2.gif"
		case 4
			imgName = "2_kane.gif"
		case 5
			imgName = "2_mariam.gif"
		case 6
			imgName = "2_mariamBIT.gif"
		case 7
			imgName = "2_ozuma.gif"
		case 8
			imgName = "2_ozumaBIT.gif"
		case 9
			imgName = "2_psykick.gif"
		case 10
			imgName = "2_rayBIT.gif"
		case 11
			imgName = "2_saintsheilds.gif"
		case 12
			imgName = "2_ty.gif"
		case 13
			imgName = "2_tyBIT1.gif"
		case 14
			imgName = "2_tyBIT2.gif"
		

	end select
%>

<table cellspacing="0" cellpadding="0" border="0" width="181">

	<tr><td><img src="/chrome/gadget-top.gif" width="181" height="15"></td></tr>
	<tr><td align="center" valign="middle" background="/chrome/gadget-back.gif"><img src="/common/spacer.gif" width="40" height="15"></td></tr>
	<tr><td align="center" valign="middle" background="/chrome/gadget-back.gif"><img src="/images/gadgets/<%=imgName %>"></td></tr>
	<tr><td align="center" valign="middle" background="/chrome/gadget-back.gif"><img src="/common/spacer.gif" width="40" height="15"></td></tr>
	<tr><td><img src="/chrome/gadget-bottom.gif" width="181" height="15"></td></tr>

</table>