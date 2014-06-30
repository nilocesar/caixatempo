<!-- #include file="../../../../extranet/inc/conn.asp" -->
<%
	Session.Timeout = 120
      tela = Request.Form("tela")
      comment = Request.Form("descricao")
      login  = Request.Form("login")
      date_day  = Request.Form("dia")
      lingua = Request.Form("lingua")
	  origem = Request.Form("orig")
	  respons = CInt(Request.Form("resp"))
	  gravidade = CInt(Request.Form("grav"))
	  sessi_atual = CInt(Request.Form("sessi"))
	 
'----------------------------------------------------------
	'data_correcao
	'descricao
	'comentario
	'id_responsavel_departamento
	'id_aprovador
'----------------------------------------------------------

	dt = Split(date_day, "¬")
	ID_Detector = session("logado")
	ID_Resp = respons '10
	ID_Proj =  sessi_atual
	ID_Aprov = "0"
	myDate = Month(Now) & "/" & Day(Now) & "/" & Year(Now)
	pend = 0
	Grav = gravidade ' 4
	Orig = origem ' "NE"


	OK_Resp = 0
	ID_Emp = 0
	Screen = tela
	Comentario = Replace(comment,"'","´")
	Nr_indice = 1

		

		SQL = " select "_
			& " case when (select max(id_erro+1) as Max_Erro from ErroDetectado where id_projeto=" & ID_Proj & ") is Null then 1 "_
			& " else (select max(id_erro+1) as Max_Erro "_
			& " from ErroDetectado where id_projeto="& ID_Proj &") end as Max_Erro "

		Set RS_Login = Conn.Execute(SQL)

		ID_Erro = RS_Login("Max_Erro")

		SQL = "INSERT INTO ErroDetectado "_
			& "(id_detector,id_responsavel,id_projeto,"_
			& "id_erro,data_deteccao,"_
			& "okresponsavel,id_empresa,tela,pendente,id_gravidade,id_origem) "_
			& " values (" & ID_Detector & "," & ID_Resp & "," & ID_Proj & ","_
			& " " & ID_Erro & ",'" & myDate & "',"_
			& " " & OK_Resp & "," & ID_Emp & ",'" & Screen & "',"& pend &","& Grav &",'"& Orig &"')"

		Set RS_Login = Conn.Execute(SQL)


		Max_Indice = 1

	SQL = "INSERT INTO ErroDetectadoComentarios "_
	& " (id_projeto,id_erro,id_usuario,data_comentario,comentario,nr_indice) values "_
	& " (" & ID_Proj & "," & ID_Erro & "," & ID_Detector & ",'" & myDate & "','" & Comentario & "'," & Max_Indice & ") "

	Set RS_Login = Conn.Execute(SQL)

'----------------------------------------------------------

If Err <> 0 Then
response.write ("&recebe_vars=1&")
Else
response.write ("&recebe_vars=0&")
End If

%>

