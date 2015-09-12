VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} UniteInterface 
	Caption         =   "Unite"
	ClientHeight    =   7185
	ClientLeft      =   45
	ClientTop       =   375
	ClientWidth     =   15330
	OleObjectBlob   =   "UniteInterface.frx":0000
	StartUpPosition =   1  '�I�[�i�[ �t�H�[���̒���
End
Attribute VB_Name = "UniteInterface"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'-----------------Below this line , Write down code-----------------------------------
Private Sub UserForm_Initialize() '{{{
	ListBox1.MultiSelect = fmMultiSelectMulti
	' ListBox1.MultiSelect = fmMultiSelectExtended
	' ListBox1.ListStyle = fmListStyleOption 
	Me.ListBox1.Clear
	For Each buf In UniteCandidatesList
		Me.ListBox1.AddItem Split(buf, ":::")(0)
	Next buf
	
	TextBox1.SetFocus
End Sub '}}}

Private Sub TextBox1_Change() '{{{
	Set RE = CreateObject("VBScript.RegExp")
	RE.IgnoreCase = True
	patternlist = Split(Replace(Me.TextBox1, "�@", " "), " ")
	'���X�g�{�b�N�X�̓��e��������
	Me.ListBox1.Clear
	'GatherCandidate�ŏW�߂����X�g���p�^�[���}�b�`���O
	For Each buf In UniteCandidatesList
		hit = True
		buf = Split(buf, ":::")(0)
		'pattern�ɑ΂��ăe�X�g���J��Ԃ��
		For i = 0 To UBound(patternlist)
			RE.pattern = patternlist(i)
			'migemo version. too late
			'Dim buf2 As String: buf2 = patternlist(i)
			'RE.pattern = migemize(buf2) 'migemo version
			If Not RE.test(buf) Then
				hit = False
			End If
		Next i
		If hit Then
			Me.ListBox1.AddItem buf
		End If
	Next buf
End Sub '}}}

Private Sub TextBox1_KeyDown(ByVal KeyCode As MSForms.ReturnInteger, ByVal shift As Integer) '{{{
	If KeyCode = 27 Then 'ESC���̋���
		If TextBox1.Text = "" Or Me.ListBox1.ListCount = 0 Then
		' If TextBox1.Text = "" Then
			Unload Me
		Else
			ListBox1.SetFocus
			Me.ListBox1.ListIndex = 0
		End If
	End If

	If KeyCode = 40 Then '�����̋���
		ListBox1.SetFocus
		Me.ListBox1.ListIndex = 0
	End If
End Sub '}}}

Private Sub ListBox1_KeyDown(ByVal KeyCode As MSForms.ReturnInteger, ByVal shift As Integer) '{{{
	' If KeyCode = 13 And Not ListBox1.Text = "" Then 'Enter���̋���
	If KeyCode = 13 Then 'Enter���̋���
		Me.Hide
		With Me.ListBox1
			selectCount = 0
			Dim selected As String
			For i = 0 To .ListCount - 1
				If .Selected(i) = True Then
					selected = selected & .List(i) & vbCrLf
					selectCount = selectCount + 1
				End If
			Next i

			If selectCount > 0 Then
				selected = Left(selected, Len(selected)-2) '������vbCrLf���폜
			Else
				selected = .List(.ListIndex)
			End If

			Call Application.Run("defaultAction_" & unite_source, selected)
		End With
		Unload Me
	End If

	'http://www.accessclub.jp/samplefile/help/help_154_1.htm keycode
	If KeyCode = 27 Then 'ESC���̋���
		Unload Me
	End If

	If KeyCode = vbKeyA Then 'a
		Me.TextBox1.SetFocus
	End If

	If KeyCode = vbKeyI Then 'i
		Me.TextBox1.SetFocus
	End If

	If KeyCode = 191 Then '/
		Me.TextBox1.SetFocus
	End If

	If KeyCode = vbkeyK Then 'k
		SendKeys "{UP}"
	End If

	If KeyCode = vbKeyJ Then 'j
		SendKeys "{DOWN}"
	End If

	If KeyCode = vbKeyF Then 'i
		SendKeys " "
		SendKeys "{DOWN}"
	End If

	If KeyCode = vbkeyY Then 'y
		Me.Hide
		With New MSForms.DataObject
			.SetText Me.ListBox1.List(Me.ListBox1.ListIndex) '�ϐ��̒l��DataObject�Ɋi�[����
			.PutInClipboard   'DataObject�̃f�[�^���N���b�v�{�[�h�Ɋi�[����
		End With
		Unload Me
	End If

	If KeyCode = vbkeyTab Then 'tab commnad box
		With Me.ListBox1
			selectCount = 0
			For i = 0 To .ListCount - 1
				If .Selected(i) = True Then
					unite_argument = unite_argument & .List(i) & vbCrLf
					selectCount = selectCount + 1
				End If
			Next i

			If selectCount > 0 Then
				unite_argument = Left(unite_argument, Len(unite_argument)-2) '������vbCrLf���폜
			Else
				unite_argument = .List(.ListIndex)
			End If

			Set UniteCandidatesList = Application.Run("GatherCandidates_command")
			unite_source = "command_parent"
			Unload Me
			Set commandForm = New UniteInterface
			commandForm.Show
		End With
	End If

End Sub '}}}

Private Sub ListBox1_DblClick(ByVal Cancel As MSForms.ReturnBoolean) '{{{
	'���X�g�{�b�N�X�̒l���_�u���N���b�N�����Ƃ��Ɏ��s����R�[�h
	Dim buf As String
	'���X�g�{�b�N�X�̒l��ϐ�buf�Ɋi�[����
	buf = Me.ListBox1.value
	'���b�Z�[�W�{�b�N�X�Ƀ��X�g�{�b�N�X�̒l��\������
	MsgBox buf & "��I�����܂����B"
End Sub '}}}
