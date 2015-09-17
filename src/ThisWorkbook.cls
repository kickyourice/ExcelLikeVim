VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ThisWorkbook"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
'���C�u�������X�g�̐ݒ� (�ݒu�t�H���_�̓��[�N�u�b�N�Ɠ����f�B���N�g��)
Const FILENAME_LIBLIST As String = "libdef.txt" '���C�u�������X�g�̃t�@�C����
Const REGISTRY_BOOK As String = "register.xlsx"

'----------------------------- Workbook_open() ---------------
Private Sub Workbook_Open() '{{{
    Call import_vbundle
    Application.Run "updateModulesOfBook", "", True
    Application.Run "initializeApplication"
		'Application.Run "read_setting", "thisworkbook.path.vimxrc" 'default
		'Application.Run "read_setting", "~/.vimxrc" 'user
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

Private Sub import_vbundle() '{{{
    Set myFSO = CreateObject("Scripting.FileSystemObject")
    modPath = absPath("./src/vbundle.bas")
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
