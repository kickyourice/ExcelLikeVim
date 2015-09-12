VERSION 1.0 CLASS
BEGIN
	MultiUse = -1  'True
END
Attribute VB_Name = "ThisWorkbook"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True

'----------------------------- Consts ---------------
'���C�u�������X�g�̐ݒ� (�ݒu�t�H���_�̓��[�N�u�b�N�Ɠ����f�B���N�g��)
Const FILENAME_LIBLIST As String = "libdef.txt" '���C�u�������X�g�̃t�@�C����
Const REGISTRY_BOOK AS String =  "register.xlsx"

'----------------------------- Workbook_open() ---------------
Private Sub Workbook_Open() '{{{
	Call clearAllModules()
	Call import_xbundle()
	Application.run "UpdateModules", "VimX", 1
	Application.run ("InitializeApplication")
	Application.OnTime Now * TimeValue("00:00:05"), "SetAppevent"
End Sub '}}}

Private Sub Workbook_Close() '{{{
	'clear����save���������悢����
	' Call clearAllModules
End Sub '}}}

Private Sub clearAllModules() '{{{
	For Each component In ThisWorkbook.VBProject.VBComponents
		'�W�����W���[��(Type=1) / �N���X���W���[��(Type=2) / form(Type=3)��S�č폜
		If component.Type = 1 Or component.Type = 2 Or component.Type = 3 Then
			ThisWorkbook.VBProject.VBComponents.Remove component
		End If
	Next component
End Sub '}}}

Private Sub import_xbundle() '{{{
	Set myFSO = CreateObject("Scripting.FileSystemObject")
	modPath = absPath("./src/core/CodeManager.bas")
	Dim moduleName As String: moduleName = myFSO.GetBaseName(modPath)

	If Not isMemberOfVBEComponets(ThisWorkbook, moduleName) Then '���݂��Ȃ��ꍇ�͐V�K�o�^�
		ThisWorkbook.VBProject.VBComponents.Import modPath
	Else
		With ThisWorkbook.VBProject.VBComponents(moduleName).CodeModule
			.DeleteLines StartLine:=1, count:=.CountOfLines
			.AddFromFile modPath
		End With
	End If
End Sub '}}}

Private Sub OpenRegistryBook() '{{{
	SmartOpenBook ThisWorkbook.Path & "\.cache\" & REGISTRY_BOOK
	Application.Windows(REGISTRY_BOOK).Visible = False
End Sub '}}}

'----------------------------- common Functions / Subs ---------------
Private Function absPath(ByVal pathFile As String) As String '{{{
	' �t�@�C���p�X���΃p�X�ɕϊ�

	Dim nameOS As String
	nameOS = Application.OperatingSystem

	'replace Win backslash(Chr(92))
	pathFile = Replace(pathFile, Chr(92), Application.PathSeparator)

	'replace Mac ":"Chr(58)
	pathFile = Replace(pathFile, ":", Application.PathSeparator)

	'replace Unix "/"Chr(47)
	pathFile = Replace(pathFile, "/", Application.PathSeparator)


	Select Case Left(pathFile, 1)

		'Case1. . �Ŏn�܂�ꍇ(���Ύw��)
	Case ".":

		Select Case Left(pathFile, 2)

			' Case1-1. ���Ύw�� "../" �Ή�
		Case "..":
			'MsgBox "Case1-1: " & pathFile
			absPath = ThisWorkbook.Path & Application.PathSeparator & pathFile
			Exit Function

			' Case1-2. ���Ύw�� "./" �Ή�
		Case Else:
			'MsgBox "Case1-2: " & pathFile
			absPath = ThisWorkbook.Path & Mid(pathFile, 2, Len(pathFile) - 1)
			Exit Function

	End Select

	'Case2. ��؂蕶���Ŏn�܂�ꍇ (��Ύw��)
Case Application.PathSeparator:

	' Case2-1. Windows Network Drive ( chr(92) & chr(92) & "hoge")
	'MsgBox "Case2-1: " & pathFile
	If Left(pathFile, 2) = Chr(92) & Chr(92) Then
		absPath = pathFile
		Exit Function

	Else
		' Case2-2. Mac/UNIX Absolute path (/hoge)
		absPath = pathFile
		Exit Function

	End If

  End Select


  'Case3. [A-z][0-9]�Ŏn�܂�ꍇ (Mac��Office�Ő��K�\�����g����� select���ɓ����ׂ�...)

  ' Case3-1.�h���C�u���^�[�Ή�("c:" & chr(92) �� "c" & chr(92) & chr(92)�ɂȂ��Ă��܂��̂ŏ����߂�)
  If nameOS Like "Windows *" And Left(pathFile, 2) Like "[A-z]" & Application.PathSeparator Then
	  'MsgBox "Case3-1" & pathFile
	  absPath = Replace(pathFile, Application.PathSeparator, ":", 1, 1)
	  Exit Function
  End If

  ' Case3-2. ���w�� "filename"�Ή�
  If Left(pathFile, 1) Like "[0-9]" Or Left(pathFile, 1) Like "[A-z]" Then
	  absPath = ThisWorkbook.Path & Application.PathSeparator & pathFile
	  Exit Function
  Else
	  MsgBox "Error[AbsPath]: fail to get absolute path."

  End If

End Function '}}}

Private Function checkExistFile(ByVal pathFile As String) As Boolean '{{{

	On Error GoTo Err_dir
	If dir(pathFile) = "" Then
		checkExistFile = False
	Else
		checkExistFile = True
	End If

	Exit Function

Err_dir:
	checkExistFile = False
End Function '}}}

Private Function list2array(ByVal pathFile As String) As Variant '{{{
	'���X�g�t�@�C����z��ŕԂ�(�s����'(�R�����g)�̍s & ��s�͖�������)
	Dim nameOS As String
	nameOS = Application.OperatingSystem

	'1. ���X�g�t�@�C���̓ǂݎ��
	Dim fp As Integer
	fp = FreeFile
	Open pathFile For Input As #fp

	'2. ���X�g�̔z��
	Dim arrayOutput() As String
	Dim countLine As Integer
	countLine = 0
	ReDim Preserve arrayOutput(countLine) ' �z��0�ŕԂ��ꍇ�����邽��

	Do Until EOF(fp)
		'���C�u�������X�g��1�s������
		Dim strLine As String
		Line Input #fp, strLine
		isLf = InStr(strLine, vbLf)
		If nameOS Like "Windows *" And Not isLf = 0 Then
			'OS��Windows ���� ���X�g�� LF���܂܂��ꍇ (�t�@�C����UNIX�`��)
			'�t�@�C���S�̂�1�s�Ɍ����Ă��܂��B
			Dim arrayLineLF As Variant
			strLine = Replace(strLine, vbTab, "") 'tab(�C���f���g)�𖳎�
			arrayLineLF = Split(strLine, vbLf)
			For i = 0 To UBound(arrayLineLF) - 1
				'�s���� '(�R�����g) �ł͂Ȃ� & ��s�ł͂Ȃ��ꍇ
				' If Not left(arrayLineLF(i), 1) = "'" And Len(arrayLineLF(i)) > 0 Then
				If arrayLineLF(i) <> "" Then
					arrayLineLFS = Split(arrayLineLF(i), " ")
					If arrayLineLFS(0) = "bundle" Then
						'�z��ւ̒ǉ�
						countLine = countLine + 1
						ReDim Preserve arrayOutput(countLine)
						arrayOutput(countLine - 1) = arrayLineLFS(1)
					End If
				End If
			Next i
		Else
			'OS��Windows and �t�@�C����Windows�`�� (�ϊ��s�v)
			'OS��MacOS X and �t�@�C����UNIX�`�� (�ϊ��s�v)
			'OS��MacOS X and �t�@�C����Windows�`��
			' vbCr�����W���[���t�@�C�����𔭌��ł��Ȃ��Ȃ�B
			strLine = Replace(strLine, vbCr, "")
			arraystrLine = Split(strLine, " ")
			'�s���� '(�R�����g) �ł͂Ȃ� & ��s�ł͂Ȃ��ꍇ
			If Not Left(strLine, 1) = "'" And Len(strLine) > 0 Then
				If arraystrLine(0) = "bundle" Then
					'�z��ւ̒ǉ�
					countLine = countLine + 1
					ReDim Preserve arrayOutput(countLine)
					arrayOutput(countLine - 1) = arraystrLine(1)
				End If
			End If
		End If
	Loop


	'3. ���X�g�t�@�C�������
	Close #fp

	'4. �߂�l��z��ŕԂ�
	list2array = arrayOutput
End Function '}}}

Private Function isMemberOfVBEComponets(book As Workbook, moduleName As String) As Boolean '{{{
	'argument: moduleName like CodeManager
	'return: whether or not module is registered
	For Each Item In book.VBProject.VBComponents
		If Item.Name = moduleName Then
			isMemberOfVBEComponets = True
			Exit Function
		End If
	Next
	isMemberOfVBEComponets = False
End Function '}}}