Attribute VB_Name = "procurement_standardization"
Option Explicit

' ============================================================
' Module  : procurement_standardization.bas
' Project : Procurement Control Tower
' Company : PrimeHarvest Foods Brasil
' Author  : Igor Pereira Pinto
'
' Purpose:
'     Padronizar planilhas operacionais de Procurement antes
'     da ingestão analítica, garantindo consistência estrutural
'     e rastreabilidade de inconsistências encontradas.
'
' Pipeline:
'     [Excel operacional] → [Esta macro] → [File Intake → SQL]
'
' Ações executadas:
'     1. Criar aba de log de inconsistências
'     2. Padronizar cabeçalhos via mapa de aliases
'     3. Validar presença de colunas obrigatórias
'     4. Limpar espaços em branco por linha
'     5. Detectar e destacar valores críticos ausentes
'     6. Detectar e destacar valores numéricos inválidos
'     7. Detectar e destacar pedidos duplicados
'     8. Aplicar formatação básica na planilha e no log
'
' Convenção de cores no highlight:
'     Vermelho claro  RGB(255,199,206) → Campo crítico vazio
'     Amarelo claro   RGB(255,235,156) → Valor numérico inválido
'     Vermelho forte  RGB(255,153,153) → Pedido duplicado
'
' Notes:
'     - Código demonstrativo para portfólio.
'     - Estruturado para uso didático.
'     - Não representa implantação produtiva real.
' ============================================================


' ============================================================
' PROCEDURE PRINCIPAL
' ============================================================

Public Sub RunProcurementStandardization()

    Dim wsData          As Worksheet
    Dim wsLog           As Worksheet
    Dim lastRow         As Long
    Dim lastCol         As Long
    Dim i               As Long
    Dim headerMap       As Object
    Dim requiredHeaders As Variant
    Dim currentHeader   As String
    Dim missingHeaders  As String
    Dim logRow          As Long

    On Error GoTo ErrorHandler

    Application.ScreenUpdating = False
    Application.DisplayAlerts   = False

    ' ----------------------------------------------------------
    ' 1. Definir planilha de dados ativa
    ' ----------------------------------------------------------
    Set wsData = ActiveSheet

    ' ----------------------------------------------------------
    ' 2. Criar (ou recriar) aba de log de inconsistências
    ' ----------------------------------------------------------
    Call ResetLogSheet("log_inconsistencies")
    Set wsLog = ThisWorkbook.Worksheets("log_inconsistencies")

    ' Cabeçalhos da aba de log
    wsLog.Range("A1").Value = "row_number"
    wsLog.Range("B1").Value = "column_name"
    wsLog.Range("C1").Value = "issue_type"
    wsLog.Range("D1").Value = "issue_description"
    wsLog.Range("E1").Value = "logged_at"

    logRow = 2

    ' ----------------------------------------------------------
    ' 3. Identificar dimensões da planilha
    ' ----------------------------------------------------------
    lastRow = wsData.Cells(wsData.Rows.Count, 1).End(xlUp).Row
    lastCol = wsData.Cells(1, wsData.Columns.Count).End(xlToLeft).Column

    ' ----------------------------------------------------------
    ' 4. Padronizar cabeçalhos via mapa de aliases
    '    Converte variações comuns de nome para o padrão
    '    esperado pelo pipeline SQL (snake_case).
    ' ----------------------------------------------------------
    Set headerMap = CreateObject("Scripting.Dictionary")

    headerMap.Add "purchase order",     "purchase_order_id"
    headerMap.Add "po number",          "purchase_order_id"
    headerMap.Add "po line",            "purchase_order_line_id"
    headerMap.Add "supplier",           "supplier_id"
    headerMap.Add "supplier code",      "supplier_id"
    headerMap.Add "material",           "material_id"
    headerMap.Add "material code",      "material_id"
    headerMap.Add "category",           "category_name"
    headerMap.Add "order date",         "order_date"
    headerMap.Add "delivery date",      "delivery_date"
    headerMap.Add "qty",                "quantity"
    headerMap.Add "quantity",           "quantity"
    headerMap.Add "unit price",         "unit_price"
    headerMap.Add "total amount",       "total_amount"
    headerMap.Add "currency",           "currency_code"
    headerMap.Add "plant",              "plant_code"
    headerMap.Add "buyer",              "buyer_name"

    For i = 1 To lastCol
        currentHeader = LCase(Trim(CStr(wsData.Cells(1, i).Value)))

        If headerMap.Exists(currentHeader) Then
            ' Alias reconhecido: substituir pelo padrão definido
            wsData.Cells(1, i).Value = headerMap(currentHeader)
        Else
            ' Alias não mapeado: normalizar para snake_case
            wsData.Cells(1, i).Value = NormalizeHeader(CStr(wsData.Cells(1, i).Value))
        End If
    Next i

    ' ----------------------------------------------------------
    ' 5. Validar presença de colunas obrigatórias
    '    Se alguma estiver ausente, interromper o processo.
    ' ----------------------------------------------------------
    requiredHeaders = Array( _
        "purchase_order_id", _
        "supplier_id",       _
        "category_name",     _
        "order_date",        _
        "quantity",          _
        "unit_price",        _
        "total_amount"       _
    )

    missingHeaders = ValidateRequiredHeaders(wsData, requiredHeaders, lastCol)

    If missingHeaders <> "" Then
        MsgBox "As seguintes colunas obrigatórias estão ausentes:" _
             & vbCrLf & missingHeaders, vbCritical, "Erro de estrutura"
        GoTo SafeExit
    End If

    ' ----------------------------------------------------------
    ' 6. Limpeza básica de conteúdo (Trim por linha)
    ' ----------------------------------------------------------
    For i = 2 To lastRow
        Call TrimRowValues(wsData, i, lastCol)
    Next i

    ' ----------------------------------------------------------
    ' 7. Detectar e registrar inconsistências
    '    Cada check destaca visualmente e registra no log.
    ' ----------------------------------------------------------
    Call CheckMissingCriticalValues(wsData, wsLog, logRow, lastRow, lastCol)
    Call CheckInvalidNumericValues(wsData, wsLog, logRow, lastRow, lastCol)
    Call CheckDuplicatePurchaseOrders(wsData, wsLog, logRow, lastRow)

    ' ----------------------------------------------------------
    ' 8. Aplicar formatação básica
    ' ----------------------------------------------------------
    Call FormatStandardizedSheet(wsData, lastRow, lastCol)
    Call FormatLogSheet(wsLog)

    MsgBox "Padronização concluída com sucesso." _
         & vbCrLf & "Verifique a aba 'log_inconsistencies' para detalhes.", _
           vbInformation, "Procurement Control Tower"

SafeExit:
    Application.ScreenUpdating = True
    Application.DisplayAlerts   = True
    Exit Sub

ErrorHandler:
    Application.ScreenUpdating = True
    Application.DisplayAlerts   = True
    MsgBox "Erro durante a padronização: " & Err.Description, _
           vbCritical, "Erro inesperado"

End Sub


' ============================================================
' FUNÇÕES E PROCEDURES DE APOIO
' ============================================================

' ------------------------------------------------------------
' NormalizeHeader
' Converte cabeçalhos não mapeados para snake_case:
' espaços, hífens e barras são substituídos por underscore.
' ------------------------------------------------------------
Private Function NormalizeHeader(ByVal headerText As String) As String
    Dim result As String

    result = LCase(Trim(headerText))
    result = Replace(result, " ", "_")
    result = Replace(result, "-", "_")
    result = Replace(result, "/", "_")
    result = Replace(result, "__", "_")   ' evitar duplo underscore

    NormalizeHeader = result
End Function


' ------------------------------------------------------------
' ValidateRequiredHeaders
' Verifica se todas as colunas obrigatórias estão presentes.
' Retorna string com os nomes ausentes ou "" se tudo OK.
' ------------------------------------------------------------
Private Function ValidateRequiredHeaders( _
    ByVal ws             As Worksheet, _
    ByVal requiredHeaders As Variant, _
    ByVal lastCol        As Long) As String

    Dim i       As Long
    Dim j       As Long
    Dim found   As Boolean
    Dim missing As String

    missing = ""

    For i = LBound(requiredHeaders) To UBound(requiredHeaders)
        found = False

        For j = 1 To lastCol
            If Trim(LCase(CStr(ws.Cells(1, j).Value))) = _
               Trim(LCase(CStr(requiredHeaders(i)))) Then
                found = True
                Exit For
            End If
        Next j

        If Not found Then
            missing = missing & "- " & CStr(requiredHeaders(i)) & vbCrLf
        End If
    Next i

    ValidateRequiredHeaders = missing
End Function


' ------------------------------------------------------------
' TrimRowValues
' Remove espaços indevidos em todos os campos de uma linha.
' ------------------------------------------------------------
Private Sub TrimRowValues( _
    ByVal ws        As Worksheet, _
    ByVal rowNumber As Long, _
    ByVal lastCol   As Long)

    Dim j As Long

    For j = 1 To lastCol
        If Not IsEmpty(ws.Cells(rowNumber, j).Value) Then
            ws.Cells(rowNumber, j).Value = Trim(CStr(ws.Cells(rowNumber, j).Value))
        End If
    Next j
End Sub


' ------------------------------------------------------------
' CheckMissingCriticalValues
' Destaca em vermelho claro e registra no log qualquer campo
' crítico vazio em uma linha de dados.
' ------------------------------------------------------------
Private Sub CheckMissingCriticalValues( _
    ByVal wsData  As Worksheet, _
    ByVal wsLog   As Worksheet, _
    ByRef logRow  As Long, _
    ByVal lastRow As Long, _
    ByVal lastCol As Long)

    Dim requiredCols As Variant
    Dim colIndexes   As Object
    Dim i            As Long
    Dim headerName   As Variant
    Dim colNum       As Long

    requiredCols = Array( _
        "purchase_order_id", "supplier_id", "category_name", _
        "order_date", "quantity", "unit_price", "total_amount")

    Set colIndexes = MapHeaderIndexes(wsData, lastCol)

    For i = 2 To lastRow
        For Each headerName In requiredCols
            If colIndexes.Exists(headerName) Then
                colNum = colIndexes(headerName)

                If Trim(CStr(wsData.Cells(i, colNum).Value)) = "" Then
                    ' Highlight: campo crítico vazio
                    wsData.Cells(i, colNum).Interior.Color = RGB(255, 199, 206)

                    wsLog.Cells(logRow, 1).Value = i
                    wsLog.Cells(logRow, 2).Value = headerName
                    wsLog.Cells(logRow, 3).Value = "missing_critical_value"
                    wsLog.Cells(logRow, 4).Value = "Campo crítico vazio."
                    wsLog.Cells(logRow, 5).Value = Now
                    logRow = logRow + 1
                End If
            End If
        Next headerName
    Next i
End Sub


' ------------------------------------------------------------
' CheckInvalidNumericValues
' Destaca em amarelo claro e registra no log campos numéricos
' com valor não numérico (após normalização de vírgula/ponto).
' ------------------------------------------------------------
Private Sub CheckInvalidNumericValues( _
    ByVal wsData  As Worksheet, _
    ByVal wsLog   As Worksheet, _
    ByRef logRow  As Long, _
    ByVal lastRow As Long, _
    ByVal lastCol As Long)

    Dim numericCols As Variant
    Dim colIndexes  As Object
    Dim i           As Long
    Dim headerName  As Variant
    Dim colNum      As Long
    Dim valueText   As String

    numericCols = Array("quantity", "unit_price", "total_amount")
    Set colIndexes = MapHeaderIndexes(wsData, lastCol)

    For i = 2 To lastRow
        For Each headerName In numericCols
            If colIndexes.Exists(headerName) Then
                colNum    = colIndexes(headerName)
                valueText = Replace(Trim(CStr(wsData.Cells(i, colNum).Value)), ",", ".")

                If valueText <> "" Then
                    If Not IsNumeric(valueText) Then
                        ' Highlight: valor numérico inválido
                        wsData.Cells(i, colNum).Interior.Color = RGB(255, 235, 156)

                        wsLog.Cells(logRow, 1).Value = i
                        wsLog.Cells(logRow, 2).Value = headerName
                        wsLog.Cells(logRow, 3).Value = "invalid_numeric_value"
                        wsLog.Cells(logRow, 4).Value = "Valor numérico inválido."
                        wsLog.Cells(logRow, 5).Value = Now
                        logRow = logRow + 1
                    End If
                End If
            End If
        Next headerName
    Next i
End Sub


' ------------------------------------------------------------
' CheckDuplicatePurchaseOrders
' Destaca em vermelho forte e registra no log pedidos com
' purchase_order_id repetido na planilha.
' ------------------------------------------------------------
Private Sub CheckDuplicatePurchaseOrders( _
    ByVal wsData  As Worksheet, _
    ByVal wsLog   As Worksheet, _
    ByRef logRow  As Long, _
    ByVal lastRow As Long)

    Dim colIndexes As Object
    Dim poCol      As Long
    Dim dict       As Object
    Dim i          As Long
    Dim poValue    As String

    Set colIndexes = MapHeaderIndexes( _
        wsData, wsData.Cells(1, wsData.Columns.Count).End(xlToLeft).Column)

    If Not colIndexes.Exists("purchase_order_id") Then Exit Sub

    poCol = colIndexes("purchase_order_id")
    Set dict = CreateObject("Scripting.Dictionary")

    For i = 2 To lastRow
        poValue = Trim(CStr(wsData.Cells(i, poCol).Value))

        If poValue <> "" Then
            If dict.Exists(poValue) Then
                ' Highlight: pedido duplicado
                wsData.Cells(i, poCol).Interior.Color = RGB(255, 153, 153)

                wsLog.Cells(logRow, 1).Value = i
                wsLog.Cells(logRow, 2).Value = "purchase_order_id"
                wsLog.Cells(logRow, 3).Value = "duplicate_purchase_order"
                wsLog.Cells(logRow, 4).Value = "Pedido duplicado identificado: " & poValue
                wsLog.Cells(logRow, 5).Value = Now
                logRow = logRow + 1
            Else
                dict.Add poValue, 1
            End If
        End If
    Next i
End Sub


' ------------------------------------------------------------
' MapHeaderIndexes
' Constrói um dicionário {nome_coluna: índice} para acesso
' eficiente aos campos durante os checks.
' ------------------------------------------------------------
Private Function MapHeaderIndexes( _
    ByVal ws      As Worksheet, _
    ByVal lastCol As Long) As Object

    Dim dict       As Object
    Dim j          As Long
    Dim headerName As String

    Set dict = CreateObject("Scripting.Dictionary")

    For j = 1 To lastCol
        headerName = Trim(LCase(CStr(ws.Cells(1, j).Value)))
        If headerName <> "" Then
            If Not dict.Exists(headerName) Then
                dict.Add headerName, j
            End If
        End If
    Next j

    Set MapHeaderIndexes = dict
End Function


' ------------------------------------------------------------
' ResetLogSheet
' Remove a aba de log se já existir e recria do zero,
' garantindo que cada execução produza um log limpo.
' ------------------------------------------------------------
Private Sub ResetLogSheet(ByVal logSheetName As String)
    Dim ws As Worksheet

    On Error Resume Next
    Set ws = ThisWorkbook.Worksheets(logSheetName)
    On Error GoTo 0

    If Not ws Is Nothing Then
        Application.DisplayAlerts = False
        ws.Delete
        Application.DisplayAlerts = True
    End If

    ThisWorkbook.Worksheets.Add( _
        After:=ThisWorkbook.Worksheets(ThisWorkbook.Worksheets.Count) _
    ).Name = logSheetName
End Sub


' ------------------------------------------------------------
' FormatStandardizedSheet
' Aplica formatação básica na planilha de dados:
' autofit nas colunas e destaque nos cabeçalhos.
' ------------------------------------------------------------
Private Sub FormatStandardizedSheet( _
    ByVal ws      As Worksheet, _
    ByVal lastRow As Long, _
    ByVal lastCol As Long)

    ws.Range(ws.Cells(1, 1), ws.Cells(lastRow, lastCol)).EntireColumn.AutoFit

    With ws.Range(ws.Cells(1, 1), ws.Cells(1, lastCol))
        .Font.Bold       = True
        .Interior.Color  = RGB(217, 225, 242)
    End With
End Sub


' ------------------------------------------------------------
' FormatLogSheet
' Aplica formatação básica na aba de log:
' autofit e destaque nos cabeçalhos.
' ------------------------------------------------------------
Private Sub FormatLogSheet(ByVal ws As Worksheet)
    Dim lastCol As Long

    lastCol = ws.Cells(1, ws.Columns.Count).End(xlToLeft).Column

    With ws.Range(ws.Cells(1, 1), ws.Cells(1, lastCol))
        .Font.Bold      = True
        .Interior.Color = RGB(242, 242, 242)
    End With

    ws.Columns.AutoFit
End Sub
