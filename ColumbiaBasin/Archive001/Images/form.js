/***********************************************************
*	Used for auto form validation and value retain.
*	Li -- 10/30/2004
************************************************************/

function AutoFormValidate(frm)
{
	if (frm.elements.length != undefined)
	{
		for(i=0; i<frm.elements.length; i++)
		{
			switch ( frm.elements[i].type )
			{
				case "hidden":
				{
					//Do nothing for hidden field.
				}
				break;
				
				case "submit":
				{
					//Do nothing for submit button.
				}
				break;
				
				case "reset":
				{
					//Do nothing for reset button.
				}
				break;					
				
				case "button":
				{
					//Do nothing for button.
				}
				break;
				
				case "text":
				{
					if (frm.elements[i].name.indexOf("_*") >= 0)
					{
						if (frm.elements[i].value == "")
						{
							alert(frm.elements[i].name.substring(0,frm.elements[i].name.indexOf("_*")) + " is a required field.");
							frm.elements[i].focus();
							return false;
						}
					}
					
					var txt_name = frm.elements[i].name.toLowerCase()
					
					if (txt_name.indexOf("email") >= 0)
					{
						if (!isValidEmail(frm.elements[i].value))
						{
							alert("Please input valid email address.");
							frm.elements[i].focus();
							return false;
						}
						
					}
											
				}
				break;
				
				case "textarea":
				{
					if (frm.elements[i].name.indexOf("_*") >= 0)
					{
						if (frm.elements[i].value == "")
						{
							alert(frm.elements[i].name.substring(0,frm.elements[i].name.indexOf("_*")) + " is a required field.");
							frm.elements[i].focus();
							return false;
						}
					}					
				}
				break;
				
				case "file":
				{
					alert("Form configuration error. Customer Form Can not use file upload.");
					return false;
				}
				break;
				
				case "image":
				{
					alert("Form configuration error. Customer Form Can not use Image field.");
					return false;
				}
				break;
				
				case "password":
				{
					if (frm.elements[i].name.indexOf("_*") >= 0)
					{
						if (frm.elements[i].value == "")
						{
							alert(frm.elements[i].name.substring(0,frm.elements[i].name.indexOf("_*")) + " is a required field.");
							frm.elements[i].focus();
							return false;
						}
					}					
				}
				break;
				
				case "radio":
				{
					var radio_checked = 0;
					var radio_name = frm.elements[i].name;
					
					if (frm.elements[i].name.indexOf("_*") >= 0)
					{
						if (frm.elements[radio_name].length != undefined)
						{
							//More than one radio button for this radio button group.
							for (j=0; j<frm.elements[radio_name].length; j++)
							{
								if (frm.elements[radio_name][j].checked)
								{
									radio_checked = 1;
								}
							}
						}
						else
						{
							//Only one radio button for this radio button group.
							if (frm.elements[radio_name].checked)
							{
								radio_checked = 1;
							}								
						}
						
						if (radio_checked == 0)
						{
							alert(frm.elements[i].name.substring(0,frm.elements[i].name.indexOf("_*")) + " is a required field.");
							return false;
						}													
					}
				}
				break;
				
				case "checkbox":
				{
					var checkbox_checked = 0;
					var checkbox_name = frm.elements[i].name
					
					if (frm.elements[i].name.indexOf("_*") >= 0)
					{
						if (frm.elements[checkbox_name].length != undefined)
						{
							//More than one chechbox for this checkbox group.
							for (j=0; j<frm.elements[checkbox_name].length; j++)
							{
								if (frm.elements[checkbox_name][j].checked == true)
								{
									checkbox_checked = 1;
								}
							}
						}
						else
						{
							//Only one checkbox for this checkbox group.
							if (frm.elements[checkbox_name].checked == true)
							{
								checkbox_checked = 1;
							}								
						}
						
						if (checkbox_checked == 0)
						{
							alert(frm.elements[i].name.substring(0,frm.elements[i].name.indexOf("_*")) + " is a required field.");
							return false;
						}													
					}					
				
				}
				break;
				
				case "select":
				{
					//Currently, We don't have it.
				}
				break;
			
			}

		}
	}
	else
	{
		alert("Form Configuration Error!");
		return false;
	}
	
	return true
}

function SetFormDefaultValues()
{
	var frm = document.forms["autoform"];

	if (frm.elements.length != undefined)
	{
		for(i=0; i<frm.elements.length; i++)		
		{
			//alert(frm.elements[i].type);
			for(j=0; j<arrFormEle[0].length; j++)
			{
				if (frm.elements[i].name == arrFormEle[0][j])
				{
					switch ( frm.elements[i].type )
					{
						case "text":
						{
							frm.elements[i].value = arrFormEle[1][j];
						}
						break;
						
						case "textarea":
						{
							frm.elements[i].value = arrFormEle[1][j];
						}
						break;						
						
						case "checkbox":
						{
							//alert(frm.elements[i].length);
							if (frm.elements[i].length != undefined)
							{
								for (k=0; k<frm.elements[i].length; k++)
								{
									var arrCheckBox = arrFormEle[1][j].split(", ");
									if (arrCheckBox.length != undefined)
									{
										for (l=0; l<arrCheckBox.length; l++)
										{
											if (frm.elements[i][k].value == arrCheckBox[l])
											{
												frm.elements[i][k].checked = true;
											}
											else
											{
												
											}
										}									
									}
									else
									{
										if (frm.elements[i][k].value == arrFormEle[1][j])
										{
											frm.elements[i][k].checked = true;
										}										
									}
									

								}
							}
							else
							{
									var arrCheckBox = arrFormEle[1][j].split(", ");
									if (arrCheckBox.length != undefined)
									{
										for (l=0; l<arrCheckBox.length; l++)
										{
											if (frm.elements[i].value == arrCheckBox[l])
											{
												frm.elements[i].checked = true;
											}
											else
											{
												
											}
										}									
									}
									else
									{
										if (frm.elements[i].value == arrFormEle[1][j])
										{
											frm.elements[i].checked = true;
										}										
									}								
							}
						}
						break;
						
						case "radio":
						{
							if (frm.elements[i].length != undefined)
							{
								for (k=0; k<frm.elements[i].length; k++)
								{
									var arrCheckBox = arrFormEle[1][j].split(", ");
									if (arrCheckBox.length != undefined)
									{
										for (l=0; l<arrCheckBox.length; l++)
										{
											if (frm.elements[i][k].value == arrCheckBox[l])
											{
												frm.elements[i][k].checked = true;
											}
											else
											{
												
											}
										}									
									}
									else
									{
										if (frm.elements[i][k].value == arrFormEle[1][j])
										{
											frm.elements[i][k].checked = true;
										}										
									}
									

								}
							}
							else
							{
								if (frm.elements[i].value == arrFormEle[1][j])
								{
									frm.elements[i].checked = true;
								}								
							}						
						}
						break;
					}
					
				}
			}
			
		}		
	}
	else
	{
	
	}
}
