#include-once
#include <Color.au3>
#include <Array.au3>
#include <WinAPI.au3>
#include <WindowsConstants.au3>
#include <GUIConstants.au3>
#include <GDIPlus.au3>
#include <GUICtrlOnHover.au3>
#include <AutoitObject.au3>
#include <CoProc.au3>

Global Const $fDefFont = "Segoe UI"
Global Const $szBtn = 16
Global Const $szLb = 13
Global Const $szTitle = 13
Global Const $szInput = 14

Global Const $cDark = 0x36393f
Global Const $cTitle = 0x202225
Global Const $cBlack = 0x0
Global Const $cLightDark1 = 0x404040
Global Const $cLightDark2 = 0x686c72
Global Const $cLightDark3 = 0x484c52
Global Const $cCyan = 0x2956A3
Global Const $cBlue = 0x0064C8
Global Const $cCyanDark = $cCyan + 0x101010
Global Const $cWhite = 0xFFFFFF
Global Const $cGold = 0xFFD41E
Global Const $cRed = 0xD50844
Global Const $cRedLight = 0xF52864
Global Const $cLightGreen = 0x3CAEA3
Global Const $cDarkRed = 0x801017
Global Const $cDarkGreen = 0x577177
Global Const $cGreen = 0x99c24d

Global $aHGUI[0], $__aCtrls[0], $__currentInputFocus, $__loadingPic[0], $__iPerLoading = 0


_AutoitObject_Startup()
_GDIPlus_Startup()
GUICreate("c1783f3ad0e73a0accdeacac4158a6d5")
GUIRegisterMsg($WM_COPYDATA, "__CallBackThread") ; for streaming image

Func _GUICreate($Title = "", $w = 400, $h = 450, $l = -1, $t = -1, $style = -1, $ex = -1, $parent = 0, $min = True)

	If $style = -1 Then $style = $WS_POPUP
	Local $GUI = GUICreate($Title, $w, $h, $l, $t, $style, $ex, $parent)
	GUISetBkColor($cDark)
	GUICtrlSetDefBkColor(-2, $GUI)
	GUICtrlSetDefColor($cWhite, $GUI)

	Local $lbDrag = GUICtrlCreateLabel("", 0, 0, $w - 70, 35, -1, $GUI_WS_EX_PARENTDRAG)
	GUICtrlSetBkColor($lbDrag, $cTitle)

	Local $lbTitle = GUICtrlCreateLabel($Title, 15, 5, $w - 85, 30)
	GUICtrlSetState($lbTitle, 2048)
	GUICtrlSetFont($lbTitle, $szTitle, 500, 0, $fDefFont, 5)

	Local $btnClose = _GUICtrlCreateButton("⬤", $w - 35, 0, 35, 35, $cTitle)
	_GUICtrlSetBkColorHover(-1, $cRed)
	GUICtrlSetFont(-1, 10, 900, Default, "Segoe UI", 5)
	_GUICtrl_OnHoverRegister(-1, "_HGUI_CtrlHover", "_HGUI_CtrlLeave", "_HGUI_CtrlClickDown", "_HGUI_BtnClose", 0, 0)

	Local $box = _GUICtrlCreateBox($w - 35, 0, 35, 35, -2)
	_GUICtrlSetBoxColorHover($box, $cLightDark2)
	_GUICtrlSetAttach($btnClose, $box)

	Local $btnMin = _GUICtrlCreateButton("–", $w - 70, 0, 35, 35, $cTitle)
	_GUICtrlSetBkColorHover(-1, $cBlue)
	GUICtrlSetFont(-1, 15, 900, Default, "Segoe UI", 5)
	_GUICtrl_OnHoverRegister(-1, "_HGUI_CtrlHover", "_HGUI_CtrlLeave", "_HGUI_CtrlClickDown", "_HGUI_BtnMin", 0, 0)

	Local $boxmin = _GUICtrlCreateBox($w - 70, 0, 35, 35, -2)
	_GUICtrlSetBoxColorHover($boxmin, $cLightDark2)
	_GUICtrlSetAttach($btnMin, $boxmin)

	_GUICtrlCreateBox(0, 0, $w, $h, $cLightDark2)

	GUIRegisterMsg($WM_COMMAND, "__HGUI_TABINPUT")
	GUIRegisterMsg($WM_SYSCOMMAND, "__HGUI_RESTORE")
	GUIRegisterMsg($WM_TIMER, "__HGUI_LOADINGPIC")
	DllCall("user32.dll", "int", "SetTimer", "hwnd", $GUI, "int", 0, "int", 30, "int", 0)
	_ArrayAdd($aHGUI, $GUI)
	Return $GUI

EndFunc

Func _GUICtrlCreateButton($text, $x, $y, $w, $h, $cBk = $cBlue, $cText = $cWhite)

	Local $attach[0]
	Local $ctrl = GUICtrlCreateLabel($text, $x, $y, $w, $h, $ES_CENTER + $SS_CENTERIMAGE)
	GUICtrlSetBkColor(-1, $cBk)
	GUICtrlSetColor(-1, $cText)
	GUICtrlSetFont(-1, $szBtn, 500, 0, $fDefFont, 5)
	_GUICtrl_OnHoverRegister(-1, "_HGUI_CtrlHover", "_HGUI_CtrlLeave", "_HGUI_CtrlClickDown", "_HGUI_CtrlHover", 0, 0)

	Local $oCtrl = IDIspatch()
	$oCtrl.__add("parent", _WinAPI_GetParent(GUICtrlGetHandle($ctrl)))
	$oCtrl.__add("type", "btn")
	$oCtrl.__add("attach", $attach)
	$oCtrl.__add("ctrl", $ctrl)
	$oCtrl.__add("cBk", $cBk)
	$oCtrl.__add("cBkHover", __colorgetdim($cBk, 20))
	$oCtrl.__add("cBkClick", __colorgetdim($cBk, -10))
	$oCtrl.__add("cText", $cText)
	$oCtrl.__add("cTextHover", $cText)
	$oCtrl.__add("cTextClick", $cText)
	_ArrayAdd($__aCtrls, $oCtrl)

	Return $ctrl
EndFunc

Func _GUICtrlCreateLabel($text, $x, $y, $w = -1, $h = -1, $cBk = -2, $cText = $cWhite)

	If $w = -1 Or $h = -1 Then
		Local $size = _StringInPixels("", $text, $fDefFont, $szLb,0 )
		If IsArray($size) = False Then
			Local $size[2] = [$w, $h]
		EndIf
		$size[0] = $w = -1 ? $size[0] : $w
		$size[1] = $h = -1 ? $size[1] : $h
	Else
		Local $size[2] = [$w, $h]
	EndIf

	Local $ctrl = GUICtrlCreateLabel($text, $x, $y, $size[0], $size[1])
	GUICtrlSetBkColor(-1, $cBk)
	GUICtrlSetColor(-1, __colorgetdim($cText, -20))
	GUICtrlSetFont(-1, $szLb, 400, 0, $fDefFont, 5)
	_GUICtrl_OnHoverRegister(-1, "_HGUI_CtrlHover", "_HGUI_CtrlLeave", "_HGUI_CtrlClickDown", "_HGUI_CtrlHover", 0, 0)

	Local $oCtrl = IDIspatch(), $attach[0]
	$oCtrl.__add("parent", _WinAPI_GetParent(GUICtrlGetHandle($ctrl)))
	$oCtrl.__add("type", "lb")
	$oCtrl.__add("ctrl", $ctrl)
	$oCtrl.__add("attach", $attach)
	$oCtrl.__add("cBk", $cBk)
	$oCtrl.__add("cBkHover", __colorgetdim($cBk, 20))
	$oCtrl.__add("cBkClick", __colorgetdim($cBk, -10))
	$oCtrl.__add("cText", __colorgetdim($cText, -20))
	$oCtrl.__add("cTextHover", $cText)
	$oCtrl.__add("cTextClick", __colorgetdim($cText, -10))
	_ArrayAdd($__aCtrls, $oCtrl)

	Return $ctrl
EndFunc

Func _GUICtrlCreateInput($text, $x, $y, $w = 200, $h = 30, $cBk = $cLightDark3, $cText = $cWhite, $cBox = -2)

	Local $attach[1] = [_GUICtrlCreateBox($x - 1, $y - 1, $w + 2, $h + 2, $cLightDark2)]
	Local $ctrl = GUICtrlCreateInput($text, $x, $y, $w, $h, -1, $WS_EX_LAYERED)
	GUICtrlSetBkColor(-1, $cBk)
	GUICtrlSetColor(-1, $cText)
	GUICtrlSetFont(-1, $szInput, 400, 0, $fDefFont, 5)
	_GUICtrl_OnHoverRegister(-1, "_HGUI_CtrlHover", "_HGUI_CtrlLeave", "_HGUI_CtrlClickDown", "", 0)

	Local $oCtrl = IDIspatch()
	$oCtrl.__add("parent", _WinAPI_GetParent(GUICtrlGetHandle($ctrl)))
	$oCtrl.__add("type", "input")
	$oCtrl.__add("ctrl", $ctrl)
	$oCtrl.__add("attach", $attach)
	$oCtrl.__add("cBk", $cBk)
	$oCtrl.__add("cBkHover", __colorgetdim($cBk, 30))
	$oCtrl.__add("cBkClick", __colorgetdim($cBk, -10))
	$oCtrl.__add("cText", $cText)
	$oCtrl.__add("cTextHover", $cText)
	$oCtrl.__add("cTextClick", $cText)
	$oCtrl.__add("placeholder")
	_ArrayAdd($__aCtrls, $oCtrl)

	Return $ctrl
EndFunc

Func _GUICtrlCreateBox($l, $t, $w, $h, $color = $cWhite, $size = 1)

	Local $ret[4], $attach[0]
	Local $colorH = $color
	$color = __colorgetdim($color, - 20)
	$ret[0] = GUICtrlCreateLabel("", $l, $t, $w, $size)
	GUICtrlSetBkColor(-1, $color)
	$ret[1] = GUICtrlCreateLabel("", $l, $t, $size, $h)
	GUICtrlSetBkColor(-1, $color)
	$ret[2] = GUICtrlCreateLabel("", $l + $w - $size, $t, $size, $h)
	GUICtrlSetBkColor(-1, $color)
	$ret[3] = GUICtrlCreateLabel("", $l, $t + $h - $size, $w, $size)
	GUICtrlSetBkColor(-1, $color)
	For $re In $ret
		GUICtrlSetState($re, 2048)
	Next

	Local $oCtrl = IDIspatch()
	$oCtrl.__add("parent", _WinAPI_GetParent(GUICtrlGetHandle($ret[0])))
	$oCtrl.__add("type", "box")
	$oCtrl.__add("ctrl", $ret[0])
	$oCtrl.__add("boxes", $ret)
	$oCtrl.__add("attach", $attach)
	$oCtrl.__add("cBk", $color)
	$oCtrl.__add("cBkHover", $colorH)
	$oCtrl.__add("cBkClick", __colorgetdim($color, -10))
	_ArrayAdd($__aCtrls, $oCtrl)
	Return $ret[0]
EndFunc

Func _GUICtrlCreatePic($Pic, $x, $y, $w = -1, $h = -1, $scale = -1, $fit = 0, $isHover = True)

	Local $ctrl = GUICtrlCreatePic("", $x, $y, $w, $h), $attach[0]
	If $isHover Then _GUICtrl_OnHoverRegister(-1, "_HGUI_CtrlHover", "_HGUI_CtrlLeave", "_HGUI_CtrlClickDown", "_HGUI_CtrlHover", 0)

	Local $oCtrl = IDIspatch()
	$oCtrl.__add("parent", _WinAPI_GetParent(GUICtrlGetHandle($ctrl)))
	$oCtrl.__add("w", $w)
	$oCtrl.__add("h", $h)
	$oCtrl.__add("scale", $scale)
	$oCtrl.__add("fit", False)
	$oCtrl.__add("loading", False)
	$oCtrl.__add("type", "pic")
	$oCtrl.__add("ctrl", $ctrl)
	$oCtrl.__add("attach", $attach)
	$oCtrl.__add("bitmap", False)
	$oCtrl.__add("bitmapHover", False)
	$oCtrl.__add("bitmapClick", False)
	_ArrayAdd($__aCtrls, $oCtrl)
	_GUICtrlSetImage($ctrl, $Pic, $w, $h, $scale, $fit)
	Return $ctrl
EndFunc

Func _GUICtrlSetImage($ctrl, $Pic, $w = -1, $h = -1, $scale = -1, $fit = 0)
	Local $oCtrl = __CtrlGetObject($ctrl), $isDelete = False, $size
	If IsObj($oCtrl) = False Or $oCtrl.type <> "pic" Then Return

	If $w = -100 Or $h = -100 Then
		$w = $oCtrl.w
		$h = $oCtrl.h
		$scale = $oCtrl.scale
		$fit = $oCtrl.fit
		$isDelete = True
		If $oCtrl.loading = True Then
			__LOADINGDELTE($oCtrl)
			$oCtrl.loading = False
		EndIf
	EndIf

	$oCtrl.w = $w
	$oCtrl.h = $h
	$oCtrl.scale = $scale
	$oCtrl.fit = $fit
	If StringLeft($pic, 4) = "http" Or StringInStr($pic, "/") Then
		_ArrayAdd($__loadingPic, $oCtrl)
		$oCtrl.loading = True

		Local $data[2] = [String($ctrl), $pic]
		Return _CoProc("__StreamImageURL", _DataEncode($data))
	EndIf
;~ 	MsgBox(0,"",$pic)
	_GDIPlus_BitmapDispose($oCtrl.bitmap)
	_GDIPlus_BitmapDispose($oCtrl.bitmapClick)
	_GDIPlus_BitmapDispose($oCtrl.bitmapHover)

	$pic = FileExists($pic) ? _GDIPlus_ImageLoadFromFile($Pic) : $pic
	If $fit > 0 Then
		$size = __ImageResizeFit($Pic, $w, $h, $fit = 2)
	Else
		$size = __ImageResizeScale($pic, $w, $h, $scale)
	EndIf

	$oCtrl.bitmap = $pic
	$oCtrl.bitmapHover = _GDIPlus_ImageClone($oCtrl.bitmap)
	$oCtrl.bitmapClick = _GDIPlus_ImageClone($oCtrl.bitmap)
	Local $effect = _GDIPlus_EffectCreateBrightnessContrast(30)
	Local $effect2 = _GDIPlus_EffectCreateBrightnessContrast(15, 30)
	_GDIPlus_BitmapApplyEffect($oCtrl.bitmapHover, $effect)
	_GDIPlus_BitmapApplyEffect($oCtrl.bitmapClick, $effect2)
	_GDIPlus_EffectDispose($effect)
	_GDIPlus_EffectDispose($effect2)

	__GUICtrlPic_SetImage($ctrl, $oCtrl.bitmap)
	If $isDelete Then FileDelete($pic)
EndFunc

Func __ImageResizeFit(ByRef $bitmap, $w, $h, $crop = True)
	Local $size = _GDIPlus_ImageGetDimension($bitmap)

	If IsArray($size) = False Then Return False

	Local $dW = $size[0] / $w, $dH = $size[1] / $h, $newW = $w, $newH = $h
	Local $hResult, $hResultTmp

	If $dw < $dH Then
		$newH = Int($size[1] * ($w / $size[0]))
	Else
		$newW = Int($size[0] * ($h / $size[1]))
	EndIf

	$hResultTmp = _GDIPlus_ImageResize($bitmap, $newW ,$newH)

	$hResult = $crop ? _GDIPlus_BitmapCloneArea($hResultTmp, ($newW - $w) / 2, ($newH - $h) / 2, $w, $h) : _GDIPlus_ImageClone($hResultTmp)
	_GDIPlus_ImageDispose($bitmap)
	_GDIPlus_ImageDispose($hResultTmp)

	$bitmap = $hResult
	Return _GDIPlus_ImageGetDimension($hResult)
EndFunc

Func __GUICtrlPic_SetImage($hPic, $bitmap)
	Local $Bmp = _GDIPlus_BitmapCreateHBITMAPFromBitmap($bitmap)

	_WinAPI_DeleteObject(GUICtrlSendMsg($hPic, $STM_SETIMAGE, $IMAGE_BITMAP, $Bmp))
	_WinAPI_DeleteObject($Bmp)
	GUICtrlSetState($hPic, GUICtrlGetState($hPic))
EndFunc

Func _GUICtrlSetPlaceHolder($ctrl, $placeholder)
	Local $oCtrl = __CtrlGetObject($ctrl)
	If IsObj($oCtrl) = False Or $oCtrl.type <> "input" Then Return
	$oCtrl.placeholder = $placeholder
	If GUICtrlRead($ctrl) = "" Then
		GUICtrlSetData($oCtrl.ctrl, $oCtrl.placeholder)
		GUICtrlSetColor($oCtrl.ctrl, __colorgetdim($oCtrl.cText, - 30))
	EndIf
EndFunc

Func _GUICtrlSetAttach($CtrlParent, $CtrlChild, $attach = True)
	Local $oCtrl = __CtrlGetObject($CtrlParent)
	If IsObj($oCtrl) = False Then Return
	Local $att = $oCtrl.attach
	_ArrayAdd($att, $CtrlChild)
	$oCtrl.attach = $att

EndFunc

Func _GUICtrlSetColor($ctrl, $color, $autoHover = True)
	Local $oCtrl = __CtrlGetObject($ctrl)
	If IsObj($oCtrl) = False Then Return

	If $oCtrl.type = "btn" Then
		$oCtrl.cText = $color
		$oCtrl.cTextHover = $color

	ElseIf $oCtrl.type = "lb" Then
		$oCtrl.cText = $autoHover ? __colorgetdim($color, -20) : $color
		If $autoHover Then
			$oCtrl.cTextHover = $color
			$oCtrl.cTextClick = __colorgetdim($color, -10)
		EndIf
	EndIf

	GUICtrlSetColor($oCtrl.ctrl, $oCtrl.cText)
EndFunc

Func _GUICtrlSetBkColor($ctrl, $color, $autoHover = True)
	Local $oCtrl = __CtrlGetObject($ctrl)
	If IsObj($oCtrl) = False Then Return

	$oCtrl.cBk = $color
	If $autoHover Then
		$oCtrl.cBkHover = __colorgetdim($color, 20)
		$oCtrl.cBkClick = __colorgetdim($color, -10)
	EndIf
	GUICtrlSetBkColor($oCtrl.ctrl, $oCtrl.cBk)
EndFunc

Func _GUICtrlSetBkColorHover($ctrl, $color)
	Local $oCtrl = __CtrlGetObject($ctrl)
	If IsObj($oCtrl) = False Then Return
	$oCtrl.cBkHover = $color
	$oCtrl.cBkClick = __colorgetdim($color, -30)
EndFunc

Func _GUICtrlSetColorHover($ctrl, $color)
	Local $oCtrl = __CtrlGetObject($ctrl)
	If IsObj($oCtrl) = False Then Return
	$oCtrl.cTextHover = $color
	$oCtrl.cTextClick = __colorgetdim($color, -30)
EndFunc

Func _GUICtrlSetBoxColor($ctrl, $color, $autoHover = True)
	Local $oCtrl = __CtrlGetObject($ctrl)
	If IsObj($oCtrl) = False Then Return

	If $oCtrl.type = "box" Then
		$oCtrl.cBk = $autoHover ? __colorgetdim($color, - 20) : $color
		If $autoHover Then $oCtrl.cBkHover = $color
		For $box In $oCtrl.boxes
			GUICtrlSetBkColor($box, $oCtrl.cBk)
		Next
	EndIf
EndFunc

Func _GUICtrlSetBoxColorHover($ctrl, $color)
	Local $oCtrl = __CtrlGetObject($ctrl)
	If IsObj($oCtrl) = False Then Return

	If $oCtrl.type = "box" Then
		$oCtrl.cBkHover = $color
		$oCtrl.cBkClick = __colorgetdim($color, -30)
	EndIf
EndFunc

Func _HGUI_CtrlHover($ctrl)
	Local $oCtrl = __CtrlGetObject($ctrl)
	If IsObj($oCtrl) = False Then Return

	Switch $oCtrl.type
		Case "box"
			For $i = 0 To UBound($oCtrl.boxes) - 1
				GUICtrlSetBkColor($oCtrl.boxes[$i], $oCtrl.cBkHover)
			Next
		Case "pic"
			If $oCtrl.loading = False Then __GUICtrlPic_SetImage($ctrl, $oCtrl.bitmapHover)
		Case Else
			If $oCtrl.type = "input" Then
				If GUICtrlRead($oCtrl.ctrl) <> $oCtrl.placeholder Then GUICtrlSetColor($oCtrl.ctrl, $oCtrl.cTextHover)
			Else
				GUICtrlSetColor($oCtrl.ctrl, $oCtrl.cTextHover)
			EndIf
			GUICtrlSetBkColor($oCtrl.ctrl, $oCtrl.cBkHover)
	EndSwitch

	For $attach In $oCtrl.attach
		_HGUI_CtrlHover($attach)
	Next
EndFunc

Func _HGUI_CtrlLeave($ctrl)
	Local $oCtrl = __CtrlGetObject($ctrl)
	If IsObj($oCtrl) = False Then Return


	Switch $oCtrl.type

		Case "box"
			For $i = 0 To UBound($oCtrl.boxes) - 1
				GUICtrlSetBkColor($oCtrl.boxes[$i], $oCtrl.cBk)
			Next
		Case "pic"
			If $oCtrl.loading = False Then __GUICtrlPic_SetImage($ctrl, $oCtrl.bitmap)
		Case "input"
			If _WinAPI_GetFocus() <> GUICtrlGetHandle($ctrl) Then
				If GUICtrlRead($ctrl) <> $oCtrl.placeholder Then GUICtrlSetColor($oCtrl.ctrl, $oCtrl.cText)
				GUICtrlSetBkColor($oCtrl.ctrl, $oCtrl.cBk)
				If GUICtrlRead($oCtrl.ctrl) = "" Then
					GUICtrlSetData($oCtrl.ctrl, $oCtrl.placeholder)
					GUICtrlSetColor($oCtrl.ctrl, __colorgetdim($oCtrl.cText, - 30))
				EndIf
			EndIf
		Case Else
			GUICtrlSetColor($oCtrl.ctrl, $oCtrl.cText)
			GUICtrlSetBkColor($oCtrl.ctrl, $oCtrl.cBk)
	EndSwitch

	For $attach In $oCtrl.attach
		_HGUI_CtrlLeave($attach)
	Next
EndFunc

Func _HGUI_CtrlClickDown($ctrl)
	Local $oCtrl = __CtrlGetObject($ctrl)
	If IsObj($oCtrl) = False Then Return

	Switch $oCtrl.type
		Case "box"
			For $i = 0 To UBound($oCtrl.boxes) - 1
				GUICtrlSetBkColor($oCtrl.boxes[$i], $oCtrl.cBkClick)
			Next
		Case "pic"
			If $oCtrl.loading = False Then __GUICtrlPic_SetImage($ctrl, $oCtrl.bitmapClick)
		Case "input"
			_HGUI_CtrlLeave($__currentInputFocus)
			$__currentInputFocus = $ctrl
			_HGUI_CtrlHover($ctrl)
			If GUICtrlRead($ctrl) = $oCtrl.placeholder Then GUICtrlSetData($ctrl, "")
		Case Else
			GUICtrlSetColor($oCtrl.ctrl, $oCtrl.cTextClick)
			GUICtrlSetBkColor($oCtrl.ctrl, $oCtrl.cBkClick)
	EndSwitch

	For $attach In $oCtrl.attach
		_HGUI_CtrlClickDown($attach)
	Next
EndFunc

Func _HGUI_BtnClose($ctrl)
	Local $oCtrl = __CtrlGetObject($ctrl)
	If IsObj($oCtrl) = False Then Return
	ControlSend(_WinAPI_GetParent(GUICtrlGetHandle($ctrl)), "", "", "{ESC}")
	_HGUI_CtrlHover($ctrl)
EndFunc

Func _HGUI_BtnMin($ctrl)
	Local $oCtrl = __CtrlGetObject($ctrl)
	If IsObj($oCtrl) = False Then Return
	WinSetState(_WinAPI_GetParent(GUICtrlGetHandle($ctrl)), "", @SW_MINIMIZE)
	_HGUI_CtrlHover($ctrl)
EndFunc

Func __CtrlGetObject($ctrl)
	If $ctrl = -1 Then $ctrl = _GUIGetLastCtrlID()
	If $ctrl = False Then Return False
	For $i = 0 To UBound($__aCtrls) - 1
		If IsObj($__aCtrls[$i]) Then
			If $__aCtrls[$i].type = "box" Then
				For $box in $__aCtrls[$i].boxes
					If $box = $ctrl Then Return $__aCtrls[$i]
				Next
			Else
				If $__aCtrls[$i].ctrl = $ctrl Then Return $__aCtrls[$i]
			EndIf
		EndIf
	Next
	Return False
EndFunc

Func __colorgetdim($color, $dim)
	Local $rgb = _ColorGetRGB($color)
	If IsArray($rgb) = False Then Return $color
	$rgb[0] += $rgb[0] / 100 * $dim
	$rgb[1] += $rgb[1] / 100 * $dim
	$rgb[2] += $rgb[2] / 100 * $dim
	$rgb[0] = $rgb[0] > 255 ? 255 : $rgb[0]
	$rgb[1] = $rgb[1] > 255 ? 255 : $rgb[1]
	$rgb[2] = $rgb[2] > 255 ? 255 : $rgb[2]
	Return _ColorSetRGB($rgb)
EndFunc

Func _GUIGetLastCtrlID()
    Local $aRet = DllCall("user32.dll", "int", "GetDlgCtrlID", "hwnd", GUICtrlGetHandle(-1))
    Return IsArray($aRet) ? $aRet[0] : False
EndFunc

Func __HGUI_TABINPUT($hwnd, $msg, $wparam, $lparam)
	Local $ctrl = Number("0x" & Hex($wparam, 6))
	If $__currentInputFocus <> $ctrl Or StringLen(GUICtrlRead($ctrl)) = 1 Then
		Local $oCtrl = __CtrlGetObject($ctrl)
		If IsObj($oCtrl) And $oCtrl.type = "input" Then _HGUI_CtrlClickDown($ctrl)
	EndIf
EndFunc

Func __HGUI_LOADINGPIC($hwnd, $msg, $wparam, $lparam)

	Local $bitmap
	$__iPerLoading = $__iPerLoading >= 100 ? 0 : $__iPerLoading + 0.5

	For $i = 0 To UBound($__loadingPic) - 1

		If IsObj($__loadingPic[$i]) Then
			$bitmap = _GDIPlus_MultiColorLoader($__iPerLoading, $__loadingPic[$i].w, $__loadingPic[$i].h)
			__GUICtrlPic_SetImage($__loadingPic[$i].ctrl, $bitmap)
			_GDIPlus_BitmapDispose($bitmap)
		EndIf
	Next
EndFunc

Func __HGUI_RESTORE($hwnd, $msg, $wparam, $lparam)
	Local $SC_RESTORE = 0xF120, $SC_MINIMIZE = 0xF020

	Switch $wparam
		Case $SC_RESTORE
			AdlibRegister("__HGUI_RESTORE2",1)
	EndSwitch
EndFunc

Func __HGUI_RESTORE2()
	AdlibUnRegister("__HGUI_RESTORE2")
	__GUICtrlPicReset()
EndFunc

Func __LOADINGDELTE($o)
	For $i = 0 To UBound($__loadingPic) - 1
		If $__loadingPic[$i] = $o Then Return _ArrayDelete($__loadingPic, $i)
	Next
EndFunc

Func __GUICtrlPicReset()

	For $pic In $__aCtrls
		If $pic.type = "pic" Then _HGUI_CtrlLeave($pic.ctrl)
	Next
EndFunc

Func __ImageResizeScale(ByRef $bitmap, $w = -1, $h = -1, $scale = -1)

	Local $size = _GDIPlus_ImageGetDimension($bitmap)
	If IsArray($size) = False Then Return False
	If $scale > 0 Then
		Local $tmp = _GDIPlus_ImageResize($bitmap, $size[0] * $scale, $size[1] * $scale)
	Else
		If $w = -1 Then $w = $size[0]
		If $h = -1 Then $h = $size[1]
		Local $tmp = _GDIPlus_ImageResize($bitmap, $w, $h)
	EndIf
	_GDIPlus_BitmapDispose($bitmap)
	$bitmap = $tmp
	Return _GDIPlus_ImageGetDimension($bitmap)
EndFunc

Func _StringInPixels($hGUI, $sString, $sFontFamily, $fSize, $iStyle, $iColWidth = 0)
    Local $hGraphic = _GDIPlus_GraphicsCreateFromHWND($hGUI) ;Create a graphics object from a window handle

    Local $aRanges[2][2] = [[1]]
    $aRanges[1][0] = 0 ;Measure first char (0-based)
    $aRanges[1][1] = StringLen($sString) ;Region = String length

    Local $hFormat = _GDIPlus_StringFormatCreate()
    Local $hFamily = _GDIPlus_FontFamilyCreate($sFontFamily)
    Local $hFont = _GDIPlus_FontCreate($hFamily, $fSize, $iStyle)

    _GDIPlus_GraphicsSetTextRenderingHint($hGraphic, $GDIP_TEXTRENDERINGHINT_ANTIALIASGRIDFIT)
    _GDIPlus_StringFormatSetMeasurableCharacterRanges($hFormat, $aRanges) ;Set ranges

    Local $aWinClient = WinGetClientSize($hGUI)
    If $iColWidth = 0 Then $iColWidth = $aWinClient[0]
    Local $tLayout = _GDIPlus_RectFCreate(10, 10, $iColWidth, $aWinClient[1])
    Local $aRegions = _GDIPlus_GraphicsMeasureCharacterRanges($hGraphic, $sString, $hFont, $tLayout, $hFormat) ;get array of regions
	If IsArray($aRegions) = False Then Return False
    Local $aBounds = _GDIPlus_RegionGetBounds($aRegions[1], $hGraphic)
    Local $aWidthHeight[2] = [$aBounds[2], $aBounds[3]]

    ; Clean up resources
    _GDIPlus_FontDispose($hFont)
    _GDIPlus_RegionDispose($aRegions[1])
    _GDIPlus_FontFamilyDispose($hFamily)
    _GDIPlus_StringFormatDispose($hFormat)
    _GDIPlus_GraphicsDispose($hGraphic)

    Return $aWidthHeight
EndFunc   ;==>_StringInPixels

Func __CallBackThread($hwnd, $msg, $wparam, $lparam)

	$COPYDATA = DllStructCreate("ptr;dword;ptr", $LParam)
	$MyData = DllStructCreate("char[" & DllStructGetData($COPYDATA, 2) & "]", DllStructGetData($COPYDATA, 3))
	$fImg = DllStructGetData($MyData, 1)
	ConsoleWrite($wparam & " | " &$fImg & @CRLF)
	_GUICtrlSetImage($wparam, $fImg, -100, -100)
	FileDelete($fImg)
EndFunc

Func __StreamImageURL($msg)
	$msg = _DataDecode($msg)
	If UBound($msg) < 2 Then Return
	Local $data = @TempDir & "\" & __randomstr(100) & $msg[0]
	InetGet($msg[1], $data, 0)

	$MyData = DllStructCreate("char[" & StringLen($data) + 1 & "]")
	$COPYDATA = DllStructCreate("ptr;dword;ptr")
	DllStructSetData($MyData, 1, $data)
	DllStructSetData($COPYDATA, 1, 1)
	DllStructSetData($COPYDATA, 2, DllStructGetSize($MyData))
	DllStructSetData($COPYDATA, 3, DllStructGetPtr($MyData))
	_SendMessage(WinGetHandle("c1783f3ad0e73a0accdeacac4158a6d5"), $WM_COPYDATA, $msg[0], DllStructGetPtr($COPYDATA))
EndFunc

Func _DataEncode($data)
	If IsArray($data) = False Then Return StringToBinary($data, 4)

	Local $ret
	For $d In $data
		$ret &= StringToBinary($d, 4) & ";"
	Next
	Return StringTrimRight($ret, 1)
EndFunc

Func _DataDecode($data)
	If StringInStr($data, ";") = False Then Return BinaryToString($data, 4)
	Local $split = StringSplit($data, ";", 1), $ret[$split[0]]
	For $i = 1 To $split[0]
		$ret[$i - 1] = BinaryToString($split[$i], 4)
	Next
	Return $ret
EndFunc

Func _GDIPlus_MultiColorLoader($iPerc, $bitmapW, $bitmapH)
	Local $iW = 150, $iH = 130, $offsetX = $bitmapW / 2 - 75, $offsetY = $bitmapH / 2 - 75
	Local $hBitmap = _GDIPlus_BitmapCreateFromScan0($bitmapW, $bitmapH)
	Local Const $hGfx = _GDIPlus_ImageGetGraphicsContext($hBitmap)
	_GDIPlus_GraphicsSetSmoothingMode($hGfx, 4 + (@OSBuild > 5999))
	_GDIPlus_GraphicsSetTextRenderingHint($hGfx, 3)
	_GDIPlus_GraphicsSetPixelOffsetMode($hGfx, $GDIP_PIXELOFFSETMODE_HIGHQUALITY)

	Local Const $iColors = 7
	Local Const $aColors[$iColors] = [0xFF2ECC71, 0xFF3498DB, 0xFF9B59B6, 0xFFE67E22, 0xFFC0392B, 0xFFE74C3C, 0xFFE74C8C]
	Local Const $hBrush = _GDIPlus_BrushCreateSolid()
	Local Const $iWidth = 10, $iSpace = 4, $iX = ($iW - $iColors * ($iWidth + $iSpace)) / 2, $iHeight = $iH / 5
	Local $i, $fDH
	For $i = 0 to UBound($aColors) - 1
		_GDIPlus_BrushSetSolidColor($hBrush, $aColors[$i])
		$fDH = Sin($iPerc + Cos($i)) * $iHeight * 0.66666
		_GDIPlus_GraphicsFillRect($hGfx, $offsetX + $iX + $i * ($iWidth + $iSpace), $offsetY + (-$iHeight + $iH - $fDH) / 2, $iWidth, $iHeight + $fDH, $hBrush)
		$iPerc += 0.05
	Next
	_GDIPlus_BrushDispose($hBrush)
	_GDIPlus_GraphicsDispose($hGfx)
	Return $hBitmap
EndFunc

Func __randomstr($num = Random(15, 30, 1))
	Local $ret = ""
	If $num < 1 Then $num = 1
	For $i = 1 To $num
		$ret &= Random(0, 1, 1) = 1 ? Chr(Random(65,90,1)) : Chr(Random(97,122,1))
	Next
	Return $ret
EndFunc
