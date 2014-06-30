<%
Dim id_projeto

id_projeto = session("projeto_atual_CQ")

response.Write ("&id_projeto="&id_projeto)   
%>