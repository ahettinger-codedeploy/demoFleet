<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->

<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->

<!-- #include file="JSON_2.0.4.asp" -->

<!--#include file="JSON_UTIL_0.1.1.asp"-->
    
<%
QueryToJSON(dbconn, "SELECT VenueCode, Venue, Address_1, Address_2, City, State, Zip_Code, Country, VenueComments FROM Venue WHERE (Zip_Code = '90802')").Flush
%>



