<!-- #include file="../../../../extranet/inc/conn.asp" -->
<%
Dim id_projeto
Dim lsSQL
Dim tela
Dim id_usuario
Dim retorno

id_projeto   =   CInt(Request.Form("idProjetoFlash"))
tela         = Request.Form("tela_atual") 
id_usuario   = session("logado")

lsSQL = "select ErroDetectadoComentarios.comentario, "
lsSQL = lsSQL&"ErroDetectadoComentarios.data_comentario "
lsSQL = lsSQL&"from ErroDetectadoComentarios, ErroDetectado "
lsSQL = lsSQL&"where ErroDetectadoComentarios.id_usuario = "&id_usuario&" and "
lsSQL = lsSQL&"ErroDetectado.tela like '%"&tela&"%' and "
lsSQL = lsSQL&"ErroDetectado.id_projeto = "&id_projeto&" and "
lsSQL = lsSQL&"ErroDetectadoComentarios.id_projeto = "&id_projeto&" and "
lsSQL = lsSQL&"ErroDetectado.id_erro = ErroDetectadoComentarios.id_erro"

Set RS = Conn.Execute(lsSQL)

If Not RS.EOF Then
	While Not RS.EOF    
		retorno = retorno&RS("comentario")&"|"&RS("data_comentario")&"*"
		RS.movenext
	wend
	
	response.Write("&dados="&retorno)
Else
	response.Write ("&dados= vazio_Affero")
End if
        
%>