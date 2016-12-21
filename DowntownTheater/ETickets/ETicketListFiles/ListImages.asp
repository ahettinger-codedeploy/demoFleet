<%

%>

<table border="1" cellspacing="0" cellpadding="5" width="600">
    <tr>
        <th>Name (filename)</th>
        <th>Type (filename 0)</th>
        <th>Size (filename 1)</th>
        <th>Modified (filename 2)</th>
    </tr>
    <%
    dim Files
    set Files = GetFiles("images", "\.(bmp|gif|jpg|jpeg|png|tif)$")

    if Files.Count = 0 then
        %>
        <tr>
            <td colspan="4">There are no images to display. </td>
        </tr>
        <%
    end if

    dim Filename
    for each Filename in Files
        %>
        <tr>
            <td><%= Filename %></td>
            <td><%= Files(Filename)(0) %></td>
            <td><%= Files(Filename)(1) %></td>
            <td><%= Files(Filename)(2) %></td>
        </tr>
        <%
    next
    %>
</table>


<%

function GetFiles(pFolder, pPattern)

    dim Filelist
    set Filelist = Server.CreateObject("SCRIPTING.DICTIONARY")

    dim Regex
    set Regex = new RegExp
        Regex.IgnoreCase = true
        Regex.Pattern = pPattern

    dim Fso
    set Fso = Server.CreateObject("SCRIPTING.FILESYSTEMOBJECT")

    dim Folder
    set Folder = Fso.GetFolder(Server.MapPath(pFolder))

    dim File
    for each File in Folder.Files
	

	
	TestFile = Regex.Test(File.Name)
	

	Response.Write "OPTION VALUE=" & TestFile & " "& vbCrLf
			
        if Regex.Test(File.Name) then
            Filelist.add File.Name, Array(File.Type, File.Size, File.DateLastModified)
        end if
    next

    set File = nothing
    set Folder = nothing
    set Fso = nothing
    set Regex = nothing

    set GetFiles = Filelist

end function

%>