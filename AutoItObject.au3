; #INDEX# =======================================================================================================================
; Title .........: AutoItObject v1.2.8.2
; AutoIt Version : 3.3
; Language ......: English (language independent)
; Description ...: Brings Objects to AutoIt.
; Author(s) .....: monoceres, trancexx, Kip, Prog@ndy
; Copyright .....: Copyright (C) The AutoItObject-Team. All rights reserved.
; License .......: Artistic License 2.0, see Artistic.txt
;
; This file is part of AutoItObject.
;
; AutoItObject is free software; you can redistribute it and/or modify
; it under the terms of the Artistic License as published by Larry Wall,
; either version 2.0, or (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
; See the Artistic License for more details.
;
; You should have received a copy of the Artistic License with this Kit,
; in the file named "Artistic.txt".  If not, you can get a copy from
; <http://www.perlfoundation.org/artistic_license_2_0> OR
; <http://www.opensource.org/licenses/artistic-license-2.0.php>
;
; ------------------------ AutoItObject CREDITS: ------------------------
; Copyright (C) by:
; The AutoItObject-Team:
; 	Andreas Karlsson (monoceres)
; 	Dragana R. (trancexx)
; 	Dave Bakker (Kip)
; 	Andreas Bosch (progandy, Prog@ndy)
;
; ===============================================================================================================================
#include-once
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#include <WinAPI.au3>
#include <Memory.au3>


; #CURRENT# =====================================================================================================================
;_AutoItObject_AddDestructor
;_AutoItObject_AddEnum
;_AutoItObject_AddMethod
;_AutoItObject_AddProperty
;_AutoItObject_Class
;_AutoItObject_CLSIDFromString
;_AutoItObject_CoCreateInstance
;_AutoItObject_Create
;_AutoItObject_DllOpen
;_AutoItObject_DllStructCreate
;_AutoItObject_IDispatchToPtr
;_AutoItObject_IUnknownAddRef
;_AutoItObject_IUnknownRelease
;_AutoItObject_ObjCreate
;_AutoItObject_ObjCreateEx
;_AutoItObject_ObjectFromDtag
;_AutoItObject_PtrToIDispatch
;_AutoItObject_RegisterObject
;_AutoItObject_RemoveMember
;_AutoItObject_Shutdown
;_AutoItObject_Startup
;_AutoItObject_UnregisterObject
;_AutoItObject_VariantClear
;_AutoItObject_VariantCopy
;_AutoItObject_VariantFree
;_AutoItObject_VariantInit
;_AutoItObject_VariantRead
;_AutoItObject_VariantSet
;_AutoItObject_WrapperAddMethod
;_AutoItObject_WrapperCreate
; ===============================================================================================================================

; #INTERNAL_NO_DOC# =============================================================================================================
;__Au3Obj_OleUninitialize
;__Au3Obj_IUnknown_AddRef
;__Au3Obj_IUnknown_Release
;__Au3Obj_GetMethods
;__Au3Obj_SafeArrayCreate
;__Au3Obj_SafeArrayDestroy
;__Au3Obj_SafeArrayAccessData
;__Au3Obj_SafeArrayUnaccessData
;__Au3Obj_SafeArrayGetUBound
;__Au3Obj_SafeArrayGetLBound
;__Au3Obj_SafeArrayGetDim
;__Au3Obj_CreateSafeArrayVariant
;__Au3Obj_ReadSafeArrayVariant
;__Au3Obj_CoTaskMemAlloc
;__Au3Obj_CoTaskMemFree
;__Au3Obj_CoTaskMemRealloc
;__Au3Obj_GlobalAlloc
;__Au3Obj_GlobalFree
;__Au3Obj_SysAllocString
;__Au3Obj_SysCopyString
;__Au3Obj_SysReAllocString
;__Au3Obj_SysFreeString
;__Au3Obj_SysStringLen
;__Au3Obj_SysReadString
;__Au3Obj_PtrStringLen
;__Au3Obj_PtrStringRead
;__Au3Obj_FunctionProxy
;__Au3Obj_EnumFunctionProxy
;__Au3Obj_ObjStructGetElements
;__Au3Obj_ObjStructMethod
;__Au3Obj_ObjStructDestructor
;__Au3Obj_ObjStructPointer
;__Au3Obj_PointerCall
;__Au3Obj_Mem_DllOpen
;__Au3Obj_Mem_FixReloc
;__Au3Obj_Mem_FixImports
;__Au3Obj_Mem_LoadLibraryEx
;__Au3Obj_Mem_FreeLibrary
;__Au3Obj_Mem_GetAddress
;__Au3Obj_Mem_VirtualProtect
;__Au3Obj_Mem_Base64Decode
;__Au3Obj_Mem_BinDll
;__Au3Obj_Mem_BinDll_X64
; ===============================================================================================================================

; #DATATYPES# =====================================================================================================================
; none - no value (only valid for return type, equivalent to void in C)
; byte - an unsigned 8 bit integer
; boolean - an unsigned 8 bit integer
; short - a 16 bit integer
; word, ushort - an unsigned 16 bit integer
; int, long - a 32 bit integer
; bool - a 32 bit integer
; dword, ulong, uint - an unsigned 32 bit integer
; hresult - an unsigned 32 bit integer
; int64 - a 64 bit integer
; uint64 - an unsigned 64 bit integer
; ptr - a general pointer (void *)
; hwnd - a window handle (pointer wide)
; handle - an handle (pointer wide)
; float - a single precision floating point number
; double - a double precision floating point number
; int_ptr, long_ptr, lresult, lparam - an integer big enough to hold a pointer when running on x86 or x64 versions of AutoIt
; uint_ptr, ulong_ptr, dword_ptr, wparam - an unsigned integer big enough to hold a pointer when running on x86 or x64 versions of AutoIt
; str - an ANSI string (a minimum of 65536 chars is allocated)
; wstr - a UNICODE wide character string (a minimum of 65536 chars is allocated)
; bstr - a composite data type that consists of a length prefix, a data string and a terminator
; variant - a tagged union that can be used to represent any other data type
; idispatch, object - a composite data type that represents object with IDispatch interface
; ===============================================================================================================================

;--------------------------------------------------------------------------------------------------------------------------------------
#Region Variable definitions

	Global Const $gh_AU3Obj_kernel32dll = DllOpen("kernel32.dll")
	Global Const $gh_AU3Obj_oleautdll = DllOpen("oleaut32.dll")
	Global Const $gh_AU3Obj_ole32dll = DllOpen("ole32.dll")

	Global Const $__Au3Obj_X64 = @AutoItX64

	Global Const $__Au3Obj_VT_EMPTY = 0
	Global Const $__Au3Obj_VT_NULL = 1
	Global Const $__Au3Obj_VT_I2 = 2
	Global Const $__Au3Obj_VT_I4 = 3
	Global Const $__Au3Obj_VT_R4 = 4
	Global Const $__Au3Obj_VT_R8 = 5
	Global Const $__Au3Obj_VT_CY = 6
	Global Const $__Au3Obj_VT_DATE = 7
	Global Const $__Au3Obj_VT_BSTR = 8
	Global Const $__Au3Obj_VT_DISPATCH = 9
	Global Const $__Au3Obj_VT_ERROR = 10
	Global Const $__Au3Obj_VT_BOOL = 11
	Global Const $__Au3Obj_VT_VARIANT = 12
	Global Const $__Au3Obj_VT_UNKNOWN = 13
	Global Const $__Au3Obj_VT_DECIMAL = 14
	Global Const $__Au3Obj_VT_I1 = 16
	Global Const $__Au3Obj_VT_UI1 = 17
	Global Const $__Au3Obj_VT_UI2 = 18
	Global Const $__Au3Obj_VT_UI4 = 19
	Global Const $__Au3Obj_VT_I8 = 20
	Global Const $__Au3Obj_VT_UI8 = 21
	Global Const $__Au3Obj_VT_INT = 22
	Global Const $__Au3Obj_VT_UINT = 23
	Global Const $__Au3Obj_VT_VOID = 24
	Global Const $__Au3Obj_VT_HRESULT = 25
	Global Const $__Au3Obj_VT_PTR = 26
	Global Const $__Au3Obj_VT_SAFEARRAY = 27
	Global Const $__Au3Obj_VT_CARRAY = 28
	Global Const $__Au3Obj_VT_USERDEFINED = 29
	Global Const $__Au3Obj_VT_LPSTR = 30
	Global Const $__Au3Obj_VT_LPWSTR = 31
	Global Const $__Au3Obj_VT_RECORD = 36
	Global Const $__Au3Obj_VT_INT_PTR = 37
	Global Const $__Au3Obj_VT_UINT_PTR = 38
	Global Const $__Au3Obj_VT_FILETIME = 64
	Global Const $__Au3Obj_VT_BLOB = 65
	Global Const $__Au3Obj_VT_STREAM = 66
	Global Const $__Au3Obj_VT_STORAGE = 67
	Global Const $__Au3Obj_VT_STREAMED_OBJECT = 68
	Global Const $__Au3Obj_VT_STORED_OBJECT = 69
	Global Const $__Au3Obj_VT_BLOB_OBJECT = 70
	Global Const $__Au3Obj_VT_CF = 71
	Global Const $__Au3Obj_VT_CLSID = 72
	Global Const $__Au3Obj_VT_VERSIONED_STREAM = 73
	Global Const $__Au3Obj_VT_BSTR_BLOB = 0xfff
	Global Const $__Au3Obj_VT_VECTOR = 0x1000
	Global Const $__Au3Obj_VT_ARRAY = 0x2000
	Global Const $__Au3Obj_VT_BYREF = 0x4000
	Global Const $__Au3Obj_VT_RESERVED = 0x8000
	Global Const $__Au3Obj_VT_ILLEGAL = 0xffff
	Global Const $__Au3Obj_VT_ILLEGALMASKED = 0xfff
	Global Const $__Au3Obj_VT_TYPEMASK = 0xfff

	Global Const $__Au3Obj_tagVARIANT = "word vt;word r1;word r2;word r3;ptr data; ptr"

	Global Const $__Au3Obj_VARIANT_SIZE = DllStructGetSize(DllStructCreate($__Au3Obj_tagVARIANT, 1))
	Global Const $__Au3Obj_PTR_SIZE = DllStructGetSize(DllStructCreate('ptr', 1))
	Global Const $__Au3Obj_tagSAFEARRAYBOUND = "ulong cElements; long lLbound;"

	Global $ghAutoItObjectDLL = -1, $giAutoItObjectDLLRef = 0

	;===============================================================================
	#interface "IUnknown"
	Global Const $sIID_IUnknown = "{00000000-0000-0000-C000-000000000046}"
	; Definition
	Global $dtagIUnknown = "QueryInterface hresult(ptr;ptr*);" & _
			"AddRef dword();" & _
			"Release dword();"
	; List
	Global $ltagIUnknown = "QueryInterface;" & _
			"AddRef;" & _
			"Release;"
	;===============================================================================
	;===============================================================================
	#interface "IDispatch"
	Global Const $sIID_IDispatch = "{00020400-0000-0000-C000-000000000046}"
	; Definition
	Global $dtagIDispatch = $dtagIUnknown & _
			"GetTypeInfoCount hresult(dword*);" & _
			"GetTypeInfo hresult(dword;dword;ptr*);" & _
			"GetIDsOfNames hresult(ptr;ptr;dword;dword;ptr);" & _
			"Invoke hresult(dword;ptr;dword;word;ptr;ptr;ptr;ptr);"
	; List
	Global $ltagIDispatch = $ltagIUnknown & _
			"GetTypeInfoCount;" & _
			"GetTypeInfo;" & _
			"GetIDsOfNames;" & _
			"Invoke;"
	;===============================================================================

#EndRegion
;--------------------------------------------------------------------------------------------------------------------------------------


;--------------------------------------------------------------------------------------------------------------------------------------
#Region Misc

	DllCall($gh_AU3Obj_ole32dll, 'long', 'OleInitialize', 'ptr', 0)
	OnAutoItExitRegister("__Au3Obj_OleUninitialize")
	Func __Au3Obj_OleUninitialize()
		; Author: Prog@ndy
		DllCall($gh_AU3Obj_ole32dll, 'long', 'OleUninitialize')
		_AutoItObject_Shutdown(True)
	EndFunc

	Func __Au3Obj_IUnknown_AddRef($vObj)
		Local $sType = "ptr"
		If IsObj($vObj) Then $sType = "idispatch"
		Local $tVARIANT = DllStructCreate($__Au3Obj_tagVARIANT)
		; Actual call
		Local $aCall = DllCall($gh_AU3Obj_oleautdll, "long", "DispCallFunc", _
				$sType, $vObj, _
				"dword", $__Au3Obj_PTR_SIZE, _ ; offset (4 for x86, 8 for x64)
				"dword", 4, _ ; CC_STDCALL
				"dword", $__Au3Obj_VT_UINT, _
				"dword", 0, _ ; number of function parameters
				"ptr", 0, _ ; parameters related
				"ptr", 0, _ ; parameters related
				"ptr", DllStructGetPtr($tVARIANT))
		If @error Or $aCall[0] Then Return SetError(1, 0, 0)
		; Collect returned
		Return DllStructGetData(DllStructCreate("dword", DllStructGetPtr($tVARIANT, "data")), 1)
	EndFunc

	Func __Au3Obj_IUnknown_Release($vObj)
		Local $sType = "ptr"
		If IsObj($vObj) Then $sType = "idispatch"
		Local $tVARIANT = DllStructCreate($__Au3Obj_tagVARIANT)
		; Actual call
		Local $aCall = DllCall($gh_AU3Obj_oleautdll, "long", "DispCallFunc", _
				$sType, $vObj, _
				"dword", 2 * $__Au3Obj_PTR_SIZE, _ ; offset (8 for x86, 16 for x64)
				"dword", 4, _ ; CC_STDCALL
				"dword", $__Au3Obj_VT_UINT, _
				"dword", 0, _ ; number of function parameters
				"ptr", 0, _ ; parameters related
				"ptr", 0, _ ; parameters related
				"ptr", DllStructGetPtr($tVARIANT))
		If @error Or $aCall[0] Then Return SetError(1, 0, 0)
		; Collect returned
		Return DllStructGetData(DllStructCreate("dword", DllStructGetPtr($tVARIANT, "data")), 1)
	EndFunc

	Func __Au3Obj_GetMethods($tagInterface)
		Local $sMethods = StringReplace(StringRegExpReplace($tagInterface, "\h*(\w+)\h*(\w+\*?)\h*(\((.*?)\))\h*(;|;*\z)", "$1\|$2;$4" & @LF), ";" & @LF, @LF)
		If $sMethods = $tagInterface Then $sMethods = StringReplace(StringRegExpReplace($tagInterface, "\h*(\w+)\h*(;|;*\z)", "$1\|" & @LF), ";" & @LF, @LF)
		Return StringTrimRight($sMethods, 1)
	EndFunc

	Func __Au3Obj_ObjStructGetElements($sTag, ByRef $sAlign)
		Local $sAlignment = StringRegExpReplace($sTag, "\h*(align\h+\d+)\h*;.*", "$1")
		If $sAlignment <> $sTag Then
			$sAlign = $sAlignment
			$sTag = StringRegExpReplace($sTag, "\h*(align\h+\d+)\h*;", "")
		EndIf
		; Return StringRegExp($sTag, "\h*\w+\h*(\w+)\h*", 3) ; DO NOT REMOVE THIS LINE
		Return StringTrimRight(StringRegExpReplace($sTag, "\h*\w+\h*(\w+)\h*(\[\d+\])*\h*(;|;*\z)\h*", "$1;"), 1)
	EndFunc

#EndRegion
;--------------------------------------------------------------------------------------------------------------------------------------


;--------------------------------------------------------------------------------------------------------------------------------------
#Region SafeArray
	Func __Au3Obj_SafeArrayCreate($vType, $cDims, $rgsabound)
		; Author: Prog@ndy
		Local $aCall = DllCall($gh_AU3Obj_oleautdll, "ptr", "SafeArrayCreate", "dword", $vType, "uint", $cDims, 'ptr', $rgsabound)
		If @error Then Return SetError(1, 0, 0)
		Return $aCall[0]
	EndFunc

	Func __Au3Obj_SafeArrayDestroy($pSafeArray)
		; Author: Prog@ndy
		Local $aCall = DllCall($gh_AU3Obj_oleautdll, "int", "SafeArrayDestroy", "ptr", $pSafeArray)
		If @error Then Return SetError(1, 0, 1)
		Return $aCall[0]
	EndFunc

	Func __Au3Obj_SafeArrayAccessData($pSafeArray, ByRef $pArrayData)
		; Author: Prog@ndy
		Local $aCall = DllCall($gh_AU3Obj_oleautdll, "int", "SafeArrayAccessData", "ptr", $pSafeArray, 'ptr*', 0)
		If @error Then Return SetError(1, 0, 1)
		$pArrayData = $aCall[2]
		Return $aCall[0]
	EndFunc

	Func __Au3Obj_SafeArrayUnaccessData($pSafeArray)
		; Author: Prog@ndy
		Local $aCall = DllCall($gh_AU3Obj_oleautdll, "int", "SafeArrayUnaccessData", "ptr", $pSafeArray)
		If @error Then Return SetError(1, 0, 1)
		Return $aCall[0]
	EndFunc

	Func __Au3Obj_SafeArrayGetUBound($pSafeArray, $iDim, ByRef $iBound)
		; Author: Prog@ndy
		Local $aCall = DllCall($gh_AU3Obj_oleautdll, "int", "SafeArrayGetUBound", "ptr", $pSafeArray, 'uint', $iDim, 'long*', 0)
		If @error Then Return SetError(1, 0, 1)
		$iBound = $aCall[3]
		Return $aCall[0]
	EndFunc

	Func __Au3Obj_SafeArrayGetLBound($pSafeArray, $iDim, ByRef $iBound)
		; Author: Prog@ndy
		Local $aCall = DllCall($gh_AU3Obj_oleautdll, "int", "SafeArrayGetLBound", "ptr", $pSafeArray, 'uint', $iDim, 'long*', 0)
		If @error Then Return SetError(1, 0, 1)
		$iBound = $aCall[3]
		Return $aCall[0]
	EndFunc

	Func __Au3Obj_SafeArrayGetDim($pSafeArray)
		Local $aResult = DllCall($gh_AU3Obj_oleautdll, "uint", "SafeArrayGetDim", "ptr", $pSafeArray)
		If @error Then Return SetError(1, 0, 0)
		Return $aResult[0]
	EndFunc

	Func __Au3Obj_CreateSafeArrayVariant(ByRef Const $aArray)
		; Author: Prog@ndy
		Local $iDim = UBound($aArray, 0), $pData, $pSafeArray, $bound, $subBound, $tBound
		Switch $iDim
			Case 1
				$bound = UBound($aArray) - 1
				$tBound = DllStructCreate($__Au3Obj_tagSAFEARRAYBOUND)
				DllStructSetData($tBound, 1, $bound + 1)
				$pSafeArray = __Au3Obj_SafeArrayCreate($__Au3Obj_VT_VARIANT, 1, DllStructGetPtr($tBound))
				If 0 = __Au3Obj_SafeArrayAccessData($pSafeArray, $pData) Then
					For $i = 0 To $bound
						_AutoItObject_VariantInit($pData + $i * $__Au3Obj_VARIANT_SIZE)
						_AutoItObject_VariantSet($pData + $i * $__Au3Obj_VARIANT_SIZE, $aArray[$i])
					Next
					__Au3Obj_SafeArrayUnaccessData($pSafeArray)
				EndIf
				Return $pSafeArray
			Case 2
				$bound = UBound($aArray, 1) - 1
				$subBound = UBound($aArray, 2) - 1
				$tBound = DllStructCreate($__Au3Obj_tagSAFEARRAYBOUND & $__Au3Obj_tagSAFEARRAYBOUND)
				DllStructSetData($tBound, 3, $bound + 1)
				DllStructSetData($tBound, 1, $subBound + 1)
				$pSafeArray = __Au3Obj_SafeArrayCreate($__Au3Obj_VT_VARIANT, 2, DllStructGetPtr($tBound))
				If 0 = __Au3Obj_SafeArrayAccessData($pSafeArray, $pData) Then
					For $i = 0 To $bound
						For $j = 0 To $subBound
							_AutoItObject_VariantInit($pData + ($j + $i * ($subBound + 1)) * $__Au3Obj_VARIANT_SIZE)
							_AutoItObject_VariantSet($pData + ($j + $i * ($subBound + 1)) * $__Au3Obj_VARIANT_SIZE, $aArray[$i][$j])
						Next
					Next
					__Au3Obj_SafeArrayUnaccessData($pSafeArray)
				EndIf
				Return $pSafeArray
			Case Else
				Return 0
		EndSwitch
	EndFunc

	Func __Au3Obj_ReadSafeArrayVariant($pSafeArray)
		; Author: Prog@ndy
		Local $iDim = __Au3Obj_SafeArrayGetDim($pSafeArray), $pData, $lbound, $bound, $subBound
		Switch $iDim
			Case 1
				__Au3Obj_SafeArrayGetLBound($pSafeArray, 1, $lbound)
				__Au3Obj_SafeArrayGetUBound($pSafeArray, 1, $bound)
				$bound -= $lbound
				Local $array[$bound + 1]
				If 0 = __Au3Obj_SafeArrayAccessData($pSafeArray, $pData) Then
					For $i = 0 To $bound
						$array[$i] = _AutoItObject_VariantRead($pData + $i * $__Au3Obj_VARIANT_SIZE)
					Next
					__Au3Obj_SafeArrayUnaccessData($pSafeArray)
				EndIf
				Return $array
			Case 2
				__Au3Obj_SafeArrayGetLBound($pSafeArray, 2, $lbound)
				__Au3Obj_SafeArrayGetUBound($pSafeArray, 2, $bound)
				$bound -= $lbound
				__Au3Obj_SafeArrayGetLBound($pSafeArray, 1, $lbound)
				__Au3Obj_SafeArrayGetUBound($pSafeArray, 1, $subBound)
				$subBound -= $lbound
				Local $array[$bound + 1][$subBound + 1]
				If 0 = __Au3Obj_SafeArrayAccessData($pSafeArray, $pData) Then
					For $i = 0 To $bound
						For $j = 0 To $subBound
							$array[$i][$j] = _AutoItObject_VariantRead($pData + ($j + $i * ($subBound + 1)) * $__Au3Obj_VARIANT_SIZE)
						Next
					Next
					__Au3Obj_SafeArrayUnaccessData($pSafeArray)
				EndIf
				Return $array
			Case Else
				Return 0
		EndSwitch
	EndFunc

#EndRegion
;--------------------------------------------------------------------------------------------------------------------------------------


;--------------------------------------------------------------------------------------------------------------------------------------
#Region Memory

	Func __Au3Obj_CoTaskMemAlloc($iSize)
		; Author: Prog@ndy
		Local $aCall = DllCall($gh_AU3Obj_ole32dll, "ptr", "CoTaskMemAlloc", "uint_ptr", $iSize)
		If @error Then Return SetError(1, 0, 0)
		Return $aCall[0]
	EndFunc

	Func __Au3Obj_CoTaskMemFree($pCoMem)
		; Author: Prog@ndy
		DllCall($gh_AU3Obj_ole32dll, "none", "CoTaskMemFree", "ptr", $pCoMem)
		If @error Then Return SetError(1, 0, 0)
	EndFunc

	Func __Au3Obj_CoTaskMemRealloc($pCoMem, $iSize)
		; Author: Prog@ndy
		Local $aCall = DllCall($gh_AU3Obj_ole32dll, "ptr", "CoTaskMemRealloc", 'ptr', $pCoMem, "uint_ptr", $iSize)
		If @error Then Return SetError(1, 0, 0)
		Return $aCall[0]
	EndFunc

	Func __Au3Obj_GlobalAlloc($iSize, $iFlag)
		Local $aCall = DllCall($gh_AU3Obj_kernel32dll, "ptr", "GlobalAlloc", "dword", $iFlag, "dword_ptr", $iSize)
		If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
		Return $aCall[0]
	EndFunc

	Func __Au3Obj_GlobalFree($pPointer)
		Local $aCall = DllCall($gh_AU3Obj_kernel32dll, "ptr", "GlobalFree", "ptr", $pPointer)
		If @error Or $aCall[0] Then Return SetError(1, 0, 0)
		Return 1
	EndFunc

#EndRegion
;--------------------------------------------------------------------------------------------------------------------------------------


;--------------------------------------------------------------------------------------------------------------------------------------
#Region SysString

	Func __Au3Obj_SysAllocString($str)
		; Author: monoceres
		Local $aCall = DllCall($gh_AU3Obj_oleautdll, "ptr", "SysAllocString", "wstr", $str)
		If @error Then Return SetError(1, 0, 0)
		Return $aCall[0]
	EndFunc
	Func __Au3Obj_SysCopyString($pBSTR)
		; Author: Prog@ndy
		If Not $pBSTR Then Return SetError(2, 0, 0)
		Local $aCall = DllCall($gh_AU3Obj_oleautdll, "ptr", "SysAllocStringLen", "ptr", $pBSTR, "uint", __Au3Obj_SysStringLen($pBSTR))
		If @error Then Return SetError(1, 0, 0)
		Return $aCall[0]
	EndFunc

	Func __Au3Obj_SysReAllocString(ByRef $pBSTR, $str)
		; Author: Prog@ndy
		If Not $pBSTR Then Return SetError(2, 0, 0)
		Local $aCall = DllCall($gh_AU3Obj_oleautdll, "int", "SysReAllocString", 'ptr*', $pBSTR, "wstr", $str)
		If @error Then Return SetError(1, 0, 0)
		$pBSTR = $aCall[1]
		Return $aCall[0]
	EndFunc

	Func __Au3Obj_SysFreeString($pBSTR)
		; Author: Prog@ndy
		If Not $pBSTR Then Return SetError(2, 0, 0)
		DllCall($gh_AU3Obj_oleautdll, "none", "SysFreeString", "ptr", $pBSTR)
		If @error Then Return SetError(1, 0, 0)
	EndFunc

	Func __Au3Obj_SysStringLen($pBSTR)
		; Author: Prog@ndy
		If Not $pBSTR Then Return SetError(2, 0, 0)
		Local $aCall = DllCall($gh_AU3Obj_oleautdll, "uint", "SysStringLen", "ptr", $pBSTR)
		If @error Then Return SetError(1, 0, 0)
		Return $aCall[0]
	EndFunc

	Func __Au3Obj_SysReadString($pBSTR, $iLen = -1)
		; Author: Prog@ndy
		If Not $pBSTR Then Return SetError(2, 0, '')
		If $iLen < 1 Then $iLen = __Au3Obj_SysStringLen($pBSTR)
		If $iLen < 1 Then Return SetError(1, 0, '')
		Return DllStructGetData(DllStructCreate("wchar[" & $iLen & "]", $pBSTR), 1)
	EndFunc

	Func __Au3Obj_PtrStringLen($pStr)
		; Author: Prog@ndy
		Local $aResult = DllCall($gh_AU3Obj_kernel32dll, 'int', 'lstrlenW', 'ptr', $pStr)
		If @error Then Return SetError(1, 0, 0)
		Return $aResult[0]
	EndFunc

	Func __Au3Obj_PtrStringRead($pStr, $iLen = -1)
		; Author: Prog@ndy
		If $iLen < 1 Then $iLen = __Au3Obj_PtrStringLen($pStr)
		If $iLen < 1 Then Return SetError(1, 0, '')
		Return DllStructGetData(DllStructCreate("wchar[" & $iLen & "]", $pStr), 1)
	EndFunc

#EndRegion
;--------------------------------------------------------------------------------------------------------------------------------------


;--------------------------------------------------------------------------------------------------------------------------------------
#Region Proxy Functions

	Func __Au3Obj_FunctionProxy($FuncName, $oSelf) ; allows binary code to call autoit functions
		Local $arg = $oSelf.__params__ ; fetch params
		If IsArray($arg) Then
			Local $ret = Call($FuncName, $arg) ; Call
			If @error = 0xDEAD And @extended = 0xBEEF Then Return 0
			$oSelf.__error__ = @error ; set error
			$oSelf.__result__ = $ret ; set result
			Return 1
		EndIf
		; return error when params-array could not be created
	EndFunc

	Func __Au3Obj_EnumFunctionProxy($iAction, $FuncName, $oSelf, $pVarCurrent, $pVarResult)
		Local $Current, $ret
		Switch $iAction
			Case 0 ; Next
				$Current = $oSelf.__bridge__(Number($pVarCurrent))
				$ret = Execute($FuncName & "($oSelf, $Current)")
				If @error Then Return False
				$oSelf.__bridge__(Number($pVarCurrent)) = $Current
				$oSelf.__bridge__(Number($pVarResult)) = $ret
				Return 1
			Case 1 ;Skip
				Return False
			Case 2 ; Reset
				$Current = $oSelf.__bridge__(Number($pVarCurrent))
				$ret = Execute($FuncName & "($oSelf, $Current)")
				If @error Or Not $ret Then Return False
				$oSelf.__bridge__(Number($pVarCurrent)) = $Current
				Return True
		EndSwitch
	EndFunc

#EndRegion
;--------------------------------------------------------------------------------------------------------------------------------------


;--------------------------------------------------------------------------------------------------------------------------------------
#Region Call Pointer

	Func __Au3Obj_PointerCall($sRetType, $pAddress, $sType1 = "", $vParam1 = 0, $sType2 = "", $vParam2 = 0, $sType3 = "", $vParam3 = 0, $sType4 = "", $vParam4 = 0, $sType5 = "", $vParam5 = 0, $sType6 = "", $vParam6 = 0, $sType7 = "", $vParam7 = 0, $sType8 = "", $vParam8 = 0, $sType9 = "", $vParam9 = 0, $sType10 = "", $vParam10 = 0, $sType11 = "", $vParam11 = 0, $sType12 = "", $vParam12 = 0, $sType13 = "", $vParam13 = 0, $sType14 = "", $vParam14 = 0, $sType15 = "", $vParam15 = 0, $sType16 = "", $vParam16 = 0, $sType17 = "", $vParam17 = 0, $sType18 = "", $vParam18 = 0, $sType19 = "", $vParam19 = 0, $sType20 = "", $vParam20 = 0)
		; Author: Ward, Prog@ndy, trancexx
		Local Static $pHook, $hPseudo, $tPtr, $sFuncName = "MemoryCallEntry"
		If $pAddress Then
			If Not $pHook Then
				Local $sDll = "AutoItObject.dll"
				If $__Au3Obj_X64 Then $sDll = "AutoItObject_X64.dll"
				$hPseudo = DllOpen($sDll)
				If $hPseudo = -1 Then
					$sDll = "kernel32.dll"
					$sFuncName = "GlobalFix"
					$hPseudo = DllOpen($sDll)
				EndIf
				Local $aCall = DllCall($gh_AU3Obj_kernel32dll, "ptr", "GetModuleHandleW", "wstr", $sDll)
				If @error Or Not $aCall[0] Then Return SetError(7, @error, 0) ; Couldn't get dll handle
				Local $hModuleHandle = $aCall[0]
				$aCall = DllCall($gh_AU3Obj_kernel32dll, "ptr", "GetProcAddress", "ptr", $hModuleHandle, "str", $sFuncName)
				If @error Then Return SetError(8, @error, 0) ; Wanted function not found
				$pHook = $aCall[0]
				$aCall = DllCall($gh_AU3Obj_kernel32dll, "bool", "VirtualProtect", "ptr", $pHook, "dword", 7 + 5 * $__Au3Obj_X64, "dword", 64, "dword*", 0)
				If @error Or Not $aCall[0] Then Return SetError(9, @error, 0) ; Unable to set MEM_EXECUTE_READWRITE
				If $__Au3Obj_X64 Then
					DllStructSetData(DllStructCreate("word", $pHook), 1, 0xB848)
					DllStructSetData(DllStructCreate("word", $pHook + 10), 1, 0xE0FF)
				Else
					DllStructSetData(DllStructCreate("byte", $pHook), 1, 0xB8)
					DllStructSetData(DllStructCreate("word", $pHook + 5), 1, 0xE0FF)
				EndIf
				$tPtr = DllStructCreate("ptr", $pHook + 1 + $__Au3Obj_X64)
			EndIf
			DllStructSetData($tPtr, 1, $pAddress)
			Local $aRet
			Switch @NumParams
				Case 2
					$aRet = DllCall($hPseudo, $sRetType, $sFuncName)
				Case 4
					$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1)
				Case 6
					$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2)
				Case 8
					$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3)
				Case 10
					$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4)
				Case 12
					$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5)
				Case 14
					$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6)
				Case 16
					$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7)
				Case 18
					$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8)
				Case 20
					$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9)
				Case 22
					$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10)
				Case 24
					$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10, $sType11, $vParam11)
				Case 26
					$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10, $sType11, $vParam11, $sType12, $vParam12)
				Case 28
					$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10, $sType11, $vParam11, $sType12, $vParam12, $sType13, $vParam13)
				Case 30
					$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10, $sType11, $vParam11, $sType12, $vParam12, $sType13, $vParam13, $sType14, $vParam14)
				Case 32
					$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10, $sType11, $vParam11, $sType12, $vParam12, $sType13, $vParam13, $sType14, $vParam14, $sType15, $vParam15)
				Case 34
					$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10, $sType11, $vParam11, $sType12, $vParam12, $sType13, $vParam13, $sType14, $vParam14, $sType15, $vParam15, $sType16, $vParam16)
				Case 36
					$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10, $sType11, $vParam11, $sType12, $vParam12, $sType13, $vParam13, $sType14, $vParam14, $sType15, $vParam15, $sType16, $vParam16, $sType17, $vParam17)
				Case 38
					$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10, $sType11, $vParam11, $sType12, $vParam12, $sType13, $vParam13, $sType14, $vParam14, $sType15, $vParam15, $sType16, $vParam16, $sType17, $vParam17, $sType18, $vParam18)
				Case 40
					$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10, $sType11, $vParam11, $sType12, $vParam12, $sType13, $vParam13, $sType14, $vParam14, $sType15, $vParam15, $sType16, $vParam16, $sType17, $vParam17, $sType18, $vParam18, $sType19, $vParam19)
				Case 42
					$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10, $sType11, $vParam11, $sType12, $vParam12, $sType13, $vParam13, $sType14, $vParam14, $sType15, $vParam15, $sType16, $vParam16, $sType17, $vParam17, $sType18, $vParam18, $sType19, $vParam19, $sType20, $vParam20)
				Case Else
					If Mod(@NumParams, 2) Then Return SetError(4, 0, 0) ; Bad number of parameters
					Return SetError(5, 0, 0) ; Max number of parameters exceeded
			EndSwitch
			Return SetError(@error, @extended, $aRet) ; All went well. Error description and return values like with DllCall()
		EndIf
		Return SetError(6, 0, 0) ; Null address specified
	EndFunc

#EndRegion
;--------------------------------------------------------------------------------------------------------------------------------------

;--------------------------------------------------------------------------------------------------------------------------------------
#Region DllStructCreate Wrapper

	Func __Au3Obj_ObjStructMethod(ByRef $oSelf, $vParam1 = 0, $vParam2 = 0)
		Local $sMethod = $oSelf.__name__
		Local $tStructure = DllStructCreate($oSelf.__tag__, $oSelf.__pointer__)
		Local $vOut
		Switch @NumParams
			Case 1
				$vOut = DllStructGetData($tStructure, $sMethod)
			Case 2
				If $oSelf.__propcall__ Then
					$vOut = DllStructSetData($tStructure, $sMethod, $vParam1)
				Else
					$vOut = DllStructGetData($tStructure, $sMethod, $vParam1)
				EndIf
			Case 3
				$vOut = DllStructSetData($tStructure, $sMethod, $vParam2, $vParam1)
		EndSwitch
		If IsPtr($vOut) Then Return Number($vOut)
		Return $vOut
	EndFunc

	Func __Au3Obj_ObjStructDestructor(ByRef $oSelf)
		If $oSelf.__new__ Then __Au3Obj_GlobalFree($oSelf.__pointer__)
	EndFunc

	Func __Au3Obj_ObjStructPointer(ByRef $oSelf, $vParam = Default)
		If $oSelf.__propcall__ Then Return SetError(1, 0, 0)
		If @NumParams = 1 Or IsKeyword($vParam) Then Return $oSelf.__pointer__
		Return Number(DllStructGetPtr(DllStructCreate($oSelf.__tag__, $oSelf.__pointer__), $vParam))
	EndFunc

#EndRegion
;--------------------------------------------------------------------------------------------------------------------------------------


;--------------------------------------------------------------------------------------------------------------------------------------
#Region Public UDFs

	Global Enum $ELTYPE_NOTHING, $ELTYPE_METHOD, $ELTYPE_PROPERTY
	Global Enum $ELSCOPE_PUBLIC, $ELSCOPE_READONLY, $ELSCOPE_PRIVATE

	; #FUNCTION# ====================================================================================================================
	; Name...........: _AutoItObject_AddDestructor
	; Description ...: Adds a destructor to an AutoIt-object
	; Syntax.........: _AutoItObject_AddDestructor(ByRef $oObject, $sAutoItFunc)
	; Parameters ....: $oObject     - the object to modify
	;                  $sAutoItFunc - the AutoIt-function wich represents this destructor.
	; Return values .: Success      - True
	;                  Failure      - 0
	; Author ........: monoceres (Andreas Karlsson)
	; Modified.......:
	; Remarks .......: Adding a method that will be called on object destruction. Can be called multiple times.
	; Related .......: _AutoItObject_AddProperty, _AutoItObject_AddEnum, _AutoItObject_RemoveMember, _AutoItObject_AddMethod
	; Link ..........:
	; Example .......:
	; ===============================================================================================================================
	Func _AutoItObject_AddDestructor(ByRef $oObject, $sAutoItFunc)
		Return _AutoItObject_AddMethod($oObject, "~", $sAutoItFunc, True)
	EndFunc

	; #FUNCTION# ====================================================================================================================
	; Name...........: _AutoItObject_AddEnum
	; Description ...: Adds an Enum to an AutoIt-object
	; Syntax.........: _AutoItObject_AddEnum(ByRef $oObject, $sNextFunc, $sResetFunc [, $sSkipFunc = ''])
	; Parameters ....: $oObject     - the object to modify
	;                  $sNextFunc   - The function to be called to get the next entry
	;                  $sResetFunc  - The function to be called to reset the enum
	;                  $sSkipFunc   - [optional] The function to be called to skip elements (not supported by AutoIt)
	; Return values .: Success      - True
	;                  Failure      - 0
	; Author ........: Prog@ndy
	; Modified.......:
	; Remarks .......:
	; Related .......: _AutoItObject_AddMethod, _AutoItObject_AddProperty, _AutoItObject_RemoveMember
	; Link ..........:
	; Example .......:
	; ===============================================================================================================================
	Func _AutoItObject_AddEnum(ByRef $oObject, $sNextFunc, $sResetFunc, $sSkipFunc = '')
		; Author: Prog@ndy
		If Not IsObj($oObject) Then Return SetError(2, 0, 0)
		DllCall($ghAutoItObjectDLL, "none", "AddEnum", "idispatch", $oObject, "wstr", $sNextFunc, "wstr", $sResetFunc, "wstr", $sSkipFunc)
		If @error Then Return SetError(1, @error, 0)
		Return True
	EndFunc

	; #FUNCTION# ====================================================================================================================
	; Name...........: _AutoItObject_AddMethod
	; Description ...: Adds a method to an AutoIt-object
	; Syntax.........: _AutoItObject_AddMethod(ByRef $oObject, $sName, $sAutoItFunc [, $fPrivate = False])
	; Parameters ....: $oObject     - the object to modify
	;                  $sName       - the name of the method to add
	;                  $sAutoItFunc - the AutoIt-function wich represents this method.
	;                  $fPrivate    - [optional] Specifies whether the function can only be called from within the object. (default: False)
	; Return values .: Success      - True
	;                  Failure      - 0
	; Author ........: Prog@ndy
	; Modified.......:
	; Remarks .......: The first parameter of the AutoIt-function is always a reference to the object. ($oSelf)
	;                  This parameter will automatically be added and must not be given in the call.
	;                  The function called '__default__' is accesible without a name using brackets ($return = $oObject())
	; Related .......: _AutoItObject_AddProperty, _AutoItObject_AddEnum, _AutoItObject_RemoveMember
	; Link ..........:
	; Example .......:
	; ===============================================================================================================================
	Func _AutoItObject_AddMethod(ByRef $oObject, $sName, $sAutoItFunc, $fPrivate = False)
		; Author: Prog@ndy
		If Not IsObj($oObject) Then Return SetError(2, 0, 0)
		Local $iFlags = 0
		If $fPrivate Then $iFlags = $ELSCOPE_PRIVATE
		DllCall($ghAutoItObjectDLL, "none", "AddMethod", "idispatch", $oObject, "wstr", $sName, "wstr", $sAutoItFunc, 'dword', $iFlags)
		If @error Then Return SetError(1, @error, 0)
		Return True
	EndFunc

	; #FUNCTION# ====================================================================================================================
	; Name...........: _AutoItObject_AddProperty
	; Description ...: Adds a property to an AutoIt-object
	; Syntax.........: _AutoItObject_AddProperty(ByRef $oObject, $sName [, $iFlags = $ELSCOPE_PUBLIC [, $vData = ""]])
	; Parameters ....: $oObject     - the object to modify
	;                  $sName       - the name of the property to add
	;                  $iFlags      - [optional] Specifies the access to the property
	;                  $vData       - [optional] Initial data for the property
	; Return values .: Success      - True
	;                  Failure      - 0
	; Author ........: Prog@ndy
	; Modified.......:
	; Remarks .......: The property called '__default__' is accesible without a name using brackets ($value = $oObject())
	;                  + $iFlags can be:
	;                  |$ELSCOPE_PUBLIC   - The Property has public access.
	;                  |$ELSCOPE_READONLY - The property is read-only and can only be changed from within the object.
	;                  |$ELSCOPE_PRIVATE  - The property is private and can only be accessed from within the object.
	;                  +
	;                  + Initial default value for every new property is nothing (no value).
	; Related .......: _AutoItObject_AddMethod, _AutoItObject_AddEnum, _AutoItObject_RemoveMember
	; Link ..........:
	; Example .......:
	; ===============================================================================================================================
	Func _AutoItObject_AddProperty(ByRef $oObject, $sName, $iFlags = $ELSCOPE_PUBLIC, $vData = "")
		; Author: Prog@ndy
		Local Static $tStruct = DllStructCreate($__Au3Obj_tagVARIANT)
		If Not IsObj($oObject) Then Return SetError(2, 0, 0)
		Local $pData = 0
		If @NumParams = 4 Then
			$pData = DllStructGetPtr($tStruct)
			_AutoItObject_VariantInit($pData)
			$oObject.__bridge__(Number($pData)) = $vData
		EndIf
		DllCall($ghAutoItObjectDLL, "none", "AddProperty", "idispatch", $oObject, "wstr", $sName, 'dword', $iFlags, 'ptr', $pData)
		Local $error = @error
		If $pData Then _AutoItObject_VariantClear($pData)
		If $error Then Return SetError(1, $error, 0)
		Return True
	EndFunc

	; #FUNCTION# ====================================================================================================================
	; Name...........: _AutoItObject_Class
	; Description ...: AutoItObject COM wrapper function
	; Syntax.........: _AutoItObject_Class()
	; Parameters ....:
	; Return values .: Success      - object with defined:
	;                   -methods:
	;                  |	Create([$oParent = 0]) - creates AutoItObject object
	;                  |	AddMethod($sName, $sAutoItFunc [, $fPrivate = False]) - adds new method
	;                  |	AddProperty($sName, $iFlags = $ELSCOPE_PUBLIC, $vData = 0) - adds new property
	;                  |	AddDestructor($sAutoItFunc) - adds destructor
	;                  |	AddEnum($sNextFunc, $sResetFunc [, $sSkipFunc = '']) - adds enum
	;                  |	RemoveMember($sMember) - removes member
	;                   -properties:
	;                  |	Object - readonly property representing the last created AutoItObject object
	; Author ........: trancexx
	; Modified.......:
	; Remarks .......: "Object" propery can be accessed only once for one object. After that new AutoItObject object is created.
	;                  +Method "Create" will discharge previous AutoItObject object and create a new one.
	; Related .......: _AutoItObject_Create
	; Link ..........:
	; Example .......:
	; ===============================================================================================================================
	Func _AutoItObject_Class()
		Local $aCall = DllCall($ghAutoItObjectDLL, "idispatch", "CreateAutoItObjectClass")
		If @error Then Return SetError(1, @error, 0)
		Return $aCall[0]
	EndFunc

	; #FUNCTION# ====================================================================================================================
	; Name...........: _AutoItObject_CLSIDFromString
	; Description ...: Converts a string to a CLSID-Struct (GUID-Struct)
	; Syntax.........: _AutoItObject_CLSIDFromString($sString)
	; Parameters ....: $sString     - The string to convert
	; Return values .: Success      - DLLStruct in format $tagGUID
	;                  Failure      - 0
	; Author ........: Prog@ndy
	; Modified.......:
	; Remarks .......:
	; Related .......: _AutoItObject_CoCreateInstance
	; Link ..........: http://msdn.microsoft.com/en-us/library/ms680589(VS.85).aspx
	; Example .......:
	; ===============================================================================================================================
	Func _AutoItObject_CLSIDFromString($sString)
		Local $tCLSID = DllStructCreate("dword;word;word;byte[8]")
		Local $aResult = DllCall($gh_AU3Obj_ole32dll, 'long', 'CLSIDFromString', 'wstr', $sString, 'ptr', DllStructGetPtr($tCLSID))
		If @error Then Return SetError(1, @error, 0)
		If $aResult[0] <> 0 Then Return SetError(2, $aResult[0], 0)
		Return $tCLSID
	EndFunc

	; #FUNCTION# ====================================================================================================================
	; Name...........: _AutoItObject_CoCreateInstance
	; Description ...: Creates a single uninitialized object of the class associated with a specified CLSID.
	; Syntax.........: _AutoItObject_CoCreateInstance($rclsid, $pUnkOuter, $dwClsContext, $riid, ByRef $ppv)
	; Parameters ....: $rclsid       - The CLSID associated with the data and code that will be used to create the object.
	;                  $pUnkOuter    - If NULL, indicates that the object is not being created as part of an aggregate.
	;                  +If non-NULL, pointer to the aggregate object's IUnknown interface (the controlling IUnknown).
	;                  $dwClsContext - Context in which the code that manages the newly created object will run.
	;                  +The values are taken from the enumeration CLSCTX.
	;                  $riid         - A reference to the identifier of the interface to be used to communicate with the object.
	;                  $ppv          - [out byref] Variable that receives the interface pointer requested in riid.
	;                  +Upon successful return, *ppv contains the requested interface pointer. Upon failure, *ppv contains NULL.
	; Return values .: Success      - True
	;                  Failure      - 0
	; Author ........: Prog@ndy
	; Modified.......:
	; Remarks .......:
	; Related .......: _AutoItObject_ObjCreate, _AutoItObject_CLSIDFromString
	; Link ..........: http://msdn.microsoft.com/en-us/library/ms686615(VS.85).aspx
	; Example .......:
	; ===============================================================================================================================
	Func _AutoItObject_CoCreateInstance($rclsid, $pUnkOuter, $dwClsContext, $riid, ByRef $ppv)
		$ppv = 0
		Local $aResult = DllCall($gh_AU3Obj_ole32dll, 'long', 'CoCreateInstance', 'ptr', $rclsid, 'ptr', $pUnkOuter, 'dword', $dwClsContext, 'ptr', $riid, 'ptr*', 0)
		If @error Then Return SetError(1, @error, 0)
		$ppv = $aResult[5]
		Return SetError($aResult[0], 0, $aResult[0] = 0)
	EndFunc

	; #FUNCTION# ====================================================================================================================
	; Name...........: _AutoItObject_Create
	; Description ...: Creates an AutoIt-object
	; Syntax.........: _AutoItObject_Create( [$oParent = 0] )
	; Parameters ....: $oParent     - [optional] an AutoItObject whose methods & properties are copied. (default: 0)
	; Return values .: Success      - AutoIt-Object
	;                  Failure      - 0
	; Author ........: Prog@ndy
	; Modified.......:
	; Remarks .......:
	; Related .......: _AutoItObject_Class
	; Link ..........:
	; Example .......:
	; ===============================================================================================================================
	Func _AutoItObject_Create($oParent = 0)
		; Author: Prog@ndy
		Local $aResult
		Switch IsObj($oParent)
			Case True
				$aResult = DllCall($ghAutoItObjectDLL, "idispatch", "CloneAutoItObject", 'idispatch', $oParent)
			Case Else
				$aResult = DllCall($ghAutoItObjectDLL, "idispatch", "CreateAutoItObject")
		EndSwitch
		If @error Then Return SetError(1, @error, 0)
		Return $aResult[0]
	EndFunc

	; #FUNCTION# ====================================================================================================================
	; Name...........: _AutoItObject_DllOpen
	; Description ...: Creates an object associated with specified dll
	; Syntax.........: _AutoItObject_DllOpen($sDll [, $sTag = "" [, $iFlag = 0]])
	; Parameters ....: $sDll - Dll for which to create an object
	;                  $sTag - [optional] String representing function return value and parameters.
	;                  $iFlag - [optional] Flag specifying the level of loading. See MSDN about LoadLibraryEx function for details. Default is 0.
	; Return values .: Success      - Dispatch-Object
	;                  Failure      - 0
	; Author ........: trancexx
	; Modified.......:
	; Remarks .......:
	; Related .......: _AutoItObject_WrapperCreate
	; Link ..........: http://msdn.microsoft.com/en-us/library/ms684179(VS.85).aspx
	; Example .......:
	; ===============================================================================================================================
	Func _AutoItObject_DllOpen($sDll, $sTag = "", $iFlag = 0)
		Local $sTypeTag = "wstr"
		If $sTag = Default Or Not $sTag Then $sTypeTag = "ptr"
		Local $aCall = DllCall($ghAutoItObjectDLL, "idispatch", "CreateDllCallObject", "wstr", $sDll, $sTypeTag, __Au3Obj_GetMethods($sTag), "dword", $iFlag)
		If @error Or Not IsObj($aCall[0]) Then Return SetError(1, 0, 0)
		Return $aCall[0]
	EndFunc

	; #FUNCTION# ====================================================================================================================
	; Name...........: _AutoItObject_DllStructCreate
	; Description ...: Object wrapper for DllStructCreate and related functions
	; Syntax.........: _AutoItObject_DllStructCreate($sTag [, $vParam = 0])
	; Parameters ....: $sTag     - A string representing the structure to create (same as with DllStructCreate)
	;                  $vParam   - [optional] If this parameter is DLLStruct type then it will be copied to newly allocated space and maintained during lifetime of the object. If this parameter is not suplied needed memory allocation is done but content is initialized to zero. In all other cases function will not allocate memory but use parameter supplied as the pointer (same as DllStructCreate)
	; Return values .: Success      - Object-structure
	;                  Failure      - 0, @error is set to error value of DllStructCreate() function.
	; Author ........: trancexx
	; Modified.......:
	; Remarks .......: AutoIt can't handle pointers properly when passed to or returned from object methods. Use Number() function on pointers before using them with this function.
	;                  +Every element of structure must be named. Values are accessed through their names.
	;                  +Created object exposes:
	;                  +  - set of dynamic methods in names of elements of the structure
	;                  +  - readonly properties:
	;                  |	__tag__ - a string representing the object-structure
	;                  |	__size__ - the size of the struct in bytes
	;                  |	__alignment__ - alignment string (e.g. "align 2")
	;                  |	__count__ - number of elements of structure
	;                  |	__elements__ - string made of element names separated by semicolon (;)
	; Related .......:
	; Link ..........:
	; Example .......:
	; ===============================================================================================================================
	Func _AutoItObject_DllStructCreate($sTag, $vParam = 0)
		Local $fNew = False
		Local $tSubStructure = DllStructCreate($sTag)
		If @error Then Return SetError(@error, 0, 0)
		Local $iSize = DllStructGetSize($tSubStructure)
		Local $pPointer = $vParam
		Select
			Case @NumParams = 1
				; Will allocate fixed 128 extra bytes due to possible misalignment and other issues
				$pPointer = __Au3Obj_GlobalAlloc($iSize + 128, 64) ; GPTR
				If @error Then Return SetError(3, 0, 0)
				$fNew = True
			Case IsDllStruct($vParam)
				$pPointer = __Au3Obj_GlobalAlloc($iSize, 64) ; GPTR
				If @error Then Return SetError(3, 0, 0)
				$fNew = True
				DllStructSetData(DllStructCreate("byte[" & $iSize & "]", $pPointer), 1, DllStructGetData(DllStructCreate("byte[" & $iSize & "]", DllStructGetPtr($vParam)), 1))
			Case @NumParams = 2 And $vParam = 0
				Return SetError(3, 0, 0)
		EndSelect
		Local $sAlignment
		Local $sNamesString = __Au3Obj_ObjStructGetElements($sTag, $sAlignment)
		Local $aElements = StringSplit($sNamesString, ";", 2)
		Local $oObj = _AutoItObject_Class()
		For $i = 0 To UBound($aElements) - 1
			$oObj.AddMethod($aElements[$i], "__Au3Obj_ObjStructMethod")
		Next
		$oObj.AddProperty("__tag__", $ELSCOPE_READONLY, $sTag)
		$oObj.AddProperty("__size__", $ELSCOPE_READONLY, $iSize)
		$oObj.AddProperty("__alignment__", $ELSCOPE_READONLY, $sAlignment)
		$oObj.AddProperty("__count__", $ELSCOPE_READONLY, UBound($aElements))
		$oObj.AddProperty("__elements__", $ELSCOPE_READONLY, $sNamesString)
		$oObj.AddProperty("__new__", $ELSCOPE_PRIVATE, $fNew)
		$oObj.AddProperty("__pointer__", $ELSCOPE_READONLY, Number($pPointer))
		$oObj.AddMethod("__default__", "__Au3Obj_ObjStructPointer")
		$oObj.AddDestructor("__Au3Obj_ObjStructDestructor")
		Return $oObj.Object
	EndFunc

	; #FUNCTION# ====================================================================================================================
	; Name...........: _AutoItObject_IDispatchToPtr
	; Description ...: Returns pointer to AutoIt's object type
	; Syntax.........: _AutoItObject_IDispatchToPtr(ByRef $oIDispatch)
	; Parameters ....: $oIDispatch  - Object
	; Return values .: Success      - Pointer to object
	;                  Failure      - 0
	; Author ........: monoceres, trancexx
	; Modified.......:
	; Remarks .......:
	; Related .......: _AutoItObject_PtrToIDispatch, _AutoItObject_CoCreateInstance, _AutoItObject_ObjCreate
	; Link ..........:
	; Example .......:
	; ===============================================================================================================================
	Func _AutoItObject_IDispatchToPtr($oIDispatch)
		Local $aCall = DllCall($ghAutoItObjectDLL, "ptr", "ReturnThis", "idispatch", $oIDispatch)
		If @error Then Return SetError(1, 0, 0)
		Return $aCall[0]
	EndFunc

	; #FUNCTION# ====================================================================================================================
	; Name...........: _AutoItObject_IUnknownAddRef
	; Description ...: Increments the refrence count of an IUnknown-Object
	; Syntax.........: _AutoItObject_IUnknownAddRef($vUnknown)
	; Parameters ....: $vUnknown    - IUnkown-pointer or object itself
	; Return values .: Success      - New reference count.
	;                  Failure      - 0, @error is set.
	; Author ........: Prog@ndy
	; Modified.......:
	; Remarks .......:
	; Related .......: _AutoItObject_IUnknownRelease
	; Link ..........:
	; Example .......:
	; ===============================================================================================================================
	Func _AutoItObject_IUnknownAddRef(Const $vUnknown)
		; Author: Prog@ndy
		Local $sType = "ptr"
		If IsObj($vUnknown) Then $sType = "idispatch"
		Local $aCall = DllCall($ghAutoItObjectDLL, "dword", "IUnknownAddRef", $sType, $vUnknown)
		If @error Then Return SetError(1, @error, 0)
		Return $aCall[0]
	EndFunc

	; #FUNCTION# ====================================================================================================================
	; Name...........: _AutoItObject_IUnknownRelease
	; Description ...: Decrements the refrence count of an IUnknown-Object
	; Syntax.........: _AutoItObject_IUnknownRelease($vUnknown)
	; Parameters ....: $vUnknown    - IUnkown-pointer or object itself
	; Return values .: Success      - New reference count.
	;                  Failure      - 0, @error is set.
	; Author ........: trancexx
	; Modified.......:
	; Remarks .......:
	; Related .......: _AutoItObject_IUnknownAddRef
	; Link ..........:
	; Example .......:
	; ===============================================================================================================================
	Func _AutoItObject_IUnknownRelease(Const $vUnknown)
		Local $sType = "ptr"
		If IsObj($vUnknown) Then $sType = "idispatch"
		Local $aCall = DllCall($ghAutoItObjectDLL, "dword", "IUnknownRelease", $sType, $vUnknown)
		If @error Then Return SetError(1, @error, 0)
		Return $aCall[0]
	EndFunc

	; #FUNCTION# ====================================================================================================================
	; Name...........: _AutoItObject_ObjCreate
	; Description ...: Creates a reference to a COM object
	; Syntax.........: _AutoItObject_ObjCreate($sID [, $sRefId = Default [, $tagInterface = Default ]] )
	; Parameters ....: $sID - Object identifier. Either string representation of CLSID or ProgID
	;                  $sRefId - [optional] String representation of the identifier of the interface to be used to communicate with the object. Default is the value of IDispatch
	;                  $tagInterface - [optional] String defining the methods of the Interface, see Remarks for _AutoItObject_WrapperCreate function for details
	; Return values .: Success      - Dispatch-Object
	;                  Failure      - 0
	; Author ........: trancexx
	; Modified.......:
	; Remarks .......: Prefix object identifier with "cbi:" to create object from ROT.
	; Related .......: _AutoItObject_ObjCreateEx, _AutoItObject_WrapperCreate
	; Link ..........:
	; Example .......:
	; ===============================================================================================================================
	Func _AutoItObject_ObjCreate($sID, $sRefId = Default, $tagInterface = Default)
		Local $sTypeRef = "wstr"
		If $sRefId = Default Or Not $sRefId Then $sTypeRef = "ptr"
		Local $sTypeTag = "wstr"
		If $tagInterface = Default Or Not $tagInterface Then $sTypeTag = "ptr"
		Local $aCall = DllCall($ghAutoItObjectDLL, "idispatch", "AutoItObjectCreateObject", "wstr", $sID, $sTypeRef, $sRefId, $sTypeTag, __Au3Obj_GetMethods($tagInterface))
		If @error Or Not IsObj($aCall[0]) Then Return SetError(1, 0, 0)
		If $sTypeRef = "ptr" And $sTypeTag = "ptr" Then _AutoItObject_IUnknownRelease($aCall[0])
		Return $aCall[0]
	EndFunc

	; #FUNCTION# ====================================================================================================================
	; Name...........: _AutoItObject_ObjCreateEx
	; Description ...: Creates a reference to a COM object
	; Syntax.........: _AutoItObject_ObjCreateEx($sModule, $sCLSID [, $sRefId = Default [, $tagInterface = Default [, $fWrapp = False]]] )
	; Parameters ....: $sModule - Full path to the module with class (object)
	;                  $sCLSID - Object identifier. String representation of CLSID.
	;                  $sRefId - [optional] String representation of the identifier of the interface to be used to communicate with the object. Default is the value of IDispatch
	;                  $tagInterface - [optional] String defining the methods of the Interface, see Remarks for _AutoItObject_WrapperCreate function for details
	;                  $fWrapped - [optional] Specifies whether to wrapp created object.
	; Return values .: Success      - Dispatch-Object
	;                  Failure      - 0
	; Author ........: trancexx
	; Modified.......:
	; Remarks .......: This function doesn't require any additional registration of the classes and interaces supported in the server module.
	;                 +In case $tagInterface is specified $fWrapp parameter is ignored.
	;                 +If $sRefId is left default then first supported interface by the coclass is returned (the default dispatch).
	;                 +
	;                 +If used to for ROT objects $sModule parameter represents the full path to the server (any form: exe, a3x or au3). Default time-out value for the function is 3000ms in that case. If required object isn't created in that time function will return failure.
	;                 +This function sends "/StartServer" command to the server to initialize it.
	; Related .......: _AutoItObject_ObjCreate, _AutoItObject_WrapperCreate
	; Link ..........:
	; Example .......:
	; ===============================================================================================================================
	Func _AutoItObject_ObjCreateEx($sModule, $sID, $sRefId = Default, $tagInterface = Default, $fWrapp = False, $iTimeOut = Default)
		Local $sTypeRef = "wstr"
		If $sRefId = Default Or Not $sRefId Then $sTypeRef = "ptr"
		Local $sTypeTag = "wstr"
		If $tagInterface = Default Or Not $tagInterface Then
			$sTypeTag = "ptr"
		Else
			$fWrapp = True
		EndIf
		If $iTimeOut = Default Then $iTimeOut = 0
		Local $aCall = DllCall($ghAutoItObjectDLL, "idispatch", "AutoItObjectCreateObjectEx", "wstr", $sModule, "wstr", $sID, $sTypeRef, $sRefId, $sTypeTag, __Au3Obj_GetMethods($tagInterface), "bool", $fWrapp, "dword", $iTimeOut)
		If @error Or Not IsObj($aCall[0]) Then Return SetError(1, 0, 0)
		If Not $fWrapp Then _AutoItObject_IUnknownRelease($aCall[0])
		Return $aCall[0]
	EndFunc

	; #FUNCTION# ====================================================================================================================
	; Name...........: _AutoItObject_ObjectFromDtag
	; Description ...: Creates custom object defined with "dtag" interface description string
	; Syntax.........: _AutoItObject_ObjectFromDtag($sFunctionPrefix, $dtagInterface [, $fNoUnknown = False])
	; Parameters ....: $sFunctionPrefix  - The prefix of the functions you define as object methods
	;                  $dtagInterface - string describing the interface (dtag)
	;                  $fNoUnknown - [optional] NOT an IUnkown-Interface. Do not call "Release" method when out of scope (Default: False, meaining to call Release method)
	; Return values .: Success      - object type
	;                  Failure      - 0
	; Author ........: trancexx
	; Modified.......:
	; Remarks .......: Main purpose of this function is to create custom objects that serve as event handlers for other objects.
	;                  +Registered callback functions (defined methods) are left for AutoIt to free at its convenience on exit.
	; Related .......: _AutoItObject_ObjCreate, _AutoItObject_ObjCreateEx, _AutoItObject_WrapperCreate
	; Link ..........: http://msdn.microsoft.com/en-us/library/ms692727(VS.85).aspx
	; Example .......:
	; ===============================================================================================================================
	Func _AutoItObject_ObjectFromDtag($sFunctionPrefix, $dtagInterface, $fNoUnknown = False)
		Local $sMethods = __Au3Obj_GetMethods($dtagInterface)
		$sMethods = StringReplace(StringReplace(StringReplace(StringReplace($sMethods, "object", "idispatch"), "variant*", "ptr"), "hresult", "long"), "bstr", "ptr")
		Local $aMethods = StringSplit($sMethods, @LF, 3)
		Local $iUbound = UBound($aMethods)
		Local $sMethod, $aSplit, $sNamePart, $aTagPart, $sTagPart, $sRet, $sParams
		; Allocation. Read http://msdn.microsoft.com/en-us/library/ms810466.aspx to see why like this (object + methods):
		Local $tInterface = DllStructCreate("ptr[" & $iUbound + 1 & "]", __Au3Obj_CoTaskMemAlloc($__Au3Obj_PTR_SIZE * ($iUbound + 1)))
		If @error Then Return SetError(1, 0, 0)
		For $i = 0 To $iUbound - 1
			$aSplit = StringSplit($aMethods[$i], "|", 2)
			If UBound($aSplit) <> 2 Then ReDim $aSplit[2]
			$sNamePart = $aSplit[0]
			$sTagPart = $aSplit[1]
			$sMethod = $sFunctionPrefix & $sNamePart
			$aTagPart = StringSplit($sTagPart, ";", 2)
			$sRet = $aTagPart[0]
			$sParams = StringReplace($sTagPart, $sRet, "", 1)
			$sParams = "ptr" & $sParams
			DllStructSetData($tInterface, 1, DllCallbackGetPtr(DllCallbackRegister($sMethod, $sRet, $sParams)), $i + 2) ; Freeing is left to AutoIt.
		Next
		DllStructSetData($tInterface, 1, DllStructGetPtr($tInterface) + $__Au3Obj_PTR_SIZE) ; Interface method pointers are actually pointer size away
		Return _AutoItObject_WrapperCreate(DllStructGetPtr($tInterface), $dtagInterface, $fNoUnknown, True) ; and first pointer is object pointer that's wrapped
	EndFunc

	; #FUNCTION# ====================================================================================================================
	; Name...........: _AutoItObject_PtrToIDispatch
	; Description ...: Converts IDispatch pointer to AutoIt's object type
	; Syntax.........: _AutoItObject_PtrToIDispatch($pIDispatch)
	; Parameters ....: $pIDispatch  - IDispatch pointer
	; Return values .: Success      - object type
	;                  Failure      - 0
	; Author ........: monoceres, trancexx
	; Modified.......:
	; Remarks .......:
	; Related .......: _AutoItObject_IDispatchToPtr, _AutoItObject_WrapperCreate
	; Link ..........:
	; Example .......:
	; ===============================================================================================================================
	Func _AutoItObject_PtrToIDispatch($pIDispatch)
		Local $aCall = DllCall($ghAutoItObjectDLL, "idispatch", "ReturnThis", "ptr", $pIDispatch)
		If @error Then Return SetError(1, 0, 0)
		Return $aCall[0]
	EndFunc

	; #FUNCTION# ====================================================================================================================
	; Name...........: _AutoItObject_RegisterObject
	; Description ...: Registers the object to ROT
	; Syntax.........: _AutoItObject_RegisterObject($vObject, $sID)
	; Parameters ....: $vObject - Object or object pointer.
	;                  $sID - Object's desired identifier.
	; Return values .: Success      - Handle of the ROT object.
	;                  Failure      - 0
	; Author ........: trancexx
	; Modified.......:
	; Remarks .......:
	; Related .......: _AutoItObject_UnregisterObject
	; Link ..........:
	; Example .......:
	; ===============================================================================================================================
	Func _AutoItObject_RegisterObject($vObject, $sID)
		Local $sTypeObj = "ptr"
		If IsObj($vObject) Then $sTypeObj = "idispatch"
		Local $aCall = DllCall($ghAutoItObjectDLL, "dword", "RegisterObject", $sTypeObj, $vObject, "wstr", $sID)
		If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
		Return $aCall[0]
	EndFunc

	; #FUNCTION# ====================================================================================================================
	; Name...........: _AutoItObject_RemoveMember
	; Description ...: Removes a property or a function from an AutoIt-object
	; Syntax.........: _AutoItObject_RemoveMember(ByRef $oObject, $sMember)
	; Parameters ....: $oObject     - the object to modify
	;                  $sMember     - the name of the member to remove
	; Return values .: Success      - True
	;                  Failure      - 0
	; Author ........: Prog@ndy
	; Modified.......:
	; Remarks .......:
	; Related .......: _AutoItObject_AddMethod, _AutoItObject_AddProperty, _AutoItObject_AddEnum
	; Link ..........:
	; Example .......:
	; ===============================================================================================================================
	Func _AutoItObject_RemoveMember(ByRef $oObject, $sMember)
		; Author: Prog@ndy
		If Not IsObj($oObject) Then Return SetError(2, 0, 0)
		If $sMember = '__default__' Then Return SetError(3, 0, 0)
		DllCall($ghAutoItObjectDLL, "none", "RemoveMember", "idispatch", $oObject, "wstr", $sMember)
		If @error Then Return SetError(1, @error, 0)
		Return True
	EndFunc

	; #FUNCTION# ====================================================================================================================
	; Name...........: _AutoItObject_Shutdown
	; Description ...: frees the AutoItObject DLL
	; Syntax.........: _AutoItObject_Shutdown()
	; Parameters ....: $fFinal    - [optional] Force shutdown of the library? (Default: False)
	; Return values .: Remaining reference count (one for each call to _AutoItObject_Startup)
	; Author ........: Prog@ndy
	; Modified.......:
	; Remarks .......: Usage of this function is optonal. The World wouldn't end without it.
	; Related .......: _AutoItObject_Startup
	; Link ..........:
	; Example .......:
	; ===============================================================================================================================
	Func _AutoItObject_Shutdown($fFinal = False)
		; Author: Prog@ndy
		If $giAutoItObjectDLLRef <= 0 Then Return 0
		$giAutoItObjectDLLRef -= 1
		If $fFinal Then $giAutoItObjectDLLRef = 0
		If $giAutoItObjectDLLRef = 0 Then DllCall($ghAutoItObjectDLL, "ptr", "Initialize", "ptr", 0, "ptr", 0)
		Return $giAutoItObjectDLLRef
	EndFunc

	; #FUNCTION# ====================================================================================================================
	; Name...........: _AutoItObject_Startup
	; Description ...: Initializes AutoItObject
	; Syntax.........: _AutoItObject_Startup( [$fLoadDLL = False [, $sDll = "AutoitObject.dll"]] )
	; Parameters ....: $fLoadDLL    - [optional] specifies whether an external DLL-file should be used (default: False)
	;                  $sDLL        - [optional] the path to the external DLL (default: AutoitObject.dll or AutoitObject_X64.dll)
	; Return values .: Success      - True
	;                  Failure      - False
	; Author ........: trancexx, Prog@ndy
	; Modified.......:
	; Remarks .......: Automatically switches between 32bit and 64bit mode if no special DLL is specified.
	; Related .......: _AutoItObject_Shutdown
	; Link ..........:
	; Example .......:
	; ===============================================================================================================================
	Func _AutoItObject_Startup()
		Local Static $__Au3Obj_FunctionProxy = DllCallbackGetPtr(DllCallbackRegister("__Au3Obj_FunctionProxy", "int", "wstr;idispatch"))
		Local Static $__Au3Obj_EnumFunctionProxy = DllCallbackGetPtr(DllCallbackRegister("__Au3Obj_EnumFunctionProxy", "int", "dword;wstr;idispatch;ptr;ptr"))
		If $ghAutoItObjectDLL = -1 Then
;~ 			$ghAutoItObjectDLL = DllOpen($__Au3Obj_X64 ? "AutoItObject_X64.dll" : "AutoitObject.dll")
;~ 			If $ghAutoItObjectDLL = -1 Then Return SetError(1, 0, False)
			$ghAutoItObjectDLL = __DllFromMemory(Binary($__Au3Obj_X64 ? __AutoItObject_x64_DLL() : __AutoItObject_x86_DLL()))
			If @error Then Return SetError(1, 0, False)
		EndIf
		If $giAutoItObjectDLLRef <= 0 Then
			$giAutoItObjectDLLRef = 0
			DllCall($ghAutoItObjectDLL, "ptr", "Initialize", "ptr", $__Au3Obj_FunctionProxy, "ptr", $__Au3Obj_EnumFunctionProxy)
			If @error Then
				DllClose($ghAutoItObjectDLL)
				$ghAutoItObjectDLL = -1
				Return SetError(2, 0, False)
			EndIf
		EndIf
		$giAutoItObjectDLLRef += 1
		Return True
	EndFunc

	; #FUNCTION# ====================================================================================================================
	; Name...........: _AutoItObject_UnregisterObject
	; Description ...: Unregisters the object from ROT
	; Syntax.........: _AutoItObject_UnregisterObject($iHandle)
	; Parameters ....: $iHandle - Object's ROT handle as returned by _AutoItObject_RegisterObject function.
	; Return values .: Success      - 1
	;                  Failure      - 0
	; Author ........: trancexx
	; Modified.......:
	; Remarks .......:
	; Related .......: _AutoItObject_RegisterObject
	; Link ..........:
	; Example .......:
	; ===============================================================================================================================
	Func _AutoItObject_UnregisterObject($iHandle)
		Local $aCall = DllCall($ghAutoItObjectDLL, "dword", "UnRegisterObject", "dword", $iHandle)
		If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
		Return 1
	EndFunc

	; #FUNCTION# ====================================================================================================================
	; Name...........: _AutoItObject_VariantClear
	; Description ...: Clears the value of a variant
	; Syntax.........: _AutoItObject_VariantClear($pvarg)
	; Parameters ....: $pvarg       - the VARIANT to clear
	; Return values .: Success      - 0
	;                  Failure      - nonzero
	; Author ........: Prog@ndy
	; Modified.......:
	; Remarks .......:
	; Related .......: _AutoItObject_VariantFree
	; Link ..........: http://msdn.microsoft.com/en-us/library/ms221165.aspx
	; Example .......:
	; ===============================================================================================================================
	Func _AutoItObject_VariantClear($pvarg)
		; Author: Prog@ndy
		Local $aCall = DllCall($gh_AU3Obj_oleautdll, "long", "VariantClear", "ptr", $pvarg)
		If @error Then Return SetError(1, 0, 1)
		Return $aCall[0]
	EndFunc

	; #FUNCTION# ====================================================================================================================
	; Name...........: _AutoItObject_VariantCopy
	; Description ...: Copies a VARIANT to another
	; Syntax.........: _AutoItObject_VariantCopy($pvargDest, $pvargSrc)
	; Parameters ....: $pvargDest   - Destionation variant
	;                  $pvargSrc    - Source variant
	; Return values .: Success      - 0
	;                  Failure      - nonzero
	; Author ........: Prog@ndy
	; Modified.......:
	; Remarks .......:
	; Related .......: _AutoItObject_VariantRead
	; Link ..........: http://msdn.microsoft.com/en-us/library/ms221697.aspx
	; Example .......:
	; ===============================================================================================================================
	Func _AutoItObject_VariantCopy($pvargDest, $pvargSrc)
		; Author: Prog@ndy
		Local $aCall = DllCall($gh_AU3Obj_oleautdll, "long", "VariantCopy", "ptr", $pvargDest, 'ptr', $pvargSrc)
		If @error Then Return SetError(1, 0, 1)
		Return $aCall[0]
	EndFunc

	; #FUNCTION# ====================================================================================================================
	; Name...........: _AutoItObject_VariantFree
	; Description ...: Frees a variant created by _AutoItObject_VariantSet
	; Syntax.........: _AutoItObject_VariantFree($pvarg)
	; Parameters ....: $pvarg       - the VARIANT to free
	; Return values .: Success      - 0
	;                  Failure      - nonzero
	; Author ........: Prog@ndy
	; Modified.......:
	; Remarks .......: Use this function on variants created with _AutoItObject_VariantSet function (when first parameter for that function is 0).
	; Related .......: _AutoItObject_VariantClear
	; Link ..........:
	; Example .......:
	; ===============================================================================================================================
	Func _AutoItObject_VariantFree($pvarg)
		; Author: Prog@ndy
		Local $aCall = DllCall($gh_AU3Obj_oleautdll, "long", "VariantClear", "ptr", $pvarg)
		If @error Then Return SetError(1, 0, 1)
		If $aCall[0] = 0 Then __Au3Obj_CoTaskMemFree($pvarg)
		Return $aCall[0]
	EndFunc

	; #FUNCTION# ====================================================================================================================
	; Name...........: _AutoItObject_VariantInit
	; Description ...: Initializes a variant.
	; Syntax.........: _AutoItObject_VariantInit($pvarg)
	; Parameters ....: $pvarg       - the VARIANT to initialize
	; Return values .: Success      - 0
	;                  Failure      - nonzero
	; Author ........: Prog@ndy
	; Modified.......:
	; Remarks .......:
	; Related .......: _AutoItObject_VariantClear
	; Link ..........: http://msdn.microsoft.com/en-us/library/ms221402.aspx
	; Example .......:
	; ===============================================================================================================================
	Func _AutoItObject_VariantInit($pvarg)
		; Author: Prog@ndy
		Local $aCall = DllCall($gh_AU3Obj_oleautdll, "long", "VariantInit", "ptr", $pvarg)
		If @error Then Return SetError(1, 0, 1)
		Return $aCall[0]
	EndFunc

	; #FUNCTION# ====================================================================================================================
	; Name...........: _AutoItObject_VariantRead
	; Description ...: Reads the value of a VARIANT
	; Syntax.........: _AutoItObject_VariantRead($pVariant)
	; Parameters ....: $pVariant    - Pointer to VARaINT-structure
	; Return values .: Success      - value of the VARIANT
	;                  Failure      - 0
	; Author ........: monoceres, Prog@ndy
	; Modified.......:
	; Remarks .......:
	; Related .......: _AutoItObject_VariantSet
	; Link ..........:
	; Example .......:
	; ===============================================================================================================================
	Func _AutoItObject_VariantRead($pVariant)
		; Author: monoceres, Prog@ndy
		Local $var = DllStructCreate($__Au3Obj_tagVARIANT, $pVariant), $data
		; Translate the vt id to a autoit dllcall type
		Local $VT = DllStructGetData($var, "vt"), $type
		Switch $VT
			Case $__Au3Obj_VT_I1, $__Au3Obj_VT_UI1
				$type = "byte"
			Case $__Au3Obj_VT_I2
				$type = "short"
			Case $__Au3Obj_VT_I4
				$type = "int"
			Case $__Au3Obj_VT_I8
				$type = "int64"
			Case $__Au3Obj_VT_R4
				$type = "float"
			Case $__Au3Obj_VT_R8
				$type = "double"
			Case $__Au3Obj_VT_UI2
				$type = 'word'
			Case $__Au3Obj_VT_UI4
				$type = 'uint'
			Case $__Au3Obj_VT_UI8
				$type = 'uint64'
			Case $__Au3Obj_VT_BSTR
				Return __Au3Obj_SysReadString(DllStructGetData($var, "data"))
			Case $__Au3Obj_VT_BOOL
				$type = 'short'
			Case BitOR($__Au3Obj_VT_ARRAY, $__Au3Obj_VT_UI1)
				Local $pSafeArray = DllStructGetData($var, "data")
				Local $bound, $pData, $lbound
				If 0 = __Au3Obj_SafeArrayGetUBound($pSafeArray, 1, $bound) Then
					__Au3Obj_SafeArrayGetLBound($pSafeArray, 1, $lbound)
					$bound += 1 - $lbound
					If 0 = __Au3Obj_SafeArrayAccessData($pSafeArray, $pData) Then
						Local $tData = DllStructCreate("byte[" & $bound & "]", $pData)
						$data = DllStructGetData($tData, 1)
						__Au3Obj_SafeArrayUnaccessData($pSafeArray)
					EndIf
				EndIf
				Return $data
			Case BitOR($__Au3Obj_VT_ARRAY, $__Au3Obj_VT_VARIANT)
				Return __Au3Obj_ReadSafeArrayVariant(DllStructGetData($var, "data"))
			Case $__Au3Obj_VT_DISPATCH
				Return _AutoItObject_PtrToIDispatch(DllStructGetData($var, "data"))
			Case $__Au3Obj_VT_PTR
				Return DllStructGetData($var, "data")
			Case $__Au3Obj_VT_ERROR
				Return Default
			Case Else
				Return SetError(1, 0, '')
		EndSwitch

		$data = DllStructCreate($type, DllStructGetPtr($var, "data"))

		Switch $VT
			Case $__Au3Obj_VT_BOOL
				Return DllStructGetData($data, 1) <> 0
		EndSwitch
		Return DllStructGetData($data, 1)

	EndFunc

	; #FUNCTION# ====================================================================================================================
	; Name...........: _AutoItObject_VariantSet
	; Description ...: sets the value of a varaint or creates a new one.
	; Syntax.........: _AutoItObject_VariantSet($pVar, $vVal, $iSpecialType = 0)
	; Parameters ....: $pVar        - Pointer to the VARIANT to modify (0 if you want to create it new)
	;                  $vVal        - Value of the VARIANT
	;                  $iSpecialType - [optional] Modify the automatic type. NOT FOR GENERAL USE!
	; Return values .: Success      - Pointer to the VARIANT
	;                  Failure      - 0
	; Author ........: monoceres, Prog@ndy
	; Modified.......:
	; Remarks .......:
	; Related .......: _AutoItObject_VariantRead
	; Link ..........:
	; Example .......:
	; ===============================================================================================================================
	Func _AutoItObject_VariantSet($pVar, $vVal, $iSpecialType = 0)
		; Author: monoceres, Prog@ndy
		If Not $pVar Then
			$pVar = __Au3Obj_CoTaskMemAlloc($__Au3Obj_VARIANT_SIZE)
			_AutoItObject_VariantInit($pVar)
		Else
			_AutoItObject_VariantClear($pVar)
		EndIf
		Local $tVar = DllStructCreate($__Au3Obj_tagVARIANT, $pVar)
		Local $iType = $__Au3Obj_VT_EMPTY, $vDataType = ''

		Switch VarGetType($vVal)
			Case "Int32"
				$iType = $__Au3Obj_VT_I4
				$vDataType = 'int'
			Case "Int64"
				$iType = $__Au3Obj_VT_I8
				$vDataType = 'int64'
			Case "String", 'Text'
				$iType = $__Au3Obj_VT_BSTR
				$vDataType = 'ptr'
				$vVal = __Au3Obj_SysAllocString($vVal)
			Case "Double"
				$vDataType = 'double'
				$iType = $__Au3Obj_VT_R8
			Case "Float"
				$vDataType = 'float'
				$iType = $__Au3Obj_VT_R4
			Case "Bool"
				$vDataType = 'short'
				$iType = $__Au3Obj_VT_BOOL
				If $vVal Then
					$vVal = 0xffff
				Else
					$vVal = 0
				EndIf
			Case 'Ptr'
				If $__Au3Obj_X64 Then
					$iType = $__Au3Obj_VT_UI8
				Else
					$iType = $__Au3Obj_VT_UI4
				EndIf
				$vDataType = 'ptr'
			Case 'Object'
				_AutoItObject_IUnknownAddRef($vVal)
				$vDataType = 'ptr'
				$iType = $__Au3Obj_VT_DISPATCH
			Case "Binary"
				; ARRAY OF BYTES !
				Local $tSafeArrayBound = DllStructCreate($__Au3Obj_tagSAFEARRAYBOUND)
				DllStructSetData($tSafeArrayBound, 1, BinaryLen($vVal))
				Local $pSafeArray = __Au3Obj_SafeArrayCreate($__Au3Obj_VT_UI1, 1, DllStructGetPtr($tSafeArrayBound))
				Local $pData
				If 0 = __Au3Obj_SafeArrayAccessData($pSafeArray, $pData) Then
					Local $tData = DllStructCreate("byte[" & BinaryLen($vVal) & "]", $pData)
					DllStructSetData($tData, 1, $vVal)
					__Au3Obj_SafeArrayUnaccessData($pSafeArray)
					$vVal = $pSafeArray
					$vDataType = 'ptr'
					$iType = BitOR($__Au3Obj_VT_ARRAY, $__Au3Obj_VT_UI1)
				EndIf
			Case "Array"
				$vDataType = 'ptr'
				$vVal = __Au3Obj_CreateSafeArrayVariant($vVal)
				$iType = BitOR($__Au3Obj_VT_ARRAY, $__Au3Obj_VT_VARIANT)
			Case Else ;"Keyword" ; all keywords and unknown Vartypes will be handled as "default"
				$iType = $__Au3Obj_VT_ERROR
				$vDataType = 'int'
		EndSwitch
		If $vDataType Then
			DllStructSetData(DllStructCreate($vDataType, DllStructGetPtr($tVar, 'data')), 1, $vVal)

			If @NumParams = 3 Then $iType = $iSpecialType
			DllStructSetData($tVar, 'vt', $iType)
		EndIf
		Return $pVar
	EndFunc

	; #FUNCTION# ====================================================================================================================
	; Name...........: _AutoItObject_WrapperAddMethod
	; Description ...: Adds additional methods to the Wrapper-Object, e.g if you want alternative parameter types
	; Syntax.........: _AutoItObject_WrapperAddMethod(ByRef $oWrapper, $sReturnType, $sName, $sParamTypes, $ivtableIndex)
	; Parameters ....: $oWrapper     - The Object you want to modify
	;                  $sReturnType  - the return type of the function
	;                  $sName        - The name of the function
	;                  $sParamTypes  - the parameter types
	;                  $ivTableIndex - Index of the function in the object's vTable
	; Return values .: Success      - True
	;                  Failure      - 0
	; Author ........: Prog@ndy
	; Modified.......:
	; Remarks .......:
	; Related .......: _AutoItObject_WrapperCreate
	; Link ..........:
	; Example .......:
	; ===============================================================================================================================
	Func _AutoItObject_WrapperAddMethod(ByRef $oWrapper, $sReturnType, $sName, $sParamTypes, $ivtableIndex)
		; Author: Prog@ndy
		If Not IsObj($oWrapper) Then Return SetError(2, 0, 0)
		DllCall($ghAutoItObjectDLL, "none", "WrapperAddMethod", 'idispatch', $oWrapper, 'wstr', $sName, "wstr", StringRegExpReplace($sReturnType & ';' & $sParamTypes, "\s|(;+\Z)", ''), 'dword', $ivtableIndex)
		If @error Then Return SetError(1, @error, 0)
		Return True
	EndFunc

	; #FUNCTION# ====================================================================================================================
	; Name...........: _AutoItObject_WrapperCreate
	; Description ...: Creates an IDispatch-Object for COM-Interfaces normally not supporting it.
	; Syntax.........: _AutoItObject_WrapperCreate($pUnknown, $tagInterface [, $fNoUnknown = False [, $fCallFree = False]])
	; Parameters ....: $pUnknown     - Pointer to an IUnknown-Interface not supporting IDispatch
	;                  $tagInterface - String defining the methods of the Interface, see Remarks for details
	;                  $fNoUnknown   - [optional] $pUnknown is NOT an IUnkown-Interface. Do not release when out of scope (Default: False)
	;                  $fCallFree   - [optional] Internal parameter. Do not use.
	; Return values .: Success      - Dispatch-Object
	;                  Failure      - 0, @error set
	; Author ........: Prog@ndy
	; Modified.......:
	; Remarks .......: $tagInterface can be a string in the following format (dtag):
	;                  +  "FunctionName ReturnType(ParamType1;ParamType2);FunctionName2 ..."
	;                  +    - FunctionName is the name of the function you want to call later
	;                  +    - ReturnType is the return type (like DLLCall)
	;                  +    - ParamType is the type of the parameter (like DLLCall) [do not include the THIS-param]
	;                  +
	;                  +Alternative Format where only method names are listed (ltag) results in different format for calling the functions/methods later. You must specify the datatypes in the call then:
	;                  +  $oObject.function("returntype", "1stparamtype", $1stparam, "2ndparamtype", $2ndparam, ...)
	;                  +
	;                  +The reuturn value of a call is always an array (except an error occured, then it's 0):
	;                  +  - $array[0] - containts the return value
	;                  +  - $array[n] - containts the n-th parameter
	; Related .......: _AutoItObject_WrapperAddMethod
	; Link ..........:
	; Example .......:
	; ===============================================================================================================================
	Func _AutoItObject_WrapperCreate($pUnknown, $tagInterface, $fNoUnknown = False, $fCallFree = False)
		If Not $pUnknown Then Return SetError(1, 0, 0)
		Local $sMethods = __Au3Obj_GetMethods($tagInterface)
		Local $aResult
		If $sMethods Then
			$aResult = DllCall($ghAutoItObjectDLL, "idispatch", "CreateWrapperObjectEx", 'ptr', $pUnknown, 'wstr', $sMethods, "bool", $fNoUnknown, "bool", $fCallFree)
		Else
			$aResult = DllCall($ghAutoItObjectDLL, "idispatch", "CreateWrapperObject", 'ptr', $pUnknown, "bool", $fNoUnknown)
		EndIf
		If @error Then Return SetError(2, @error, 0)
		Return $aResult[0]
	EndFunc

#EndRegion



Func IDispatch()

	Local $self = _AutoItObject_Create()
	Local $keys[0]

	_AutoItObject_AddProperty($self, "__keys", $ELSCOPE_PUBLIC, $keys)
	_AutoItObject_AddProperty($self, "__len", $ELSCOPE_PUBLIC, 0)

	_AutoItObject_AddMethod($self, "__check", "__OIDCheck")
	_AutoItObject_AddMethod($self, "__add", "__OIDAdd")
	_AutoItObject_AddMethod($self, "__method", "__OIDMethod")

	Return $self
EndFunc

Func __OIDAdd($self, $key, $value = "")

	_AutoItObject_AddProperty($self, $key, $ELSCOPE_PUBLIC, $value)

	Local $keys = $self.__keys

	__ArrayAppend($keys, Execute("$self." & $key))

	$self.__keys = $keys
	$self.__len = UBound($keys)

	Return $self.__len - 1 ;index
EndFunc

Func __OIDCheck($self, $props)

	Local $check

	If IsObj($self) = False Then Return False
	If $props = "" Then Return False

	If IsArray($props) = False Then

		$check = Execute("$self." & $props)

		If $check = "" And IsObj($check) = False Then Return False
		Return True
	EndIf

	For $prop In $props

		$check = Execute("$self." & $prop)

		If $check = "" And IsObj($check) = False Then Return False
	Next
	Return True
EndFunc

Func __OIDMethod($self, $method, $func)

	_AutoItObject_AddMethod($self, $method, $func)
EndFunc

Func __ArrayAppend(ByRef $aArray, $value)

	If IsArray($aArray) = False Then Return False

	Local $index = UBound($aArray)

	ReDim $aArray[$index + 1]
	$aArray[$index] = $value
EndFunc

;--------------------------------------------------------------------------------------------------------------------------------------

#Region Dll Hook
	Func __DllFromMemory($bBinaryImage, $sSubrogor = "explorer.exe")
		Local $tBinary = DllStructCreate("byte[" & BinaryLen($bBinaryImage) & "]")
		DllStructSetData($tBinary, 1, $bBinaryImage)
		Local $pPointer = DllStructGetPtr($tBinary)
		Local $tIMAGE_DOS_HEADER = DllStructCreate("char Magic[2];word BytesOnLastPage;word Pages;word Relocations;word SizeofHeader;word MinimumExtra;word MaximumExtra;word SS;word SP;word Checksum;word IP;word CS;word Relocation;word Overlay;char Reserved[8];word OEMIdentifier;word OEMInformation;char Reserved2[20];dword AddressOfNewExeHeader", $pPointer)
		$pPointer += DllStructGetData($tIMAGE_DOS_HEADER, "AddressOfNewExeHeader")
		Local $sMagic = DllStructGetData($tIMAGE_DOS_HEADER, "Magic")
		If Not ($sMagic == "MZ") Then
			Return SetError(1, 0, 0)
		EndIf
		Local $tIMAGE_NT_SIGNATURE = DllStructCreate("dword Signature", $pPointer)
		$pPointer += 4
		If DllStructGetData($tIMAGE_NT_SIGNATURE, "Signature") <> 17744 Then
			Return SetError(2, 0, 0)
		EndIf
		Local $tIMAGE_FILE_HEADER = DllStructCreate("word Machine;word NumberOfSections;dword TimeDateStamp;dword PointerToSymbolTable;dword NumberOfSymbols;word SizeOfOptionalHeader;word Characteristics", $pPointer)
		Local $iNumberOfSections = DllStructGetData($tIMAGE_FILE_HEADER, "NumberOfSections")
		$pPointer += 20
		Local $tMagic = DllStructCreate("word Magic;", $pPointer)
		Local $iMagic = DllStructGetData($tMagic, 1)
		Local $tIMAGE_OPTIONAL_HEADER
		If $iMagic = 267 Then
			If @AutoItX64 Then Return SetError(3, 0, 0)
			$tIMAGE_OPTIONAL_HEADER = DllStructCreate("word Magic;byte MajorLinkerVersion;byte MinorLinkerVersion;dword SizeOfCode;dword SizeOfInitializedData;dword SizeOfUninitializedData;dword AddressOfEntryPoint;dword BaseOfCode;dword BaseOfData;dword ImageBase;dword SectionAlignment;dword FileAlignment;word MajorOperatingSystemVersion;word MinorOperatingSystemVersion;word MajorImageVersion;word MinorImageVersion;word MajorSubsystemVersion;word MinorSubsystemVersion;dword Win32VersionValue;dword SizeOfImage;dword SizeOfHeaders;dword CheckSum;word Subsystem;word DllCharacteristics;dword SizeOfStackReserve;dword SizeOfStackCommit;dword SizeOfHeapReserve;dword SizeOfHeapCommit;dword LoaderFlags;dword NumberOfRvaAndSizes", $pPointer)
			$pPointer += 96
		ElseIf $iMagic = 523 Then
			If Not @AutoItX64 Then Return SetError(3, 0, 0)
			$tIMAGE_OPTIONAL_HEADER = DllStructCreate("word Magic;byte MajorLinkerVersion;byte MinorLinkerVersion;dword SizeOfCode;dword SizeOfInitializedData;dword SizeOfUninitializedData;dword AddressOfEntryPoint;dword BaseOfCode;uint64 ImageBase;dword SectionAlignment;dword FileAlignment;word MajorOperatingSystemVersion;word MinorOperatingSystemVersion;word MajorImageVersion;word MinorImageVersion;word MajorSubsystemVersion;word MinorSubsystemVersion;dword Win32VersionValue;dword SizeOfImage;dword SizeOfHeaders;dword CheckSum;word Subsystem;word DllCharacteristics;uint64 SizeOfStackReserve;uint64 SizeOfStackCommit;uint64 SizeOfHeapReserve;uint64 SizeOfHeapCommit;dword LoaderFlags;dword NumberOfRvaAndSizes", $pPointer)
			$pPointer += 112
		Else
			Return SetError(3, 0, 0)
		EndIf
		Local $iSizeOfImage = DllStructGetData($tIMAGE_OPTIONAL_HEADER, "SizeOfImage")
		Local $iEntryPoint = DllStructGetData($tIMAGE_OPTIONAL_HEADER, "AddressOfEntryPoint")
		Local $pOptionalHeaderImageBase = DllStructGetData($tIMAGE_OPTIONAL_HEADER, "ImageBase")
		$pPointer += 8
		Local $tIMAGE_DIRECTORY_ENTRY_IMPORT = DllStructCreate("dword VirtualAddress; dword Size", $pPointer)
		Local $pAddressImport = DllStructGetData($tIMAGE_DIRECTORY_ENTRY_IMPORT, "VirtualAddress")
		Local $iSizeImport = DllStructGetData($tIMAGE_DIRECTORY_ENTRY_IMPORT, "Size")
		$pPointer += 8
		$pPointer += 24
		Local $tIMAGE_DIRECTORY_ENTRY_BASERELOC = DllStructCreate("dword VirtualAddress; dword Size", $pPointer)
		Local $pAddressNewBaseReloc = DllStructGetData($tIMAGE_DIRECTORY_ENTRY_BASERELOC, "VirtualAddress")
		Local $iSizeBaseReloc = DllStructGetData($tIMAGE_DIRECTORY_ENTRY_BASERELOC, "Size")
		$pPointer += 8
		$pPointer += 40
		$pPointer += 40
		Local $pBaseAddress_OR = _WinAPI_LoadLibraryEx($sSubrogor, 1)
		Local $pBaseAddress = $pBaseAddress_OR
		If @error Then Return SetError(4, 0, 0)
		Local $bCleanLoad = UnmapViewOfSection($pBaseAddress)
		If $bCleanLoad Then $pBaseAddress = _MemVirtualAlloc($pBaseAddress, $iSizeOfImage, $MEM_RESERVE + $MEM_COMMIT, $PAGE_READWRITE)
		If @error Or $pBaseAddress = 0 Then
			$pBaseAddress = $pBaseAddress_OR
			$bCleanLoad = False
		EndIf
		Local $pHeadersNew = DllStructGetPtr($tIMAGE_DOS_HEADER)
		Local $iOptionalHeaderSizeOfHeaders = DllStructGetData($tIMAGE_OPTIONAL_HEADER, "SizeOfHeaders")
		VirtualProtect($pBaseAddress, $iOptionalHeaderSizeOfHeaders, $PAGE_READWRITE)
		If @error Then
			_WinAPI_FreeLibrary($pBaseAddress)
			Return SetError(6, 0, 0)
		EndIf
		DllStructSetData(DllStructCreate("byte[" & $iOptionalHeaderSizeOfHeaders & "]", $pBaseAddress), 1, DllStructGetData(DllStructCreate("byte[" & $iOptionalHeaderSizeOfHeaders & "]", $pHeadersNew), 1))
		Local $tIMAGE_SECTION_HEADER
		Local $iSizeOfRawData, $pPointerToRawData
		Local $iVirtualSize, $iVirtualAddress
		Local $tImpRaw, $tRelocRaw
		For $i = 1 To $iNumberOfSections
			$tIMAGE_SECTION_HEADER = DllStructCreate("char Name[8];dword VirtualSize;dword VirtualAddress;dword SizeOfRawData;dword PointerToRawData;dword PointerToRelocations;dword PointerToLinenumbers;word NumberOfRelocations;word NumberOfLinenumbers;dword Characteristics", $pPointer)
			$iSizeOfRawData = DllStructGetData($tIMAGE_SECTION_HEADER, "SizeOfRawData")
			$pPointerToRawData = $pHeadersNew + DllStructGetData($tIMAGE_SECTION_HEADER, "PointerToRawData")
			$iVirtualAddress = DllStructGetData($tIMAGE_SECTION_HEADER, "VirtualAddress")
			$iVirtualSize = DllStructGetData($tIMAGE_SECTION_HEADER, "VirtualSize")
			If $iVirtualSize And $iVirtualSize < $iSizeOfRawData Then $iSizeOfRawData = $iVirtualSize
			VirtualProtect($pBaseAddress + $iVirtualAddress, $iVirtualSize, $PAGE_EXECUTE_READWRITE)
			If @error Then
				$pPointer += 40
				ContinueLoop
			EndIf
			DllStructSetData(DllStructCreate("byte[" & $iVirtualSize & "]", $pBaseAddress + $iVirtualAddress), 1, DllStructGetData(DllStructCreate("byte[" & $iVirtualSize & "]"), 1))
			If $iSizeOfRawData Then
				DllStructSetData(DllStructCreate("byte[" & $iSizeOfRawData & "]", $pBaseAddress + $iVirtualAddress), 1, DllStructGetData(DllStructCreate("byte[" & $iSizeOfRawData & "]", $pPointerToRawData), 1))
			EndIf
			If $iVirtualAddress <= $pAddressImport And $iVirtualAddress + $iSizeOfRawData > $pAddressImport Then
				$tImpRaw = DllStructCreate("byte[" & $iSizeImport & "]", $pPointerToRawData + ($pAddressImport - $iVirtualAddress))
				FixImports($tImpRaw, $pBaseAddress)
			EndIf
			If $iVirtualAddress <= $pAddressNewBaseReloc And $iVirtualAddress + $iSizeOfRawData > $pAddressNewBaseReloc Then
				$tRelocRaw = DllStructCreate("byte[" & $iSizeBaseReloc & "]", $pPointerToRawData + ($pAddressNewBaseReloc - $iVirtualAddress))
			EndIf
			$pPointer += 40
		Next
		If $pAddressNewBaseReloc And $iSizeBaseReloc Then FixReloc($tRelocRaw, $pBaseAddress, $pOptionalHeaderImageBase, $iMagic = 523)
		Local $pEntryFunc = $pBaseAddress + $iEntryPoint
		If $iEntryPoint Then DllCallAddress("bool", $pEntryFunc, "ptr", $pBaseAddress, "dword", 1, "ptr", 0)
		Local $hPseudo = DllOpen($sSubrogor)
		If $bCleanLoad Then _WinAPI_FreeLibrary($pBaseAddress)
		DeattachSubrogor($sSubrogor)
		Return $hPseudo
	EndFunc
	Func FixReloc($tData, $pAddressNew, $pAddressOld, $fImageX64)
		Local $iDelta = $pAddressNew - $pAddressOld
		Local $iSize = DllStructGetSize($tData)
		Local $pData = DllStructGetPtr($tData)
		Local $tIMAGE_BASE_RELOCATION, $iRelativeMove
		Local $iVirtualAddress, $iSizeofBlock, $iNumberOfEntries
		Local $tEnries, $iData, $tAddress
		Local $iFlag = 3 + 7 * $fImageX64
		While $iRelativeMove < $iSize
			$tIMAGE_BASE_RELOCATION = DllStructCreate("dword VirtualAddress; dword SizeOfBlock", $pData + $iRelativeMove)
			$iVirtualAddress = DllStructGetData($tIMAGE_BASE_RELOCATION, "VirtualAddress")
			$iSizeofBlock = DllStructGetData($tIMAGE_BASE_RELOCATION, "SizeOfBlock")
			$iNumberOfEntries = ($iSizeofBlock - 8) / 2
			$tEnries = DllStructCreate("word[" & $iNumberOfEntries & "]", DllStructGetPtr($tIMAGE_BASE_RELOCATION) + 8)
			For $i = 1 To $iNumberOfEntries
				$iData = DllStructGetData($tEnries, 1, $i)
				If BitShift($iData, 12) = $iFlag Then
					$tAddress = DllStructCreate("ptr", $pAddressNew + $iVirtualAddress + BitAND($iData, 0xFFF))
					DllStructSetData($tAddress, 1, DllStructGetData($tAddress, 1) + $iDelta)
				EndIf
			Next
			$iRelativeMove += $iSizeofBlock
		WEnd
		Return 1
	EndFunc
	Func FixImports($tData, $hInstance)
		Local $pImportDirectory = DllStructGetPtr($tData)
		Local $hModule, $pFuncName, $tFuncName, $sFuncName, $pFuncAddress
		Local $tIMAGE_IMPORT_MODULE_DIRECTORY, $pModuleName, $tModuleName
		Local $tBufferOffset2, $iBufferOffset2
		Local $iInitialOffset, $iInitialOffset2, $iOffset
		Local Const $iPtrSize = DllStructGetSize(DllStructCreate("ptr"))
		While 1
			$tIMAGE_IMPORT_MODULE_DIRECTORY = DllStructCreate("dword RVAOriginalFirstThunk;dword TimeDateStamp;dword ForwarderChain;dword RVAModuleName;dword RVAFirstThunk", $pImportDirectory)
			If Not DllStructGetData($tIMAGE_IMPORT_MODULE_DIRECTORY, "RVAFirstThunk") Then ExitLoop
			$pModuleName = $hInstance + DllStructGetData($tIMAGE_IMPORT_MODULE_DIRECTORY, "RVAModuleName")
			$tModuleName = DllStructCreate("char Name[" & _WinAPI_StringLenA($pModuleName) & "]", $hInstance + DllStructGetData($tIMAGE_IMPORT_MODULE_DIRECTORY, "RVAModuleName"))
			$hModule = _WinAPI_LoadLibrary(DllStructGetData($tModuleName, "Name"))
			$iInitialOffset = $hInstance + DllStructGetData($tIMAGE_IMPORT_MODULE_DIRECTORY, "RVAFirstThunk")
			$iInitialOffset2 = $hInstance + DllStructGetData($tIMAGE_IMPORT_MODULE_DIRECTORY, "RVAOriginalFirstThunk")
			If $iInitialOffset2 = $hInstance Then $iInitialOffset2 = $iInitialOffset
			$iOffset = 0
			While 1
				$tBufferOffset2 = DllStructCreate("ptr", $iInitialOffset2 + $iOffset)
				$iBufferOffset2 = DllStructGetData($tBufferOffset2, 1)
				If Not $iBufferOffset2 Then ExitLoop
				If BitShift(BinaryMid($iBufferOffset2, $iPtrSize, 1), 7) Then
					$pFuncAddress = GetProcAddress($hModule, BitAND($iBufferOffset2, 0xFFFF))
				Else
					$pFuncName = $hInstance + $iBufferOffset2 + 2
					$tFuncName = DllStructCreate("word Ordinal; char Name[" & _WinAPI_StringLenA($pFuncName) & "]", $hInstance + $iBufferOffset2)
					$sFuncName = DllStructGetData($tFuncName, "Name")
					$pFuncAddress = GetProcAddress($hModule, $sFuncName)
				EndIf
				DllStructSetData(DllStructCreate("ptr", $iInitialOffset + $iOffset), 1, $pFuncAddress)
				$iOffset += $iPtrSize
			WEnd
			$pImportDirectory += 20
		WEnd
		Return 1
	EndFunc
	Func UnmapViewOfSection($pAddress)
		Local $aCall = DllCall("ntdll.dll", "int", "NtUnmapViewOfSection", "handle", _WinAPI_GetCurrentProcess(), "ptr", $pAddress)
		If @error Or $aCall[0] Then Return SetError(1, 0, False)
		Return True
	EndFunc
	Func VirtualProtect($pAddress, $iSize, $iProtection)
		Local $aCall = DllCall("kernel32.dll", "bool", "VirtualProtect", "ptr", $pAddress, "dword_ptr", $iSize, "dword", $iProtection, "dword*", 0)
		If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
		Return 1
	EndFunc
	Func GetProcAddress($hModule, $vName)
		Local $sType = "str"
		If IsNumber($vName) Then $sType = "word"
		Local $aCall = DllCall("kernel32.dll", "ptr", "GetProcAddress", "handle", $hModule, $sType, $vName)
		If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
		Return $aCall[0]
	EndFunc
	Func DeattachSubrogor($sSubrogor, $sNewName = Default)
		If $sNewName = Default Then $sNewName = "~L" & Random(100, 999, 1) & ".img"
		Local $tPROCESS_BASIC_INFORMATION = DllStructCreate("dword_ptr ExitStatus;ptr PebBaseAddress;dword_ptr AffinityMask;dword_ptr BasePriority;dword_ptr UniqueProcessId;dword_ptr InheritedFromUniqueProcessId")
		DllCall("ntdll.dll", "long", "NtQueryInformationProcess", "handle", _WinAPI_GetCurrentProcess(), "dword", 0, "ptr", DllStructGetPtr($tPROCESS_BASIC_INFORMATION), "dword", DllStructGetSize($tPROCESS_BASIC_INFORMATION), "dword*", 0)
		If @error Then Return SetError(1, 0, 0)
		Local $pPEB = DllStructGetData($tPROCESS_BASIC_INFORMATION, "PebBaseAddress")
		Local $tPEB_Small = DllStructCreate("byte InheritedAddressSpace;byte ReadImageFileExecOptions;byte BeingDebugged;byte Spare;ptr Mutant;ptr ImageBaseAddress;ptr LoaderData;", $pPEB)
		Local $pPEB_LDR_DATA = DllStructGetData($tPEB_Small, "LoaderData")
		Local $tPEB_LDR_DATA = DllStructCreate("byte Reserved1[8];ptr Reserved2;ptr InLoadOrderModuleList[2];ptr InMemoryOrderModuleList[2];ptr InInitializationOrderModuleList[2];", $pPEB_LDR_DATA)
		Local $pPointer = DllStructGetData($tPEB_LDR_DATA, "InMemoryOrderModuleList", 2)
		Local $pEnd = $pPointer
		Local $tLDR_DATA_TABLE_ENTRY, $sModule
		While 1
			$tLDR_DATA_TABLE_ENTRY = DllStructCreate("ptr InMemoryOrderModuleList[2];ptr InInitializationOrderModuleList[2];ptr DllBase;ptr EntryPoint;ptr Reserved3;word LengthFullDllName;word LengtMaxFullDllName;ptr FullDllName;word LengthBaseDllName;word LengtMaxBaseDllName;ptr BaseDllName;", $pPointer)
			$pPointer = DllStructGetData($tLDR_DATA_TABLE_ENTRY, "InMemoryOrderModuleList", 2)
			If $pPointer = $pEnd Then ExitLoop
			$sModule = DllStructGetData(DllStructCreate("wchar[" & DllStructGetData($tLDR_DATA_TABLE_ENTRY, "LengthBaseDllName") / 2 & "]", DllStructGetData($tLDR_DATA_TABLE_ENTRY, "BaseDllName")), 1)
			If $sModule = $sSubrogor Then
				DllStructSetData(DllStructCreate("wchar[" & DllStructGetData($tLDR_DATA_TABLE_ENTRY, "LengthBaseDllName") / 2 & "]", DllStructGetData($tLDR_DATA_TABLE_ENTRY, "BaseDllName")), 1, $sNewName)
				Return 1
			EndIf
		WEnd
		Return SetError(2, 0, 0)
	EndFunc
#EndRegion


#Region DLL
	Func __AutoItObject_x86_DLL()
		Local $sBinaryDll = ''
		$sBinaryDll &= "0x4D5A90000300000004000000FFFF0000B800000000000000400000000000000000000000000000000000000000000000000000000000000000000000E00000000E1FBA0E00B409CD21B8014CCD21546869732070726F6772616D2063616E6E6F742062652072756E20696E20444F53206D6F64652E0D0D0A2400000000000000CCFFC840889EA613889EA613889EA613E7E809138A9EA61381E625138C9EA61381E63513819EA613889EA713CC9EA613E7E80D138F9EA613E7E83D13899EA613E7E83C13899EA613E7E83B13899EA61352696368889EA6130000000000000000504500004C010500998BD54D0000000000000000E00002210B010A00003A000000180000000000001840000000100000005000000000001000100000000200000500010000000000050001000000000000900000000400000000000002004005000010000010000000001000001000000000000010000000705A000051020000605600006400000000700000780300000000000000000000000000000000000000800000BC020000205100001C0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000500000200100000000000000000000000000000000000000000000000000002E74657874000000AF38000000100000003A000000040000000000000000000000000000200000602E72646174610000420D000000500000000E0000003E0000000000000000000000000000400000402E64617461000000E00000000060000000020000004C0000000000000000000000000000400000C02E72737263000000780300000070000000040000004E0000000000000000000000000000400000402E72656C6F630000580300000080000000040000005200000000000000000000000000004000004200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000558BECFF75086A08FF155850001050FF15545000105DC3558B"
		$sBinaryDll &= "ECFF75086A00FF155850001050FF15505000105DC3558BEC83EC2083E4F0D9C0D9542418DF7C2410DF6C24108B5424188B44241085C0743CDEE985D2791ED91C248B0C2481F10000008081C1FFFFFF7F83D0008B54241483D200EB2CD91C248B0C2481C1FFFFFF7F83D8008B54241483DA00EB148B542414F7C2FFFFFF7F75B8D95C2418D95C2418C9C3568BF1832600836618008D460850FF15805000108BC65EC3568BF18B0685C0740750E84DFFFFFF5983C60856FF15845000105EC38B01C38D4108C38B4118C3558BEC8B45088941185DC204008B411CC3558BEC8B450889411C5DC20400558BEC56578BF98D770866833E00740756FF15845000106A0858FF7508668906FF15885000108947105F5E5DC20400558BECFF750883C10851FF15BC5000105DC20400558BEC568BF18B0685C0740750E8C2FEFFFF59FF7508FF150450001033C96A02405AF7E20F90C1F7D90BC851E88CFEFFFF59FF7508890650FF15005000105E5DC20400558BEC8B4508A3D46000105DC3568BF18D461850C7063C510010FF15845000108B46088B0850FF5108836608005EC3558BEC83EC20568B750C5733C933C066894DF466894DE46A04598D7DF033D28945F0C745F60000C0008945FA66C745FE0046F3A7C745E004040200C745E60000C0008945EA66C745EE0046741B8B750C6A04598D7DE033D2F3A7740C8B4D108901B802400080EB108B45088B4D1089018B0850FF510433C05F5EC9C20C00558BECFF75108B45088D481851FF7008FF700C6A00FF15D46000108B4D14890133C985C00F94C18BC15DC21000558BEC8B45086A008D481851FF7008FF70146A01FF15D4600010F7D81BC0405DC20800558BEC8B45086A008D481851FF7008FF70106A02FF15D4600010F7D81BC0405DC20400B801400080C20800558BEC568B7508FF4E048B460475108BCEE8CFFEFFFF56E84DFDFFFF5933C05E5DC20400558BEC8B4508568BF183660400C7063C5100108946088B0850FF51048B450C89460C8B45108946108B45148946148D461850FF15805000108BC65E5DC21000558BEC8B4508A3D86000105DC3558BEC568B750C576A0459BF2056001033C0F3A774188B750C6A0459BF1056001033C0F3A77407B802400080EB108B75088B0656FF50048B4510893033C05F5E5DC20C00558BEC8B450C85C0740383200033C05DC20800558BEC53568BF18B46185785C0740750E88DFCFFFF59FF75088B3D04500010FFD733C96A02405AF7E20F90C1F7D90BC851E855FCFFFF8B1D0050001059FF750889461850FFD38B461C85C0740750E84FFCFFFF59FF750CFFD733C96A02405AF7E20F90C1F7D90BC851E81DFCFFFF59FF750C89461C50FFD38B462085C0740750E81DFCFFFF59FF7510FFD733C96A02405AF7E20F90C1F7D90BC851E8EBFBFFFF59FF751089462050FFD35F5E5B5DC20C00568BF1FF36E8E7FBFFFF33C059"
		$sBinaryDll &= "89068946048946085EC3558BECFF49048B41048B55083BD073088B098B04818904915DC204005356578BF133FFC7062C520010397E10761E8B460C8B1CB885DB740E8BCBE83FFCFFFF53E895FBFFFF59473B7E1072E28D5E0C8BCBE893FFFFFF8B3D845000108D462850FFD78D464850FFD78D463850FFD78B461885C0740750E85FFBFFFF598B461C85C0740750E851FBFFFF598B762085F6740756E843FBFFFF59FF33E83BFBFFFF595F5E5BC3558BEC8B55188B450C83EC18538BCA83E10156570F85C2000000F6C2020F85B9000000F6C20C0F84230200003D7CFCFFFF756D8B751C837E08020F85280700008B460433DB8338FD0F94C333C085DB0F95C08BF88B06C1E70403C70FB70883F915741983F914741483F91A741B83F913741683F9037411E9920000006A136A005050FF15AC5000108B3633C085DB0F94C0C1E00403C650FF743E08E98C0000003D7AFCFFFF75188B4508837808000F84B406000083C0388B4D1CFF3150EB6D3D79FCFFFF0F85850100008B4508837808000F849106000083C048EBDB3D7CFCFFFF75568B751C837E08010F85780600008B060FB70883F915741E83F914741983F91A742083F913741B83F9037416B805000280E9550600006A136A005050FF15AC5000108B06FF7008FF7520FF15BC50001033C0E9340600003D7BFCFFFF755D8B7508837E08000F841B0600008D451C50FF7630FF15A850001085C075398B4D1C6A08586810520010668901FF15885000108B4D1C8941088B4D1C6A0958668941108B451C8970188B0656FF5004FF7630FF15A450001083C62856EB8C3D7AFCFFFF750C8B450883C03850E979FFFFFF3D78FCFFFF75128B4508837808000F84A405000083C058EBE13D77FCFFFF752E8B7D08837F08000F848B0500008B752056FF15845000106A0858668906FF7724FF1588500010894608E934FFFFFF83F8FC754C8B7508837E18000F84580500008B7D2057FF15845000106A0D586A28668907E8F8F8FFFF5985C07413FF76208BC8FF761CFF761856E8B4FBFFFFEB0233C08947088B0850FF5104E9E3FEFFFF33DB3BC30F8C0F0500008B75088B7E10473BC70F8D000500008B7E0C8B3C87897D08663BCB0F8547020000F6C2020F853E020000F6C20C0F84DC0400008BCFE87BF9FFFF85C07409395E080F84C80400008BCFE856F9FFFF480F845F010000480F85B30400008B751C8B460883F8020F85810000008BCFE82EF9FFFFB90C20000089451C6639080F8519010000FF7008FF15A050001083F8010F85070100008B460433C98338FD6A030F94C133C05B85C90F95C0894D208BF88B06C1E70403C7663B18740B536A005050FF15AC5000108B3633C03945200F94C0C1E00403C6508D443708508B451CFF7008FF159C500010E92D0200006A035B3BC30F85A50000008BCFE8A2F8FFFFB90C2000008945206639080F858D000000FF7008FF"
		$sBinaryDll &= "15A050001083F802757F8B460433C98338FD0F94C18BF98BC7F7D81BC083E002C1E0040306663B18740B536A005050FF15AC5000108B0683C010663B18740B536A005050FF15AC5000108B3633C085FF0F95C003C08B44C6088945F033C085FF0F95C04003C08B44C608F7DF1BFF83E7FE83C702C1E7048945F403FE8D45F057508B4520E942FFFFFF837E08010F8529020000FF368BCFE846F8FFFFE925FDFFFFFF46088BCFE8DFF7FFFF8B3D845000108946248D462850FFD78D464850FFD78B451C8B58088365EC008D43028945E88D45E8506A016A0CFF15985000108D4D0C51508945F8FF15A850001085C0755385DB7E468BC3C1E004C745F420000000895DFC8B5DF48945188B450C03C350FF15805000108B451C8B008B4D188D4408F0508B450C03C350FF15BC500010836D181083C310FF4DFC75CFFF75F8FF15A45000108B5E608B45F8C7466001000000E9470200008BCFE835F7FFFF480F8479010000480F85920200008BCFE831F7FFFF83F8027509395E080F847D0200008B751C8B460883F8010F85860000008BCFE8F8F6FFFF8BF8B80C2000006639070F8512010000FF7708FF15A050001083F8010F85000100008B066A035B663B18740B536A005050FF15AC5000108B0683C0088338FF75238B752056FF158450001066891E83C608566A01FF7708FF1594500010FF06E9CDFBFFFFFF752050FF7708FF1590500010F7D81BC02509000280E9ED01000083F8020F859A0000008BCFE869F6FFFFB90C20000089451C6639080F8582000000FF7008FF15A050001083F80275748B068B3DAC5000106A035B663B187407536A005050FFD78B0683C010663B187407536A005050FFD78B368B46088945F08B76188975F483FEFF75278B752056FF158450001033C066891E83C608837DF002560F95C040508B451CFF7008E947FFFFFFFF75208D45F0508B451CFF7008E949FFFFFF395E08740AB80E000280E93B010000395D200F84F7FAFFFF8B4D08E8B6F5FFFFE962FBFFFF8BCFE8BFF5FFFF85C07409395E080F840C010000FF46088BCFE890F5FFFF8B3D845000108946248D462850FFD78D464850FFD78B451C8B58088365EC008D43028945E88D45E8506A016A0CFF15985000108D4D0C51508945FCFF15A850001085C0755385DB7E468BC3C1E004C745F420000000895DF88B5DF48945188B450C03C350FF15805000108B451C8B008B4D188D4408F0508B450C03C350FF15BC500010836D181083C310FF4DF875CFFF75FCFF15A45000108B5E608B45FC836660008B4D08894630B80C2000006A0366894628585666894658E8D5F4FFFFFF7008FF15D8600010837D2000895E6089451C740D8D464850FF7520FF15BC5000108D462850FFD78D464850FFD7FF4E088B451CF7D81BC025FDFFFD7F0503000280EB05B8030002805F5E5BC9C22400558BEC56578BF133FF397E1076208B460CFF"
		$sBinaryDll &= "75088B0CB8E866F4FFFF50E874260000595985C0740F473B7E1072E083C8FF5F5E5DC204008BC7EBF6558BEC5356FF75088BF1E8B6FFFFFF8BD883FBFF7E238B460C578B3C9885FF740E8BCFE803F4FFFF57E859F3FFFF59538D4E0CE875F7FFFF5F5E5B5DC20400558BEC56578BF98B4D08E8F9F3FFFF508BCFE86FFFFFFF8BF083FEFF74338B4D08E8E2F3FFFF6683387E74258B470C538B1CB085DB740E8BCBE8AEF3FFFF53E804F3FFFF598B470C8B4D08890CB05BEB0BFF75088D4F0CE8110D00005F5E5DC204005333DB568BF1578B3D80500010C7062C520010895E04895E08895E0C895E10895E148D462850895E18895E1C895E20895E24FFD78D463850FFD78D464850FFD78D465850FFD76A20E882F2FFFF593BC3740B8BC8E819F3FFFF8BF8EB0233FF538BCFE84AF3FFFF6A028BCFE852F3FFFF68585100108BCFE896F3FFFF578BCEE81AFFFFFF5F8BC65E5BC3558BEC51515333DB568BF1578B3D80500010C7062C520010895E04895E08895E0C895E10895E148D462850895E18895E1C895E20895E24FFD78D463850FFD78D464850FFD78D465850FFD78B7D08895DFC395F10767D6A20E8E8F1FFFF593BC3740C8BC8E87FF2FFFF894508EB03895D088B470C8B4DFC8B0C88894DF8E8A1F2FFFF8B4D0850E89CF2FFFF8B4DF8E88CF2FFFF8B4D0850E8D8F2FFFF8B4DF8E890F2FFFF8B4D0850E88BF2FFFF8B4DF8E867F2FFFF8B4D0850E8CAF2FFFFFF75088BCEE84CFEFFFFFF45FC8B45FC3B471072838B47183BC3740EFF77208BCEFF771C50E8D2F4FFFF5F8BC65E5BC9C20400558BEC5151568B7508FF4E048B46040F8596000000833DD860001000747DFF46088365FC00578B7E10404FC745F802000000894604744E538B460C8B0CB8E8E8F1FFFF6683387E75388D5E2853FF15845000108D45F8506A016A0CFF1598500010894630B80C2000006689038B460C8B0CB856E8B6F1FFFFFF7008FF15D86000104F75B45B8B3D845000108D464850FFD78D462850FFD7FF4E085F8BCEE80BF5FFFF56E8C3F0FFFF5933C05EC9C20400558BEC568B7510FF366870510010E87C230000595985C075108B451CC700FCFFFFFF33C05E5DC21800FF366884510010E85A230000595985C0750B8B451CC7007CFCFFFFEBDCFF36689C510010E83D230000595985C0750B8B451CC7007BFCFFFFEBBFFF3668B4510010E820230000595985C0750B8B451CC7007AFCFFFFEBA2FF3668C8510010E803230000595985C0750B8B451CC70079FCFFFFEB85FF3668E0510010E8E6220000595985C0750E8B451CC70078FCFFFFE965FFFFFFFF3668FC510010E8C6220000595985C0750E8B451CC70077FCFFFFE945FFFFFFFF368B4D08E812FCFFFF8B4D1C890183F8FF0F852DFFFFFFB806000280E925FFFFFF558BEC56576A208BF9E897EFFFFF5985C0740B8BC8E82EF0FFFF8BF0EB0233F66A018BCEE85E"
		$sBinaryDll &= "F0FFFFFF75108BCEE865F0FFFFFF75088BCEE8ABF0FFFFFF750C8BCEE85EF0FFFF568BCFE825FCFFFF5F5E5DC20C00558BEC56576A208BF9E842EFFFFF5985C0740B8BC8E8D9EFFFFF8BF0EB0233F66A028BCEE809F0FFFF837D1000740AFF75108BCEE846F0FFFFFF750C8BCEE800F0FFFFFF75088BCEE846F0FFFF568BCFE8CAFBFFFF5F5E5DC20C0083790C00C701FC52001075098B41048B0850FF5108C3558BEC8B4D088B4108408941085DC20400B802400080C20C00B801400080C21000558BEC568B7510FF366848520010E896210000595985C0750E8B451CC7009CFFFFFFE9AF000000FF366858520010E876210000595985C0750E8B451CC7009BFFFFFFE98F000000FF366868520010E856210000595985C0750B8B451CC7009AFFFFFFEB72FF36687C520010E839210000595985C0750B8B451CC70099FFFFFFEB55FF366894520010E81C210000595985C0750B8B451CC70098FFFFFFEB38FF3668B0520010E8FF200000595985C0750B8B451CC70097FFFFFFEB1BFF3668C0520010E8E2200000595985C0750D8B451CC70096FFFFFF33C0EB05B8060002805E5DC21800558BEC8B4D0C83F99C7510F64518027510B809000280E944020000F6451801EBEE53568B75088B460C33DB3BC3740F83F99B740AB810000280E91F0200005783F99C752E8B451C3958080F85C90100008B7D2057FF15845000106A09586689078B4604894708C7460C01000000E9E101000083F99B75418B4D1C3959080F85960100003BC375098B46048B0850FF51086A68E843EDFFFF593BC374098BC8E868FAFFFFEB0233C08946048B0850FF5104895E0CE99B01000083F99A75618B7D1C8B770883FE02740983FE030F85480100008B078BCE03C933D266837CC8F0088D4EFE0F95C203C933DB66833CC8080F95C30BD30F852F01000033C983FE0375096639480874036A02598BD65103D2FF74D0E8FF74D0F88B45088B4804EB7D83F999754E8B451C8B48083BCB0F84E800000083F9030F87DF0000008B108BC103C066837CC2F0080F85DC00000083F90176048B5CC2E833FF83F90375028BFA8B4E045753FF74C2F8E81EFDFFFFE9E200000083F998752F8B451C837808010F85960000008B00668338080F85990000008B4E0453FF700868DC520010E895FCFFFFE9AE00000083F99775618B7D1C8B770883FE02740583FE03755F8B078BCE03C933D266837CC8F0088D4EFE0F95C203C933DB66833CC8080F95C30BD3754AB9E052001083FE03750966833808753A8B4808518BD603D2FF74D0E8FF74D0F88B45088B4804E846EFFFFFEB4883F99675478B451C837808017407B80E000280EB3C8B00668338087407B808000280EB2D8B78085768E4520010E8881E0000595985C07507B805000280EB128B4E0457E817F8FFFF33C0EB05B8030002805F5E5B5DC22400558BEC568B7508FF4E088B460875108BCEE8"
		$sBinaryDll &= "6CFCFFFF56E872EBFFFF5933C05E5DC20400568BF18366080083660C006A68C706FC520010E83BEBFFFF5985C074098BC8E860F8FFFFEB0233C08946048B0850FF51048BC65EC38BC1834810FF33C9890889480489480889480CC3568BF18B460485C0740750E811EBFFFF59833E007412FF760CE803EBFFFFFF7608E8FBEAFFFF59595EC38B4104C3558BEC568BF18B460485C0740750E8E0EAFFFF59FF7508FF150450001033C96A02405AF7E20F90C1F7D90BC851E8AAEAFFFF59FF750889460450FF15005000105E5DC204008B4108C3558BEC5356578BF133FF393E7412FF760CE894EAFFFFFF7608E88CEAFFFF59598B5D0833C966390B0F84B10000008BC36683383B750F6683780200740347EB0533D2668910418D044B6683380075E185C974014785FF0F84830000008D410133C96A025AF7E20F90C1893EF7D90BC851E81EEAFFFF59535089460CFF150050001033C96A045A8BC7F7E20F90C1F7D90BC851E8FCE9FFFF598B4E0C89460889088B4E0C33C033FF66390174366A045A8B4E0C66833C013B751633DB66891C018B4E0C8D4401028B4E0889040A83C2048B4E0C478D043F66833C080075D2EB038326005F5E5B5DC204008B4110C3558BEC8B45088941105DC20400558BEC8B4D088B4104408941045DC20400558BEC568B750C576A0459BF2056001033C0F3A775248B750839463074158B46188B0850FF51048B46188B4D10890133C0EB54B801400080EB4D8B750C6A0459BF1056001033C0F3A7751E8B750839463074098B46188B0850FF51048B0656FF50048B45108930EBC68B4508837830007410FF75108B4018FF750C8B0850FF11EB05B8024000805F5E5DC20C00558BEC8B451485C0740383200033C05DC21000558BEC8B45088941345DC20400558BEC81EC000400005633C0505068000400008BF18D8D00FCFFFF516AFFFF76405050FF150C5000108D8500FCFFFF50FF7634FF15085000105EC9C3558BEC5356578B7D0857FF15045000108D7447FE66833E2A753A33C0576A08668906E8821B000059598B4D146689016A2A58668906B8FFFF0000663901742E8B450C33DB4389188B4510C700040000008BC3EB1B33C966390F74128BC76683383A7413418D044F6683380075F033C05F5E5B5DC210008D344F8D4602686053001050E8031B000033DB59435985C075058B4510891833C066837EFE2A576A087529668946FEE8FF1A000059598B4D146689016A2A58668946FEB8FFFF000066390174AA8B450C8918EB86668906E8D71A000059598B4D146689016A3A58668906B8FFFF000033D26639010F95C28BC2E97BFFFFFF558BEC5633F6578B7D0C3975087E0FFF34B7E8ABE7FFFF46593B75087CF157E89EE7FFFFFF7510E896E7FFFFFF7514E88EE7FFFFFF7518E886E7FFFFFF751CE87EE7FFFF83C4145F5E5DC21800558BEC51518D45F8506A00FF7508FF15E85000"
		$sBinaryDll &= "108B45F88B55FCC9C20400558BEC518D45FC5068000000806A00FF7508FF15B450001085C07509663945FC0F95C0EB11FF7508FF15B050001033C93BC81BC0F7D8F7D8C9C20400558BEC51DD45088D45FF505151DD1C24FF15B850001085C075058A45FFEB08DD4508E80BE7FFFFC9C20800558BEC51DD45088D45FC505151DD1C24FF156050001085C07506668B45FCEB08DD4508E8DFE6FFFFC9C20800558BEC51DD45088D45FC505151DD1C24FF15C050001085C07506668B45FCEB08DD4508E8B3E6FFFFC9C20800558BEC51DD45088D45FC505151DD1C24FF15C450001085C075058B45FCEB08DD4508E888E6FFFFC9C20800558BEC51DD45088D45FC505151DD1C24FF15C850001085C07505D945FCEB09DD4508D95D0CD9450CC9C20800558BEC51DD45088D45FC505151DD1C24FF15CC50001085C075058B45FCEB08DD4508E831E6FFFFC9C20800558BEC8B4D0833D2663911742A8BC157837D0C00740A6683382C75106A2EEB086683382E75066A2C5F668938428D04516683380075DA5F5DC20800558BEC568BF18B46048D48013B4E0876465733C96A048D4400025AF7E20F90C1F7D90BC851E89AE5FFFF8BF833C059394604760E8B0E8B0C81890C87403B460472F2FF36E892E5FFFF8B4604598D4C0002893E894E085F8B0E8B5508891481FF46045E5DC20400558BEC5133C038451053568BF1894604894608C7066C53001089460C8946108946148946340F94C0578946308D462050FF15805000108B45088B5D0C836508008946180FB64514836514008946380FB645185389463C895D0CFF150450001033D28945FC8955188D04530FB70883F97C750E33C96689088D445302894508EB6483F90A74056685C9755A33C96A14668908E8C7E4FFFF5985C0740C8BC8E89DF9FFFF894510EB0483651000FF750C8B4D10E8CBF9FFFFFF75088B4D10E809FAFFFFFF75148B4D10E8EBFAFFFFFF75108D4E0CE8C2FEFFFF8B4518FF45148D44430289450C8B5518428955183B55FC0F8673FFFFFF5F8BC65E5BC9C2140056578BF133FFC7066C530010397E107620538B460C8B1CB885DB740E8BCBE833F9FFFF53E84EE4FFFF59473B7E1072E25B8D4E0CE84DE8FFFF8D462050FF1584500010837E300074098B46188B0850FF51088B463485C0740750FF1510500010837E38007409FF7618FF1514510010FF760CE800E4FFFF595F5EC3558BEC56578BF98B7710EB1A8B470CFF75088B0CB0E8EBF8FFFF50E8B0160000595985C0740F4E83FEFF7FE083C8FF5F5E5DC204008BC6EBF6558BEC578BF98B4D08E8BEF8FFFF508BCFE8B1FFFFFF83F8FF750DFF75088D4F0CE8C2FDFFFFEB2753568BF08B470C8B1CB085DB740E8BCBE865F8FFFF53E880E3FFFF598B470C8B4D08890CB05E5B5F5DC20400558BEC51566A00FF75088BF1E848FDFFFF8D45FF5068000000806A00FF7508FF15D050001085C0"
		$sBinaryDll &= "75058A45FFEB0AFF75088BCEE8C2FBFFFF5EC9C20400558BEC51566A00FF75088BF1E80BFDFFFF8D45FC5068000000806A00FF7508FF15D450001085C07506668B45FCEB0AFF75088BCEE884FBFFFF5EC9C20400558BEC51566A00FF75088BF1E8CDFCFFFF8D45FC5068000000806A00FF7508FF15D850001085C07506668B45FCEB0AFF75088BCEE846FBFFFF5EC9C20400558BEC51566A00FF75088BF1E88FFCFFFF8D45FC5068000000806A00FF7508FF15DC50001085C075058B45FCEB0AFF75088BCEE809FBFFFF5EC9C20400558BEC51566A00FF75088BF1E852FCFFFF8D45FC5068000000806A00FF7508FF15E050001085C075058B45FCEB0AFF75088BCEE8CCFAFFFF5EC9C20400558BEC5151566A00FF75088BF1E814FCFFFF8D45FC5068000000806A00FF7508FF158C50001085C07505D945FCEB13FF75088BCEE88EFAFFFF8945F88955FCDF6DF85EC9C20400558BEC5151566A00FF75088BF1E8CDFBFFFF8D45F85068000000806A00FF7508FF157C50001085C07505DD45F8EB13FF75088BCEE847FAFFFF8945F88955FCDF6DF85EC9C20400558BEC33C05333DB385D0C568BF10F94C0C7066C530010895E04895E08895E0C895E10895E148946308B45088946180FB6451057895E3889463C3BC374206A14E852E1FFFF593BC374098BC8E828F6FFFFEB0233C0508D4E0CE875FBFFFF8D462050FF15805000105F8BC65E5B5DC20C00558BEC568B7508FF4E048B460475108BCEE8B0FCFFFF56E821E1FFFF5933C05E5DC20400558BEC56578B7D10FF376818530010E8D9130000595985C075118B451CC700DCFCFFFF33C05F5E5DC218008B7508837E3C0074138B078946408B460C8B08E8DFF5FFFF85C074DCFF378BCEE8CDFCFFFF8B4D1C890183F8FF75C9B806000280EBC4558BEC8B55188B4D0C83EC4C83E201567506F6451802742881F9DCFCFFFF75208B752056FF15845000106A13586689068B45088B401889460833C0E9741000008B45085333DB39583C75093BCB7C103B48107D0B663BD37510F6451802750AB803000280E94A1000008B500C8B148A8B4D1C8B4908030A8955D88BD181E201000080894DD079054A83CAFE42750AB80E000280E91B100000FF40088D41FF992BC28BF057D1FE33C96A025A8BC6F7E20F90C18975DCF7D90BC851E8E2DFFFFF8945F433C96A045A8BC6F7E20F90C1F7D90BC851E8C9DFFFFF89450C33C96A045A8BC6F7E20F90C1F7D90BC851E8B0DFFFFF8945F833C96A105A8BC6F7E20F90C1F7D90BC851E897DFFFFF8945FC33C96A105A8BC6F7E20F90C1F7D90BC851E87EDFFFFF8B75D08945E48D46FE33FF83C414897DD48945E083F8FF0F8E030900008B45E0250100008079054883C8FE400F84E10800008B4DD8393975628B75E08B7D1C8B0703F666833CF0080F85F1080000FF74F008FF15B05000108945F08B078B44F0088945EC8B45FC"
		$sBinaryDll &= "8BF3C1E6048D3C0657FF15805000100375E456FF15805000108B45D88338008B4D1C8B45E0743048992BC2D1F8C1E0040301EB2BE847F4FFFF8BC88BC62B45E0992BC2D1F88B0481508945ECFF15045000108945F0EBA68B0903C08D44C1F05056FF15BC5000108B4DF08B45ECFF75EC8D4448FE6683382A8945F00F85170400008B4DF033C06A08668901E8911100008B55F059596A2A590FB7C0506A0057578945EC66890AFF15AC5000108B45EC8B4DF40D00400000668904590FB70633C983F8080F94C166837DEC00894DF00F84040800008B4DEC6683F91175376A01E833DEFFFF837DF000598945EC740DFF76088B4D08E8C6FAFFFFEB0F6A116A005656FF15AC5000108A46088B4DEC8801E96D0300006683F90B75366A04E8F6DDFFFF837DF000598945EC7410FF76088B4D08E8A1F6FFFFE9D70000006A0B6A005656FF15AC5000100FBF4608E9C20000006683F90275226A02E8BADDFFFF837DF000598945EC740DFF76088B4D08E8C8FAFFFFEB386A02EB266683F91275396A02E892DDFFFF837DF000598945EC740DFF76088B4D08E862FAFFFFEB106A126A005656FF15AC500010668B46088B4DEC668901E9CA0200006683F91375226A04E853DDFFFF837DF000598945EC740DFF76088B4D08E89FFAFFFFEB376A13EB266683F90375376A04E82BDDFFFF837DF000598945EC740DFF76088B4D08E8B4FAFFFFEB0F6A036A005656FF15AC5000108B46088B4DEC8901E9650200006683F90C75226A10E8EEDCFFFF59508945ECFF1580500010568B75EC56FF15BC500010E9390300006683F9140F84A40100006683F9150F84B60100006683F90475376A04E8B2DCFFFF837DF000598945EC740DFF76088B4D08E878FAFFFFEB0F6A046A005656FF15AC500010D946088B45ECD918E9EC0100006683F90575376A08E875DCFFFF837DF000598945EC740DFF76088B4D08E882FAFFFFEB0F6A056A005656FF15AC500010DD46088B45ECDD18E9AF0100006683F91E756083F80875088B46088945ECEB2A6A086A005656FF15AC50001085C075138B76088B4D086A01568975ECE812F6FFFFEB07C745EC285300106800000100E8FEDBFFFF598BF033C050506800000100566AFFFF75EC5050FF150C500010E9450200006683F91F755383F80875088B46088945ECEB2A6A086A005656FF15AC50001085C075138B76088B4D086A01568975ECE8ACF5FFFFEB07C745EC2C5300106800000200E898DBFFFF59FF75EC8BF056FF1500500010E9EC0100006683F908754A83F80875058B7608EB256A086A005656FF15AC50001085C075108B76088B4D086A0156E859F5FFFFEB05BE3053001056FF15885000108945CC8D45CC8947088B450C893C98E9BE0400006683F91A0F84BB04000066837DEC2575156A08E81EDBFFFF837DF000598945EC751C6A14EB2F66837DEC2675426A08E802DBFFFF837DF00089"
		$sBinaryDll &= "45EC597415FF76088B4D08E88FF3FFFF8B4DEC8901895104EB4D6A156A005656FF15AC5000108B4E088B45EC89088B4E0C894804EB3166837DEC090F857D0400006A04E8B5DAFFFF66833E09598945EC75158B46088B4DEC89018B760885F674068B0656FF50048B45EC8B4D0C894708893C998B4DF8890499E90E0400006834530010E8600D0000595985C0756366833E0875088B46088945ECEB2A6A086A005656FF15AC50001085C075138B76088B4D086A01568975ECE841F4FFFFEB07C745EC3C5300106800000100E82DDAFFFF598BF033C050506800000100566AFFFF75EC5050FF150C5000106A08586A1EEB67FF75EC6840530010E8EA0C0000595985C0757366833E0875088B46088945ECEB2A6A086A005656FF15AC50001085C075138B76088B4D086A01568975ECE8CBF3FFFFEB07C745EC4C5300106800000200E8B7D9FFFF59FF75EC8BF056FF15005000106A08586A1F8B4DF466890459586689078B450C897708893C988B45F8893498E915030000FF75EC6850530010E8640C0000595985C0754566833E0875058B7608EB256A086A005656FF15AC50001085C075108B76088B4D086A0156E84BF3FFFFEB05BE5C5300108B4DF46A085866890459668907897708E9EDFDFFFF8B45D88338008B45F4FF75EC8D3C5874046A08EB0F8B45E08B4D1C8B0903C00FB704C150E80F0C0000596689070FB7C059B9FFFF0000663BC10F84D70200006685C00F84F802000066833E080F85CB0000008B4E08894DEC83F80B752956FF15845000100FB707506A005656FF15AC500010FF75EC8B4D08E871F1FFFF66894608E92A02000083F811752856FF15845000100FB707506A005656FF15AC500010FF75EC8B4D08E82BF5FFFF884608E9FD01000083F805751E506A005656FF15AC500010FF75EC8B4D08E882F6FFFFDD5E08E9DA01000083F804751E506A005656FF15AC500010FF75EC8B4D08E818F6FFFFD95E08E9B701000083F80C0F84AE010000506A005656FF15AC500010FF75EC8B4D08E8B8F0FFFFE97701000083F80C0F848A010000506A005656FF15AC50001085C00F84770100000FB7065683F803757E8B46088945ECFF15845000100FB707506A005656FF15AC5000100FB70783F81175088A45ECE93FFFFFFF83F812740583F8027509668B45ECE9FEFEFFFF83F813750B8B45EC894608E92101000083F8047508DB45ECE955FFFFFF83F8057508DB45ECE925FFFFFF83F815740983F8140F85F90000008B45EC99E9D400000083F8050F85D3000000DD4608DD5DE8FF15845000100FB707506A005656FF15AC5000100FB70783F8117515DD45E851518B4D08DD1C24E82FF0FFFFE9ABFEFFFF83F8127515DD45E851518B4D08DD1C24E840F0FFFFE963FEFFFF83F8027515DD45E851518B4D08DD1C24E852F0FFFFE949FEFFFF83F8137515DD45E851518B4D08DD1C24E864F0FFFFE939"
		$sBinaryDll &= "FFFFFF83F8047515DD45E851518B4D08DD1C24E875F0FFFFE989FEFFFF83F8037515DD45E851518B4D08DD1C24E887F0FFFFE905FFFFFF83F815740583F8147524DD45E8E8C8D6FFFF89460889560CEB14FF15845000100FB707506A005656FF15AC5000108B450C8934988B45F8832498008B75D04333FFFF4DE0837DE0FF0F8FFDF6FFFF8B45D8897DD0C745E004000000393874668BC8E8AFEBFFFF8B18536A08EB6AFF750C8B7508FF75F48BCEFF75E4FF75FCFF75F853E87AEEFFFFFF4E08B827800280E929060000BE27800280FF750C8B4D08FF75F4FF75E4FF75FCFF75F853E850EEFFFF8B4508FF48088BC6E9FF050000BE04000280EBD48B451C8B0003F68B5CF0F80FB744F0F05350E8DA0800008B75080FB7C089451CB8FFFF000059596639451C75448D451C508D45E0508D45D050538BCEE807EDFFFF85C075208BCEFF750CFF75F4FF75E4FF75FCFF75F8FF75DCE8DEEDFFFFBE27800280EB87397DD07407C7451C1540000066837D1C1E740766837D1C1F750E0FB7451C8945D4C7451C150000008D45B450FF1580500010397E3C74308BCE33DBE867ECFFFF3BC77531FF750C8BCEFF75F4FF75E4FF75FCFF75F8FF75DCE87AEDFFFFBE2F800280E920FFFFFF8B4DD88B5E18E866EBFFFFC1E0028B7DDC8D4DB451FF750CFF75F457FF751CFF75E05053FF15785000108365C8008D45C4506A01476A0C897DC4FF15985000108D4D1851508945F0FF15A850001085C00F85960400008B3D1450001033DB895DE0395DDC0F8EAA03000033F68B45188D44061050FF15805000108B45F48B4DE00FB70448A9004000000F84CC02000035004000000FB7C88B4518518D440610535050894DECFF15AC5000108B45EC663BC30F848102000033C96683F8110F94C133D26683F8100F94C20BCA74158B4DFC8B4C0E088A098B5518884C1618E9560200006683F80B751D8B45FC8B44060833C938080F95C18BC18B4D186689440E18E9390200006683F802750C8B45FC8B440608668B00EBE16683F81274EE6683F81375158B45FC8B4406088B008B4D1889440E18E9060200006683F80374E56683F80C0F85E30000008B45FC8B4C06088B4518894DD80FB709518D440610535050FF15AC5000108B45D80FB70083F81E75638B4D186A08586689440E108B45D88B400853536AFF5053538945D8FFD733C96A025A8945CCF7E20F90C1F7D90BC851E876D3FFFF59FF75CC8945D0506AFFFF75D85353FFD7FF75D0FF15885000108B4D18FF75D089440E18E864D3FFFF59E96A01000083F81F751C8B4D186A08586689440E108B45D8FF7008FF1588500010E937FFFFFFA90020000074138B4D186689440E108B45D88B4008E91DFFFFFF8B45D88B48088B5518894C16188B400C8B4D1889440E1CE9130100006683F81475158B45FC8B4406088B088B5518894C16188B4004EBD96683F81574E56683F8047515"
		$sBinaryDll &= "8B45FC8B440608D9008B4518D95C0618E9D70000006683F80575158B45FC8B440608DD008B4518DD5C0618E9BC0000006683F81E751E8B45186A088D440610535050FF15AC5000108B45FC8B440608E9DCFEFFFF6683F81F751E8B45186A088D440610535050FF15AC5000108B45FCFF740608E920FFFFFF6683F80875128B45FC8B4406088B008B4D1889440E18EB686683F81A0F8445FFFFFF6683F82575176A038B45188D440610535050FF15AC500010E928FFFFFF6683F82675046A13EBE16683F8090F85270100008B55186A095966894C16108B4DFC8B4C0E088B098B5518894C16186683F808740C8B45FC03C650FF15845000108B45E403C650FF1584500010E9A40000008B45FC8D4406080FB748F883F91E755C8B55186A085953536AFF66894C16108B005053538945D8FFD733C96A025A8945CCF7E20F90C1F7D90BC851E880D1FFFF59FF75CC8945D0506AFFFF75D85353FFD7FF75D0FF15885000108B4D18FF75D089440E18E86ED1FFFF59EB3883F91F751C8B55186A085966894C1610FF30FF15885000108B4D1889440E18EB178B450C8B4DE0FF34888B45188D44061050FF15BC500010FF45E08B45E083C6103B45DC0F8C5BFCFFFF8B7508FF7518FF1580500010F7451C0040000074268B4D186A15586689018B45BC8B4D18998941088B451889500CE9950000008B4D08E92FFBFFFF66837DD41E75588B4D186A085853536AFF6689018B45BC5053538945CCFFD733C96A025A89451CF7E20F90C1F7D90BC851E899D0FFFF59FF751C8BF0566AFFFF75CC5353FFD756FF15885000108B4D1856894108E88DD0FFFF8B750859EB2E66837DD41F751A8B4D186A0858668901FF75BCFF15885000108B4D18894108EB0D8D45B450FF7518FF15BC5000108D45B450FF1584500010FF75F0FF15A45000108B45F08D7E2057FF7520894628B80C200000668907FF15BC500010FF4E0857FF1584500010FF750C8BCEFF75F4FF75E4FF75FCFF75F8FF75DCE846E8FFFF33C05F5B5EC9C2240033C040C20C006A10E8DBCFFFFF5985C074078BC8E97CE4FFFF33C0C36A68E8C5CFFFFF5985C074078BC8E9EADCFFFF33C0C3558BEC6A68E8ACCFFFFF5985C074088BC85DE95ADDFFFF33C05DC20400558BECFF7508E89FD2FFFFFF750CE80CD1FFFF59595DC20800558BECFF75148B4D08FF7510FF750CE8C7DFFFFF5DC21000558BECFF750C8B4D08E8EADBFFFF5DC20800558BECFF75148B4D08FF7510FF750CE8B7D2FFFF5DC21000558BECFF75148B4D08FF7510FF750CE8DADFFFFF5DC21000558BEC6A48E81CCFFFFF5985C074116A00FF750C8BC8FF7508E871EDFFFFEB0233C05DC20800558BEC6A48E8F6CEFFFF5985C074176A00FF75148BC8FF7510FF750CFF7508E87FE9FFFFEB0233C05DC21000558BEC566A14E8C9CEFFFF5985C0740B8BC8E89FE3FFFF8BF0EB0233F6FF750C8BCEE8D1E3"
		$sBinaryDll &= "FFFFFF75148BCEE8FDE4FFFFFF75108BCEE806E4FFFF8B4D0856E8E4EAFFFF5E5DC21000558BEC5657FF751033F656FF7508FF15185000108BF83BFE750433C0EB3F6A48E866CEFFFF5939750C75123BC674246A016A01568BC8E8B9ECFFFFEB143BC674126A01566A01FF750C8BC856E8DDE8FFFF8BF0578BCEE848E5FFFF8BC65F5E5DC20C00558BEC83EC0C8D45FC506A00FF150C51001085C0740433C0EB518D45F850FF750CFF151051001085C08B45FC74088B0850FF5108EBE08365F4008B08568D55F452FF75F8FF75086A0150FF510C8BF08B45F88B0850FF51088B45FC8B0850FF5108F7DE1BC0F7D02345F45EC9C20800558BEC518D45FC506A00FF150C51001085C0740432C0EB1E8B45FC8B0856FF750850FF51108BF08B45FC8B0850FF510885F60F94C05EC9C20400558BEC817D08ADDE00007530817D0CEFBE00007527566AF5FF15245000106A008BF08D4508506A22680854001056FF152050001056FF151C5000105E5DC20800558BEC8B45088B0850FF51045DC20400558BEC8B45088B0850FF51085DC20400558BEC8B45085DC20400558BEC6AFFFF750C6AFFFF75086A016800080000FF152850001083E8025DC3558BEC66837D080874056A0A585DC35633F63935D0600010761EFF750CFF34B548600010E8B8FFFFFF595985C07411463B35D060001072E2B8FFFF00005E5DC3668B047500600010EBF3558BEC568B75088B068D4D0851685056001056FF1085C0750D8B45088B08508BF0FF5120EB1F8B068D4D0851684056001056FF1085C075138B45088B086A00508BF0FF51148B0656FF50085E5DC3558BEC83EC305333DB56395D0C751057BE105600108D7DE0A5A5A5A55FEB158D45E050FF750CFF15F450001085C00F85830000008B75088D45D05056FF150451001085C00F84DA0000008D45D05056FF15F850001085C00F84C700000056FF150450001083F8040F8EB70000006A0468885300106A04566A016800080000FF152850001083F8020F85970000008D45085053FF150C51001085C0751B8D45FC5083C60856FF151051001085C08B4508740E8B0850FF510833C05E5BC9C20C008D55F852FF75FC895DF88B0850FF51188BF08B45FC8B0850FF51088B45088B0850FF51083BF375D08B45F88B088D55F0528D55E05250FF1185C075BC8B75F0395D10755E395D0C75048BC6EBAD6A48E84BCBFFFF593BC3749F5353568BC8E8A5E9FFFFEB9553FF15FC50001083F8017506FF15005100108D45F4508D45E0506A01538D45D050FF151851001085C00F8564FFFFFFFF75F4E857FEFFFF8B75F459EB9D6A48E8F6CAFFFF593BC30F8446FFFFFF535353FF75108BC856E882E5FFFFE935FFFFFF558BEC83EC3C53565733DB5353FF1508510010395D100F85DC000000BE105600108D7DD4A5A5A5A58B750C8D45C45056FF150451001085C00F84AC01000056FF1504500010"
		$sBinaryDll &= "83F8040F8EBF0000006A0468945300106A04566A016800080000FF152850001083F8020F859F000000FF7514FF751056E802FEFFFF8945F03BC30F85FD020000BE0000010056E84ACAFFFF568BF8E842CAFFFF6A44894518E838CAFFFF8BF06A108975ECE82CCAFFFF83C4108945E88D45E450FF7508C70604000000FF154C5000108B354850001085C0754368FF7F0000FF751853FF154450001068A053001057FFD6FF750857FFD668D453001057FFD6EB288D45D450FF7510FF15F450001085C00F841BFFFFFF33C0E96E020000FF7508FF7518FF150050001068D853001057FFD68B75E856FF75EC53535353535357FF7518FF154050001057894508E8A9C9FFFFFF7518E8A1C9FFFF5959395D08747E8B451C3BC37505B8B80B00006A0A33D259F7F1895D08895D1889451C3BC3764CBF030100008D450850FF36FF153C500010397D087536FF7514FF7510FF750CE8E1FCFFFF8945F03BC375216A0AFF1538500010FF45188B45183B451C72C7397D08750953FF36FF1534500010FF368B3D30500010FFD7FF7604FFD78B5DF0FF75ECE814C9FFFF56E80EC9FFFF5959E996010000385D18750D6A01FF7508FF15F0500010EB09FF7508FF152C5000108BF83BFB0F84FEFEFFFF68F453001057FF15085000103BC3750C57FF1510500010E9E2FEFFFF8D4DF45168305600108D4DC451FFD085C075E133F6385D1875428D45FC506A02FF7508FF156450001085C0752F53FF7508FF75FCFF156850001085C075056A025EEB1953FF7508FF75FCFF156C5000108BF0F7DE1BF683E6FE83C6038B45F48B088D55F8528D55D4525350FF510C85C074753BF374638B45FC8B088D55185250FF511C85C075494E4E74054E741CEB348B4518FF70140FB7481AFF7010510FB748185150FF15705000108B4518FF70140FB7481AFF7010510FB748185150FF15745000108B45FCFF75188B0850FF51308B45FC8B0850FF51088B45F48B0850FF5108E90DFFFFFF3BF374098B45FC8B0850FF51088B45F48B0850FF5108FF75F8E8FEFAFFFF59395D147524385D1875058B45F8EB426A48E893C7FFFF593BC3742C5353FF75F88BC8E8EBE5FFFFEB1C6A48E879C7FFFF593BC37412535353FF75148BC8FF75F8E807E2FFFF8BD8578BCBE872DEFFFF8BC35F5E5BC9C2180000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
		$sBinaryDll &= "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000E4570000F0570000FC5700000E5800002458000032580000485800005A5800006E5800007A5800008A5800009C580000AC580000BA580000CE580000D6580000EC580000FE5800001459000020590000505A0000445A00005C5A00000000000005010080B7000080A3000080BA010080BA000080BB01008092000080540000800800008009000080020000804A00008019000080130000800F0000801A0000801100008018000080170000800C000080070000807D000080850000800A0000803300008012010080470000803D000080880000800801008036000080150100804000008000000000285A000000000000E6590000D6590000B2590000A259000090590000C4590000F65900006459000050590000405900007C5900000000000000000000998BD54D00000000020000007E000000C45C0000C44A0000B511001067260010AE120010331200106012001083120010A61200105F005F00640065006600610075006C0074005F005F0000005F004E006500770045006E0075006D00000000005F005F006200720069006400670065005F005F00000000005F005F0070006100720061006D0073005F005F00000000005F005F006500720072006F0072005F005F0000005F005F0072006500730075006C0074005F005F00000000005F005F00700072006F007000630061006C006C005F005F00000000005F005F006E0061006D0065005F005F0000000000430061006C006C0041007200670041007200720061007900000000001E13001067260010AC1E001062130010052700105C1F0010E11400104F0062006A0065006300740000000000430072006500610074006500000000004100640064004D006500740068006F0064000000410064006400500072006F00700065007200740079000000410064006400440065007300740072007500630074006F007200000041006400640045006E0075006D000000520065006D006F00760065004D0065006D00620065007200000000007E000000000000005F005F00640065006600610075006C0074005F005F000000322100102121001089240010A61200103A21001042210010262200105F005F007000740072005F005F000000000000000000000000000000730074007200000000000000770073007400720000000000000000006200730074007200000000000000000063006400650063006C0000007826001067260010DA2E00106213001005270010FE2E00105F2F00106300620069003A00000000006300620069003A00000000"
		$sBinaryDll &= "0020002F004100750074006F00490074003300450078006500630075007400650053006300720069007000740020002200000000002200000020002F00530074006100720074005300650072007600650072000000446C6C476574436C6173734F626A6563740000004C6F6C2E20596F7520666F756E6420746865206561737465722D6567672E200D0A0000006F0062006A00650063007400000000006900640069007300700061007400630068000000770070006100720061006D0000000000640077006F00720064005F00700074007200000075006C006F006E0067005F007000740072000000750069006E0074005F00700074007200000000006C0070006100720061006D00000000006C0072006500730075006C00740000006C006F006E0067005F007000740072000000000069006E0074005F007000740072000000680077006E00640000000000680061006E0064006C0065000000000070007400720000006200730074007200000000007700730074007200000000007300740072000000680072006500730075006C007400000064006F00750062006C0065000000000066006C006F00610074000000750069006E007400360034000000000069006E007400360034000000760061007200690061006E007400000069006E00740000006C006F006E00670000000000750069006E0074000000000075006C006F006E0067000000640077006F0072006400000077006F0072006400000000007500730068006F007200740000000000730068006F0072007400000062006F006F006C000000000062006F006F006C00650061006E0000006200790074006500000000006E006F006E006500000000000004020000000000C0000000000000460000000000000000C0000000000000460100000000000000C0000000000000460A01000000000000C0000000000000468023D57F074E1B10AE2D08002B2EC713C456000000000000000000003259000000500000B45700000000000000000000105A0000F05000002457000000000000000000001A5A000060500000AC5700000000000000000000385A0000E85000000000000000000000000000000000000000000000E4570000F0570000FC5700000E5800002458000032580000485800005A5800006E5800007A5800008A5800009C580000AC580000BA580000CE580000D6580000EC580000FE5800001459000020590000505A0000445A00005C5A00000000000005010080B7000080A3000080BA010080BA000080BB01008092000080540000800800008009000080020000804A00008019000080130000800F0000801A0000801100008018000080170000800C000080070000807D000080850000800A0000803300008012010080470000803D000080880000800801008036000080150100804000008000000000285A000000000000E6590000D6"
		$sBinaryDll &= "590000B2590000A259000090590000C4590000F65900006459000050590000405900007C5900000000000048056C7374726370795700004E056C7374726C656E570000450247657450726F6341646472657373000011055769646543686172546F4D756C746942797465006201467265654C6962726172790067034D756C746942797465546F5769646543686172003E034C6F61644C69627261727945785700005701466C75736846696C654275666665727300002505577269746546696C6500640247657453746448616E646C6500006400436F6D70617265537472696E675700003F034C6F61644C6962726172795700005200436C6F736548616E646C6500C0045465726D696E61746550726F636573730000B204536C65657000DF0147657445786974436F646550726F636573730000A80043726561746550726F6365737357000014024765744D6F64756C6546696C654E616D655700003F056C737472636174570000710147657442696E617279547970655700004B45524E454C33322E646C6C00006800436F5461736B4D656D46726565007E0043726561746546696C654D6F6E696B657200970047657452756E6E696E674F626A6563745461626C65001000436F437265617465496E7374616E636500006C00436F556E696E697469616C697A6500003E00436F496E697469616C697A6500000600434C53494446726F6D50726F674944000800434C53494446726F6D537472696E6700CD0049494446726F6D537472696E67004600436F4C6F61644C696272617279001E00436F46726565556E757365644C69627261726965734578006F6C6533322E646C6C004F4C4541555433322E646C6C00004A01537472546F496E7436344578570053484C574150492E646C6C00CB0248656170416C6C6F6300CF02486561704672656500004A0247657450726F63657373486561700000000000000000958BD54D00000000605B0000010000001400000014000000985A0000E85A0000385B0000AA40000080400000C2400000A2430000264500004A400000344000001E40000075410000DA40000000410000C1420000D14200006740000081420000D841000098400000E1420000474200002C410000715B0000795B0000835B00008F5B0000A85B0000C35B0000D55B0000E85B0000005C0000145C0000285C00003E5C00004D5C00005D5C0000685C0000785C0000875C0000945C00009F5C0000B05C000000000100020003000400050006000700080009000A000B000C000D000E000F0010001100120013004175746F49744F626A6563742E646C6C00416464456E756D004164644D6574686F640041646450726F7065727479004175746F49744F626A6563744372656174654F626A656374004175746F49744F626A6563744372656174654F626A656374457800436C6F6E654175746F49744F626A6563"
		$sBinaryDll &= "74004372656174654175746F49744F626A656374004372656174654175746F49744F626A656374436C61737300437265617465446C6C43616C6C4F626A65637400437265617465577261707065724F626A65637400437265617465577261707065724F626A65637445780049556E6B6E6F776E4164645265660049556E6B6E6F776E52656C6561736500496E697469616C697A65004D656D6F727943616C6C456E7472790052656769737465724F626A6563740052656D6F76654D656D6265720052657475726E5468697300556E52656769737465724F626A65637400577261707065724164644D6574686F640000000052534453C9BE4A7E855B8849AB9F359DFC1EB0F635000000443A5C446F63756D656E747320616E642053657474696E67735C7472616E636578785C4465736B746F705C56617A6E6520736B72697074655C4175746F49744F626A656374325C7472756E6B5C52656C656173655C4175746F49744F626A6563742E7064620000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011000B000B00020012001200130013001300030003000C00140015000400050013001E001F00080013001300130003000300030003001300130013001300090009000000000004560010F8550010E8550010DC550010D0550010C0550010B4550010A85500109C55001090550010845500107C5500106C55001060550010505500104455001034550010245500101C5500101055001004550010FC540010EC540010E0540010D0540010BC540010AC5400109C540010885400107454001060540010505400103C5400102C540010220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
		$sBinaryDll &= "00000000000000000000000000000000000000000000000000000000000000000001001000000018000080000000000000000000000000000001000100000030000080000000000000000000000000000001000904000048000000607000001803000000000000000000000000000000000000180334000000560053005F00560045005200530049004F004E005F0049004E0046004F0000000000BD04EFFE00000100020001000200080002000100020008000000000000000000040000000200000000000000000000000000000076020000010053007400720069006E006700460069006C00650049006E0066006F000000520200000100300034003000390030003400420030000000300008000100460069006C006500560065007200730069006F006E000000000031002E0032002E0038002E0032000000340008000100500072006F006400750063007400560065007200730069006F006E00000031002E0032002E0038002E00320000007A0029000100460069006C0065004400650073006300720069007000740069006F006E0000000000500072006F007600690064006500730020006F0062006A006500630074002000660075006E006300740069006F006E0061006C00690074007900200066006F00720020004100750074006F0049007400000000003A000D000100500072006F0064007500630074004E0061006D006500000000004100750074006F00490074004F0062006A006500630074000000000058001A0001004C006500670061006C0043006F0070007900720069006700680074000000280043002900200054006800650020004100750074006F00490074004F0062006A006500630074002D005400650061006D0000004A00110001004F0072006900670069006E0061006C00460069006C0065006E0061006D00650000004100750074006F00490074004F0062006A006500630074002E0064006C006C00000000007A002300010054006800650020004100750074006F00490074004F0062006A006500630074002D005400650061006D00000000006D006F006E006F00630065007200650073002C0020007400720061006E0063006500780078002C0020004B00690070002C002000500072006F00670041006E006400790000000000440000000100560061007200460069006C00650049006E0066006F00000000002400040000005400720061006E0073006C006100740069006F006E00000000000904B0040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000A80000"
		$sBinaryDll &= "000A30113021302830B330D130133122313B315B317D318D319C31A2314A3276329932E132063318332A333B339033AD3362349534653501360F36373646364F367436C436D336F736C237FC371D384E387E389338FA38273935395E3977398C39F739153A293A3B3A4F3A873A943AD13A493B763B843BAD3BC63BDB3B0A3C233C3A3D403DA23DC93DCF3DC33EFB3E093F293F333F663F883FA53FC23FDF3FFC3F002000006C0000001C3011314C316C318C31A931C631E33100327C32BD3305345A34BC343D356035EA358436B9364A375A376D37DE37B238D438EA380E39393965399139BC39E839B83AD53AFE3AA83BDF3BFC3B0B3CC93C063D443D823DBF3DFD3D443E7C3ECD3E093F853F00300000A0000000D630F430FE3037314C319131EC312C328D32F432193324336D33AA33D633F43318343C345A3471349234AB34B23425358235A735C535E935F8351D363B3652367E36A036B9363237403760376E379137B437DB37FF371C382A38A338B13870397E39AC3A0B3B213B2F3B3D3B5B3B8C3B473CA03CD13C7B3D9F3DE53D2B3E373E963EC03EE03EFE3E7A3FA53FBA3FC43FCD3FE83FF23F0000004000007C0000008531E631FB3153329B32AA32B132B83201331E332A333C334E3362338133B333CA33E033F33302341234223436344834C934D434E934353543355835673577358735E935EF350236073615362736423647366136AA36CC36E536ED361C37273736373D3748375637763787379D37F7371138000000500000400000003C314031443148314C31503154312C323032343238323C3240324432FC320033043308330C33103314336C337033743378337C3380338433006000004C00000048304C305030543058305C306030643068306C307030743078307C308030843088308C309030943098309C30A030A430A830AC30B030B430B830BC30C030C430C830CC30000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
		Return $sBinaryDll
	EndFunc
	
	Func __AutoItObject_x64_DLL()
		Local $sBinaryDll = ''
		$sBinaryDll &= "0x4D5A90000300000004000000FFFF0000B800000000000000400000000000000000000000000000000000000000000000000000000000000000000000E00000000E1FBA0E00B409CD21B8014CCD21546869732070726F6772616D2063616E6E6F742062652072756E20696E20444F53206D6F64652E0D0D0A2400000000000000CCFFC840889EA613889EA613889EA613E7E809138A9EA61381E625138C9EA61381E63513819EA613889EA713CC9EA613E7E80D138F9EA613E7E83D13899EA613E7E83C13899EA613E7E83B13899EA61352696368889EA61300000000000000005045000064860600A48BD54D0000000000000000F00022200B020A00004A00000020000000000000B44E000000100000000000800100000000100000000200000500020000000000050002000000000000C0000000040000000000000200400100001000000000000010000000000000000010000000000000100000000000000000000010000000D06F000055020000906A00006400000000A000007803000000900000A8030000000000000000000000B000008C000000406200001C0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000600000400200000000000000000000000000000000000000000000000000002E74657874000000FB49000000100000004A000000040000000000000000000000000000200000602E72646174610000251200000060000000140000004E0000000000000000000000000000400000402E646174610000007C010000008000000002000000620000000000000000000000000000400000C02E70646174610000A8030000009000000004000000640000000000000000000000000000400000402E727372630000007803000000A000000004000000680000000000000000000000000000400000402E72656C6F630000E000000000B0000000020000006C000000000000000000000000000040000042000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000040534883EC20488BD9FF15A15000004C8BC3488BC8BA080000"
		$sBinaryDll &= "004883C4205B48FF2582500000CCCC40534883EC20488BD9FF15795000004C8BC3488BC833D24883C4205B48FF2555500000CC40534883EC204883210083612000488BD94883C108FF1599500000488BC34883C4205BC340534883EC20488BD9488B094885C97405E8A2FFFFFF488D4B084883C4205B48FF2572500000CCCC488B01C3488D4108C3CCCCCC8B4124C3895124C348895C24084889742410574883EC206683790800488BF2488BF9740A4883C108FF1536500000B808000000488BCE66894708FF152C500000488B5C2430488B742438488947104883C4205FC34883C10848FF2575500000CC48895C2408574883EC20488BD9488B09488BFA4885C97405E807FFFFFF488BCFFF15DE4E000048C7C1FFFFFFFFFFC04863D0B80200000048F7E2480F40C1488BC8E8B6FEFFFF488BD7488BC8488903488B5C24304883C4205F48FF259C4E000048890DFD6F0000C340534883EC20488D05E7500000488BD94889014883C130FF157F4F0000488B4B10488B01FF501048836310004883C4205BC3CCCC4055488BEC4883EC404C8B124533DB4C8BC9488D4DE0C745E8C0000000C745EC000000464C895DE048C745F004040200C745F8C0000000C745FC000000464C3B11750F4C8B52084C3B51087505418BC3EB051BC083D8FF85C0742E488B0A488D45F0483B08750F488B4A08483B48087505418BC3EB051BC083D8FF85C0740A4D8918B802400080EB0E4D8908498B01498BC9FF500833C04883C4405DC3CCCCCC40534883EC30488B51184C894424204C8B4110498BD94C8D493033C9FF15066F000033C985C089030F94C18BC14883C4305BC3CC40534883EC304C8B4110488B512833DB4C8D49308D4B0148895C2420FF15D26E000085C00F94C38BC34883C4305BC3CC40534883EC304C8B4110488B512033DB4C8D49308D4B0248895C2420FF15A26E000085C00F94C38BC34883C4305BC3CC40534883EC20FF4908488BD97511E885FEFFFF488BCBE839FDFFFF33C0EB038B41084883C4205BC348895C24084889742410574883EC208361080048895110488D05464F0000488901488B02488BF1488BCA498BF9498BD8FF5008488B442450488D4E304889462848895E1848897E20FF15B64D0000488B5C2430488BC6488B7424384883C4205FC3CCCCCC48890D096E0000C348895C2408574883EC204C8B0A498BF84C8D0581ECFFFF488BD94D3B883868000075114C8B4A084D3B8840680000750433C0EB051BC083D8FF85C0742D488B0A493B88286800007511488B4A08493B8830680000750433C0EB051BC083D8FF85C07407B802400080EB0E488B03488BCBFF500848891F33C0488B5C24304883C4205FC3CC4D85C974044983210033C0C348895C240848896C2410488974241857415441554883EC20488BD9488B4920498BF9498BE8488BF24885C97405E8FEFBFFFF488BCEFF15D54B0000"
		$sBinaryDll &= "41BC02000000FFC04D8D6C24FD4863C8418BC448F7E1490F40C5488BC8E8ABFBFFFF488BD6488BC848894320FF159B4B0000488B4B284885C97405E8B5FBFFFF488BCDFF158C4B0000FFC04863C8498BC448F7E1490F40C5488BC8E86DFBFFFF488BD5488BC848894328FF155D4B0000488B4B304885C97405E877FBFFFF488BCFFF154E4B0000FFC04863C8498BC448F7E1490F40C5488BC8E82FFBFFFF488BD7488BC848894330488B5C2440488B6C2448488B7424504883C420415D415C5F48FF25064B0000CCCC48895C24084889742410574883EC20488BD98B4908488BF28D41013B430C765C448D44090248C7C1FFFFFFFFB80800000049F7E0480F40C1488BC8E8C4FAFFFF4533C9488BF844394B08761B458BC1488B0B41FFC1498B1408498914004983C008443B4B0872E8488B0BE8BDFAFFFF8B4B0848893B8D44090289430C488B03488934C8FF4308488B5C2430488B7424384883C4205FC3CCCC40534883EC20488BD9488B09E883FAFFFF4533DB4C891B4C895B084883C4205BC3CCCCCC48895C240848896C24104889742418574883EC20488D05AD4D000033FF488BD9488901397918762A33F6488B4310488B2C064885ED7410488BCDE879FAFFFF488BCDE829FAFFFFFFC74883C6083B7B1872D8488D4B10E881FFFFFF488D4B40FF15EB4A0000488D4B70FF15E14A0000488D4B58FF15D74A0000488B4B204885C97405E8E9F9FFFF488B4B284885C97405E8DBF9FFFF488B4B304885C97405E8CDF9FFFF488B4B10488B5C2430488B6C2438488B7424404883C4205FE9B0F9FFFF48895C2408488974241048897C2418554154415541564157488BEC4883EC50440FB7455041B908000000488BF1458D71F9450FB7D0458D79FA664523D60F85E20000004584C70F85D900000041F6C00475094584C10F847D02000081FA7CFCFFFF0F8581000000488B5D5844397B100F854A080000488B430833FF8338FD8BC78BF7400F94C685F60F95C04C8D2C40488B034A8D0CE80FB70183F813741D448D6703413BC4741483F81A742183F815741C83F8147417E9A500000041B9150000004533C0488BD1FF15134A0000488B0B85F6400F94C7488D047F488D14C14A8B4CE908E99F00000081FA7AFCFFFF751833FF39790C0F84C40700004883C158488B5558488B12EB7F81FA79FCFFFF0F85C401000033FF39790C0F84A00700004883C170EBDA81FA7CFCFFFF7567488B5D58443973100F8584070000488B0B0FB70183F813742441BC03000000413BC4741983F81A742683F815742183F814741CB805000280E95A07000041B9150000004533C0488BD1FF1564490000488B13488B5208488B4D60FF157349000033C0E93007000081FA7BFCFFFF756D33FF39790C0F8418070000488B4948488D55E0FF152349000085C07547488B45E0448D4F08488D0D204B000066448908FF15C6480000488B4D"
		$sBinaryDll &= "E048894108488B45E08D4F0966894818488B45E0488BCE48897020488B06FF5008488B4E48FF15D0480000488D5640E97AFFFFFF81FA7AFCFFFF7509488D5158E969FFFFFF81FA78FCFFFF751733FF39790C0F8492060000488D9188000000E94AFFFFFF81FA77FCFFFF753333FF39790C0F8473060000488B5D60488BCBFF1537480000448D4F086644890B488B4E38FF152D48000048894308E919FFFFFF83FAFC755F33FF483979200F843A060000488B5D60488BCBFF15FE470000448D5F0D8D4F486644891BE8E6F6FFFF4885C0741F488B4E304C8B4E284C8B462048894C2420488BD6488BC8E8C1F9FFFF488BF848897B08488B07488BCFFF5008E9B5FEFFFF33FF85D20F88DD0500008B41184103C63BD00F8DCF050000488B46108BCA4C8B2CC8664585D20F85B90200004584C70F85B002000041F6C00475094584C10F84A3050000498BCDE808F7FFFF85C07409397E0C0F848E050000498BCDE833130000FFC80F849F010000FFC80F8576050000488B5D5844397B100F8591000000498BCDE8C5F6FFFFB90C200000488BF06639080F8556010000488B4808FF154E470000413BC60F8543010000488B4B08488BC7448BEF8339FD41BC03000000410F94C54585ED0F95C04C8D3440488B034A8D0CF066443B21740F458BCC4533C0488BD1FF1520470000488B0B488BC74585ED0F94C04A8D54F108488D04404C8D04C1488B4E08FF15DD460000E9A002000041BC03000000443963100F85CE000000498BCDE824F6FFFFB90C200000488BF06639080F85B5000000488B4808FF15AD460000413BC70F85A2000000488B4B08448BEF8339FD410F94C5418BC5F7D8488B03481BC94923CF488D0C49488D0CC866443B21740F458BCC4533C0488BD1FF1583460000488B0B4883C11866443B21740F458BCC4533C0488BD1FF1567460000488B134585ED488BC70F95C0488D04408B4CC208418BC5F7D8894DE0481BC948F7D94903CE41F7DD488D04498B4CC208481BC048F7D0894DE44923C7488D04404C8D04C2488D55E0E913FFFFFF443973100F8574020000488B13498BCDE8A5F5FFFFE9ADFCFFFF4401760C498BCDE834F5FFFF4C8D6640498BCC48894638FF15934500004C8D7E70498BCFFF1586450000488B4558B90C000000448B70104C8D45E88D51F5418D4602897DEC8945E8FF158A450000488D55F0488BC8488BD8488945E0FF159645000085C0755E4585F67E504C8B7D58418D4EFF8D58304863D14C8D245249C1E403488B4DF04803CBFF151A4500004D8B1F488B4DF04B8D141C4803CBFF157E4500004983EC184883C31849FFCE75D2488B5DE04C8D7E704C8D6640488BCBFF152C45000048895E488B9E90000000C7869000000001000000E996020000498BCDE8A7100000FFC80F849B010000FFC80F85EA020000498BCDE84FF4FFFF413BC77509397E0C0F84D4020000488B5D58"
		$sBinaryDll &= "443973100F859F000000498BCDE823F4FFFFB90C200000488BF06639080F852D010000488B4808FF15AC440000413BC60F851A010000488B0B41BC0300000066443B21740F458BCC4533C0488BD1FF159D440000488B134883C208833AFF752B488B5D60488BCBFF1534440000418BD666448923488B4E084C8D4308FF153F44000044017308E913FBFFFF4C8B4560488B4E08FF15204400002BF8F7DF1BC02509000280E92C02000044397B100F859D000000498BCDE87AF3FFFFB90C200000488BF06639080F8584000000488B4808FF1503440000413BC77575488B0B41BC0300000066443B21740F458BCC4533C0488BD1FF15F8430000488B0B4883C11866443B21740F458BCC4533C0488BD1FF15DC430000488B0B8B41088945E08B41208945E483F8FF751E488B5D60488BCBFF156B43000044397DE0400F95C7418D143EE929FFFFFF488D55E0E93BFFFFFF397B10740AB80E000280E97601000048397D600F8435FAFFFF498BCDE8C4F2FFFF488BD0E91BFAFFFF498BCDE8BCF2FFFF85C07409397E0C0F84420100004401760C498BCDE897F2FFFF4C8D6640498BCC48894638FF15F64200004C8D7E70498BCFFF15E9420000488B4558B90C000000448B70104C8D45F08D51F5418D4602897DF48945F0FF15ED420000488D55E8488BC8488BD8488945E0FF15F942000085C075604585F67E524C8B7D58418D4EFF8D58304863D14C8D245249C1E403488B45E8488D0C03FF157C4200004D8B1F488B45E84B8D141C488D0C03FF15DF4200004983EC184883C31849FFCE75D0488B5DE04C8D7E704C8D6640488BCBFF158D42000048895E488B9E9000000089BE90000000B90C2000006641890C2441BC03000000498BCD664489A688000000E8B1F1FFFF488BD6488B4808FF1578620000488B4D60899E90000000448BE04885C97409498BD7FF1565420000488D4E40FF15EB410000498BCFFF15E2410000FF4E0C41F7DC1BC0F7D02503000280EB05B8030002804C8D5C2450498B5B30498B7338498B7B40498BE3415F415E415D415C5DC3CCCC48895C240848896C24104889742418574883EC2033DB488BEA488BF1395918762933FF488B4610488B0C07E80CF1FFFF488BD5488BC8E8D132000085C07423FFC34883C7083B5E1872D983C8FF488B5C2430488B6C2438488B7424404883C4205FC38BC3EBE7CCCC48895C240848896C24104889742418574883EC20488BD9E87CFFFFFF8BF083F8FF7E34488B5310488B3CF24885FF7410488BCFE874F0FFFF488BCFE824F0FFFFFF4B183B7318730F488B53108B4318488B0CC248890CF2488B5C2430488B6C2438488B7424404883C4205FC348895C240848896C24104889742418574883EC20488BF9488BCA488BDAE846F0FFFF488BCF488BD0E8FFFEFFFF8BF083F8FF7437488BCBE82CF0FFFF6683387E7429488B47108BEE488B34F04885F67410"
		$sBinaryDll &= "488BCEE8E7EFFFFF488BCEE897EFFFFF488B471048891CE8EB0C488D4F10488BD3E855F4FFFF488B5C2430488B6C2438488B7424404883C4205FC348895C2408574883EC2033DB488D05B1420000488BF9488901488959084889591048895918488959204889592848895930488959384883C140FF1505400000488D4F58FF15FB3F0000488D4F70FF15F13F0000488D8F88000000FF15E43F00008D4B28E8DCEEFFFF4885C0740B488BC8E81BEFFFFF488BD833D2488BCBE8AA0B0000BA02000000488BCBE85DEFFFFF488D1546410000488BCBE8AAEFFFFF488BD3488BCFE8CBFEFFFF488B5C2430488BC74883C4205FC3CC48895C240848896C2410488974241857415441554883EC208361080083610C00488D05E541000048890148836110008361180083611C004883612000488361280048836130004883613800488BF94883C140488BF2FF15313F0000488D4F58FF15273F0000488D4F70FF151D3F0000488D8F88000000FF15103F00004533ED44396E180F868F0000004533E4B928000000E8F6EDFFFF4885C0740D488BC8E835EEFFFF488BE8EB0233ED488B4610498B1C04488BCBE8B60A0000488BCD8BD0E8B00A0000488BCBE85CEEFFFF488BCD488BD0E8ADEEFFFF488BCBE851EEFFFF488BCD8BD0E84BEEFFFF488BCBE833EEFFFF488BCD488BD0E894EEFFFF488BD5488BCFE8B5FDFFFF41FFC54983C408443B6E180F8274FFFFFF488B56204885D274104C8B4E304C8B4628488BCFE853F1FFFF488B5C2440488B6C2448488B742450488BC74883C420415D415C5FC3CCCCCC48895C241048896C24184889742420574883EC20FF49088B4108488BF90F85B900000048833D815E0000000F8499000000FF410C83642434008B7118FFC0FFCEC7442430020000004863EE894108746348C1E503488B4710488B0C28E873EDFFFF6683387E7544488D4F40FF15D33D0000B90C0000004C8D4424308D51F5FF15E83D000048894748B80C20000066894740488B4710488B0C28E83AEDFFFF488BD7488B4808FF15015E00004883ED08FFCE75A1488D4F70FF15873D0000488D4F40FF157D3D0000FF4F0C488BCFE822F2FFFF488BCFE88AECFFFF33C0488B5C2438488B6C2440488B7424484883C4205FC3CCCCCC48895C2408574883EC20498B10488BF9488D0DE13E0000498BD8E8912E000085C07518488B442458C700FCFFFFFF33C0488B5C24304883C4205FC3488B13488D0DCB3E0000E8662E000085C0750D488B442458C7007CFCFFFFEBD3488B13488D0DC33E0000E8462E000085C0750D488B442458C7007BFCFFFFEBB3488B13488D0DBB3E0000E8262E000085C0750D488B442458C7007AFCFFFFEB93488B13488D0DB33E0000E8062E000085C07510488B442458C70079FCFFFFE970FFFFFF488B13488D0DA83E0000E8E32D000085C07510488B442458C70078FCFFFFE94DFFFFFF488B"
		$sBinaryDll &= "13488D0DA53E0000E8C02D000085C07510488B442458C70077FCFFFFE92AFFFFFF488B13488BCFE895FAFFFF488B4C2458890183F8FF0F850FFFFFFFB806000280E907FFFFFFCCCCCC488BC44889580848896810488970184889782041544883EC204C8BE1B928000000418BF9498BF0488BEAE8EDEAFFFF33DB4885C0740B488BC8E82AEBFFFF488BD8BA01000000488BCBE8B60700008BD7488BCBE86CEBFFFF488BD5488BCBE8BDEBFFFF488BD6488BCBE85AEBFFFF488BD3498BCC488B5C2430488B6C2438488B742440488B7C24484883C420415CE9B9FAFFFFCC488BC44889580848896810488970184889782041544883EC204C8BE1B928000000498BF9418BF0488BEAE859EAFFFF4885C0740D488BC8E898EAFFFF488BD8EB0233DBBA02000000488BCBE8200700004885FF740B488BD7488BCBE820EBFFFF8BD6488BCBE8C6EAFFFF488BD5488BCBE817EBFFFF488BD3498BCC488B5C2430488B6C2438488B742440488B7C24484883C420415CE91EFAFFFFCCCC4883EC2883791400488D054D3E0000488901750A488B4908488B01FF50104883C428C3CC8B4110FFC0894110C3CCCCCCB802400080C3CCCCB801400080C3CCCC40534883EC20498B10488D0D543D0000498BD8E8FC2B000085C07510488B442458C7009CFFFFFFE9C1000000488B13488D0D3E3D0000E8D92B000085C07510488B442458C7009BFFFFFFE99E000000488B13488D0D2B3D0000E8B62B000085C0750D488B442458C7009AFFFFFFEB7E488B13488D0D233D0000E8962B000085C0750D488B442458C70099FFFFFFEB5E488B13488D0D1B3D0000E8762B000085C0750D488B442458C70098FFFFFFEB3E488B13488D0D1B3D0000E8562B000085C0750D488B442458C70097FFFFFFEB1E488B13488D0D0B3D0000E8362B000085C0750F488B442458C70096FFFFFF33C0EB05B8060002804883C4205BC348895C24084889742410574883EC20BE01000000488BF9448D5E0183FA9C751144845C24507511B809000280E9C40200004084742450EBED33DB395914740F83FA9B740AB810000280E9A702000083FA9C753E488B442458395810740AB80E000280E98E020000488B5C2460488BCBFF154339000041BB090000006644891B488B47084889430889771433C0E96402000083FA9B7547488B44245839581075BD395914750A488B4908488B01FF5010B9A0000000E8F7E7FFFF4885C0740D488BC8E8A6F8FFFF488BC8EB03488BCB48894F08488B01FF5008895F14EBAD83FA9A0F858C0000004C8B4C2458458B4110453BC3740A4183F8030F855FFFFFFF4D8B118BD38BCB418D40FE488D04406641833CC208418D40FF0F95C2488D04406641833CC2080F95C10BD1740AB808000280E9C00100004183F80375096641395A08410F45DB488B4F08418D40FE458BC84C8D0440418D41FF448BCB4F8B44C208488D1440498B"
		$sBinaryDll &= "54D208E827FCFFFFE918FFFFFF83FA99755B488B4424588B501085D20F84D6FEFFFF83FA030F87CDFEFFFF4C8B108D42FF4C8D1C406643833CDA087589448BC33BD6760C8D42FE488D0440458B44C208488B490883FA034B8B54DA08490F44DA4C8BCBE85BFCFFFFE9B8FEFFFF83FA987533488B4424583970100F8578FEFFFF4C8B0066418338080F8538FFFFFF4D8B4008488B49084533C9488D15973A0000E95EFFFFFF83FA970F858E0000004C8B542458458B4210453BC3740A4183F8030F8532FEFFFF4D8B1A8BD3418D40FE488D04406641833CC308418D40FF0F95C2488D04406641833CC3080F95C30BD30F85D1FEFFFF4C8D0D733A00004183F803750F6641833B080F85B9FEFFFF4D8B4B08488B4908418D40FE458BD04C8D0440418D42FF4F8B44C308488D1440498B54D308E80CEAFFFFE9E9FDFFFF83FA96754A488B4424583970100F85A9FDFFFF488B08668339080F856AFEFFFF488B7108488D0D3C3A0000488BD6E84428000085C07507B805000280EB16488B4F08488BD6E889F5FFFFE99AFDFFFFB803000280488B5C2430488B7424384883C4205FC3CCCCCC40534883EC20FF4910488BD97511E8A9FBFFFF488BCBE8B5E5FFFF33C0EB038B41104883C4205BC348895C2408574883EC20488D05DF390000488BF933DB48890148895910B9A0000000E859E5FFFF4885C0740B488BC8E808F6FFFF488BD848895F08488B03488BCBFF5008488B5C2430488BC74883C4205FC3CCCC834920FF33C08901488941084889411048894118488BC1C340534883EC20488BD9488B49084885C97405E825E5FFFF833B007412488B4B18E817E5FFFF488B4B10E80EE5FFFF4883C4205BC3488B4108C3CCCCCC48895C2408574883EC20488BD9488B4908488BFA4885C97405E8E2E4FFFF488BCFFF15B9340000FFC04863C8B80200000048F7E148C7C1FFFFFFFF480F40C1488BC8E891E4FFFF488BD7488BC848894308488B5C24304883C4205F48FF2576340000CCCC488B4110C3CCCCCC488BC44889580848896810488970184889782041544883EC204533E4488BF2488BD94439217412488B4918E864E4FFFF488B4B10E85BE4FFFF418BFC418BCC498BD4664439260F84E4000000488BC64C8D46026683383B750E664539207404FFC7EB046644892048FFC2FFC14983C002488D04566644392075D985C97402FFC785FF0F84A8000000FFC1B80200000048C7C5FFFFFFFF4863D1893B48F7E2480F40C5488BC8E8C2E3FFFF488BD6488BC848894318FF15B23300004C63DF8D7D098BC749F7E3480F40C5488BC8E89BE3FFFF488B4B18458BD448894310488908488B43184D8BCC664439207447498BCC448BC7488B431866833C083B751C6644892408488B43184963CA488D544802488B4310498914004C03C7488B431849FFC141FFC24B8D0C09664439240175C4EB03448923488B5C2430488B6C"
		$sBinaryDll &= "2438488B742440488B7C24484883C420415CC3CCCC8B4120C3895120C38B4108FFC0894108C3CCCCCC48895C2408574883EC204C8BCA498BF8488D15F1D2FFFF4D8B014533D2488BD94C3B823868000075124D8B41084C3B82406800007505418BC2EB051BC083D8FF85C07522443951407415488B4920488B01FF50084C8B5B204C891F33C0EB68B801400080EB61488D8A28680000498B11483B11750F498B5108483B51087505418BC2EB051BC083D8FF85C0751E44395340740A488B4B20488B01FF5008488B03488BCBFF500848891FEBB0443953407411488B4B204C8BC7498BD1488B01FF10EB05B802400080488B5C24304883C4205FC3CCCC4885D2740383220033C0C3CC48895148C3CCCCCC40534881EC400400004883642438004C8B4158488364243000488D442440488BD94183C9FF33D233C9C7442428000400004889442420FF15FC310000488B4B48488D542440FF15E53100004881C4400400005BC3488BC4488958084889681048897018488978204154415541564883EC20488BCA4D8BE1498BE8488BDAFF15A531000041BD2A0000004863F033FF6644396C73FE753E8D4F08488BD366897C73FEE80E240000488B4C2460668901B8FFFF00006644896C73FE663901743DC745000100000041C7042404000000B801000000EB298BF7488BC766393B741D488BCB41BE3A00000066443931742F48FFC0FFC6488D0C4366393975EC33C0488B5C2440488B6C2448488B742450488B7C24584883C420415E415D415CC38D4601488D15EA3500004863C8488D0C4BE85623000085C0750841C70424010000004863F6B908000000488BD36644396C73FE752E66897C73FEE859230000488B4C2460668901B8FFFF00006644896C73FE6639017488C7450001000000E94EFFFFFF66893C73E82C230000488B4C2460668901B8FFFF00006644893473663901400F95C78BC7E955FFFFFF48895C240848896C24104889742418574883EC2033DB498BE9498BF84863F285D27E11488B0CDFE874E0FFFF48FFC3483BDE7CEF488BCFE864E0FFFF488BCDE85CE0FFFF488B4C2450E852E0FFFF488B4C2458E848E0FFFF488B4C2460488B5C2430488B6C2438488B7424404883C4205FE92AE0FFFFCCCC48895C2408574883EC20488BFA4C8D4C244041B800000080488BCF33D2FF154531000033DB85C0750766395C2440EB0B488BCFFF152731000085C00F95C3F7DB8BC3488B5C24304883C4205FC3CCCCCC4883EC38488D542450660F28C10F29742420660F28F1FF150431000085C075068A442450EB05F2480F2CC60F287424204883C438C3CCCCCC4883EC38488D542450660F28C10F29742420660F28F1FF151C30000085C075070FB7442450EB05F2480F2CC60F287424204883C438C3CCCC4883EC38488D542450660F28C10F29742420660F28F1FF15A430000085C075070FB7442450EB05F248"
		$sBinaryDll &= "0F2CC60F287424204883C438C3CCCC4883EC38488D542450660F28C10F29742420660F28F1FF157430000085C075068B442450EB05F2480F2CC60F287424204883C438C3CCCCCC4883EC38488D542450660F28C10F29742420660F28F1FF154430000085C07508F30F10442450EB04F20F5AC60F287424204883C438C3CCCC4883EC38488D542450660F28C10F29742420660F28F1FF151430000085C075068B442450EB05F2480F2CC60F287424204883C438C3CCCCCC4533C9418BC96644390A7433488BC2458D592C458D512E4585C0740C66443918751066448910EB0A6644391075046644891848FFC1488D044A6644390875D8F3C3CCCCCC48895C242048894C240855565741544155415641574883EC2033FF488D05023300004584C9488901488D4110488979084889384889780848894424708BC70F94C0488BE9488979488941404883C1284D8BE8488BDAFF15C12E00000FB6842480000000498BCD48895D208945500FB68424880000004C896C2468448BF7448BFF894554FF159B2D0000488B6C24708D7701448D6001498BDD66833B7C750C8BC666893B4D8D744500EB6766833B0A740566393B755CB92800000066893BE85ADDFFFF4885C0740B488BC8E821F8FFFF488BF8488B542468488BCFE865F8FFFF498BD6488BCFE8C6F8FFFF418BD7488BCFE80FFAFFFF488BD7488BCDE818E2FFFF8BC641FFC7498D44450033FF4889442468FFC64883C30249FFCC0F8578FFFFFF488B442460488B5C24784883C420415F415E415D415C5F5E5DC3CCCC48895C240848896C24104889742418574883EC20488D05CD31000033FF488BD9488901397918762A33F6488B4310488B2C064885ED7410488BCDE88DF7FFFF488BCDE8C1DCFFFFFFC74883C6083B7B1872D8488D4B10E819E2FFFF488D4B28FF15832D0000837B4000740A488B4B20488B01FF5010488B4B484885C97406FF157C2C0000837B5000740A488B4B20FF15742E0000488B4B10488B5C2430488B6C2438488B7424404883C4205FE957DCFFFFCCCCCC48895C240848896C24104889742418574883EC208B5918488BEA488BF1FFCB4863FBEB21488B4610488B0CF8E81BF7FFFF488BD5488BC8E8581E000085C07423FFCB48FFCF4883FFFF7FD983C8FF488B5C2430488B6C2438488B7424404883C4205FC38BC3EBE7CC48895C240848896C24104889742418574883EC20488BD9488BCA488BF2E8C2F6FFFF488BCB488BD0E86BFFFFFF83F8FF750E488D4B10488BD6E882E0FFFFEB278BE8488B4310488B3CE84885FF7410488BCFE859F6FFFF488BCFE88DDBFFFF488B4310488934E8488B5C2430488B6C2438488B7424404883C4205FC340534883EC204533C0488BDAE8D7FCFFFF4C8D4C244033D241B800000080488BCBFF15C12C000085C075068A442440EB144C8D44244833D2488BCBFF15D72C00008A4424484883C4205BC3"
		$sBinaryDll &= "CC40534883EC204533C0488BDAE88BFCFFFF4C8D4C244033D241B800000080488BCBFF157D2C000085C075070FB7442440EB154C8D44244833D2488BCBFF158A2C00000FB74424484883C4205BC3CCCCCC40534883EC204533C0488BDAE83BFCFFFF4C8D4C244033D241B800000080488BCBFF15352C000085C075070FB7442440EB154C8D44244833D2488BCBFF153A2C00000FB74424484883C4205BC3CCCCCC40534883EC204533C0488BDAE8EBFBFFFF4C8D4C244033D241B800000080488BCBFF15ED2B000085C075068B442440EB144C8D44244833D2488BCBFF15EB2B00008B4424484883C4205BC3CC40534883EC204533C0488BDAE89FFBFFFF4C8D4C244033D241B800000080488BCBFF15A92B000085C075068B442440EB144C8D44244833D2488BCBFF159F2B00008B4424484883C4205BC3CC40534883EC204533C0488BDAE853FBFFFF4C8D4C244033D241B800000080488BCBFF15B52A000085C07508F30F10442440EB1B4C8D44244833D2488BCBFF15512B0000660FEFC0F3480F2A4424484883C4205BC340534883EC204533C0488BDAE8FFFAFFFF4C8D4C244033D241B800000080488BCBFF15412A000085C07508F20F10442440EB1B4C8D44244833D2488BCBFF15FD2A0000660FEFC0F2480F2A4424484883C4205BC348895C24084889742410574883EC2033DB488D050C2E00004584C04889018BC30F94C0488959084889591048895918894140410FB6C1488BF9895950488951208941544584C974248D4B28E8CCD8FFFF4885C0740B488BC8E893F3FFFF488BD8488D4F10488BD3E8ACDDFFFF488D4F28FF15A6290000488B5C2430488B742438488BC74883C4205FC3CCCCCC40534883EC20FF4908488BD97511E89DFBFFFF488BCBE89DD8FFFF33C0EB038B41084883C4205BC348895C2408574883EC20498B10488BD9488D0DF92C0000498BF8E8B11A000085C07518488B442458C700DCFCFFFF33C0488B5C24304883C4205FC3837B54007418488B0748894358488B4310488B08E834F3FFFF4885C074D5488B17488BCBE8D8FBFFFF488B4C2458890183F8FF75BEB806000280EBB9CC488BC4488958084889701048897818554154415541564157488D68C94881EC000100004C8BF10F2970C80FB7455F41B9020000000FB7C8458D41FF664123C875054184C1742A81FADCFCFFFF7522488B5D6F488BCBFF159D280000B815000000668903498B462048894308E90B1600004533FF45397E54751485D27806413B56187C0AB803000280E9F01500006685C975054184C174EC498B46108BCA488B3CC8488B4567448B601048897D9F440327418BC44489658725010000807D09412BC083C8FE4103C085C0750AB80E000280E9A81500004501460C418D4424FF48C7C6FFFFFFFF992BC2D1F84C63E8894583498BC14C896DA749F7E5480F40C6488BC8E8EAD6FFFF8D5E0948894424"
		$sBinaryDll &= "688BC349F7E5480F40C6488BC8E8D1D6FFFF488D4BF7488BF048894424508BC349F7E5480F40C1488BC8E8B4D6FFFF48C7C1FFFFFFFF44897C2464488BD84889442440B81800000049F7E5480F40C1488BC8E88CD6FFFF48C7C1FFFFFFFF4C8BF8B81800000049F7E5480F40C1488BC8E86ED6FFFF4533C04C8BE8418D4424FE664489442470458BE0458D50044863C848894D8F8944246083F8FF0F8E050D000025010000807D07FFC883C8FEFFC085C00F845E0C00004439077536488B4567488D3C49488B08B808000000663904F90F854D0C0000488B4CF908FF156227000089455F488B4567488B00488B7CF808EB2A488BCFE875F1FFFF4C8BD88B45872B442460992BC2D1F84863C8498B3CCB488BCFFF15D225000089455F4863442464488D1C40498D04DF488BC84889442458FF15AC260000498D74DD00488BCEFF159E260000488B5D9F33C039038B4424607409FFC8992BC2D1F8EB02FFC84863C8488B4567488B00488D1449488BCE488D14D0FF15E22600008B455FB92A000000FFC8488BD7488945F766390C470F855505000033C966890C47B908000000E8D3170000B92A0000004533C00FB7D8488B45F766890C47488B442458440FB7CB488BD0488BC8FF156F260000488B5424684533C00FB7C3B9004000004B8D3C64660BC1458D48086642890462410FB74CFD00418BC066413BC90F94C089455F6685DB0F844F0B0000418D4011663BD875488D48F0E8CAD4FFFF488BD833C039455F7414498B54FD08498BCEE86BF9FFFF8803E9F105000041B9110000004533C0488BD6488BCEFF15EF250000458A5CFD0844881BE9CF050000B80B000000663BD875448D48F9E878D4FFFF488BD833C039455F7412498B54FD08498BCEE861F4FFFFE90801000041B90B0000004533C0488BD6488BCEFF159F250000450FBF5CFD08E9EB010000B802000000663BD875288BC8E82BD4FFFF488BD833C039455F740F498B54FD08498BCEE868F9FFFFEB3341B902000000EB3941BA1200000066413BDA754B488BC8E8F6D3FFFF488BD833C039455F7415498B54FD08498BCEE8E3F8FFFF668903E91C05000041B9120000004533C0488BD6488BCEFF151A250000450FB75CFD086644891BE9F8040000B813000000663BD8752C8D48F1E8A1D3FFFF488BD833C039455F740F498B54FD08498BCEE82EF9FFFFEB3441B913000000E918010000B803000000663BD875318D4801E86BD3FFFF488BD833C039455F7414498B54FD08498BCEE844F9FFFF8903E99204000041B903000000E9DD000000B80C000000663BD875258D480CE830D3FFFF488BC8488BD8FF1524240000488BD6488BCBFF1590240000E958040000B814000000663BD87530498BC9E801D3FFFF488BD833C039455F0F845A020000498B4CFD084C8D45E733D2FF15B22400004C8B5DE7E991020000B815000000663BD87530498BC9E8C7D2"
		$sBinaryDll &= "FFFF488BD833C039455F0F8457020000498B4CFD084C8D45CF33D2FF15782400004C8B5DCFE95702000041BA0400000066413BDA754A418BCAE88BD2FFFF488BD833C039455F7416498B54FD08498BCEE8B0F8FFFFF30F1103E9B003000041B9040000004533C0488BD6488BCEFF15AE230000458B5CFD0844891BE98E030000B805000000663BD87533498BC9E837D2FFFF488BD833C039455F7416498B54FD08498BCEE8B0F8FFFFF20F1103E95C03000041B905000000E9B0010000B81E000000663BD8757666413BC97507498B74FD08EB2D488BD6488BCEFF154123000085C07516498B74FD08448D4001498BCE488BD6E871F3FFFFEB07488D3580260000B900000100E8BED1FFFF4183C9FF4C8BC6488BD833C033D24889442438488944243033C9C74424280000010048895C2420FF15A9210000E9D1020000B81F000000663BD8755866413BC97507498B74FD08EB2D488BD6488BCEFF15C122000085C07516498B74FD08448D4001498BCE488BD6E8F1F2FFFFEB07488D3504260000B900000200E83ED1FFFF488BD6488BC8488BD8FF152F210000E96F02000066413BD9755266413BC97507498B54FD08EB2A488BD6488BCEFF156322000085C07513498B54FD08448D4001498BCEE896F2FFFFEB07488D15AD250000488BCAFF15F4210000488945DF488D45DF498944FF08E9B20200006683FB1A0F84E10600006683FB257531498BC9E8BAD0FFFF488BD833C039455F7417498B4CFD084C8D45EF33D2FF156F2200004C8B5DEFEB5141B914000000EB356683FB26754B498BC9E883D0FFFF488BD833C039455F7417498B4CFD084C8D45D733D2FF15382200004C8B5DD7EB1A41B9150000004533C0488BD6488BCEFF15A52100004D8B5CFD084C891BE985010000BE09000000663BDE0F85A6060000498BC9E82AD0FFFF488BD866413974FD000F8560010000498B44FD08488903498B4CFD084885C90F844A010000488B01FF5008E93F010000488D0DBB240000E85612000085C00F85990000004B8D3C64B80800000066413944FD007507498B74FD08EB33448BC84533C0488BD6488BCEFF151421000085C07516498B74FD08448D4001498BCE488BD6E844F1FFFFEB07488D355F240000B900000100E891CFFFFF4183C9FF4C8BC6488BD833C033D24889442438488944243033C9C74424280000010048895C2420FF157C1F0000488B442468B9080000006642890C608D4116E98D000000488D0D16240000488BD7E8A611000085C00F859F0000004B8D3C64B80800000066413944FD007507498B74FD08EB33448BC84533C0488BD6488BCEFF156420000085C07516498B74FD08448D4001498BCE488BD6E894F0FFFFEB07488D35C7230000B900000200E8E1CEFFFF488BD6488BC8488BD8FF15D21E0000488B442468B9080000006642890C608D411766418904FF4C8B442440488B742450488B"
		$sBinaryDll &= "44245849895CFF084A8904E64B891CE0498BD8E990000000488D0D70230000488BD7E8F010000033D285C00F85830000004B8D1C64448D4A086645394CDD007507498B54DD08EB334533C0488BD6488BCEFF15B01F000085C07513498B54DD08448D4001498BCEE8E3EFFFFFEB07488D152623000041B908000000488B4424686646890C606645890CDF498954DF08488B442458488B742450488B5C24404A8904E633C04A8904E34533C0458D5004E91E0400003913488BD77407B908000000EB13488B458F488D0C40488B4567488B000FB70CC8E869100000488B7C2468B9FFFF00006642890467663BC10F844E0400006685C00F843E0400004B8D1C64B9080000006641394CDD000F8530010000498B7CDD08B90B000000663BC17538488BCEFF158F1E0000488B4424684533C0460FB70C60488BD6488BCEFF15C61E0000488BD7498BCEE863EDFFFF66418944DD08E952030000B911000000663BC17537488BCEFF154D1E0000488B4424684533C0460FB70C60488BD6488BCEFF15841E0000488BD7498BCEE8D9F1FFFF418844DD08E91103000041BB0500000066413BC37529458BCB4533C0488BD6488BCEFF15511E0000488BD7498BCEE87EF3FFFFF2410F1144DD08E9DC02000041BA0400000066413BC27529458BCA4533C0488BD6488BCEFF151C1E0000488BD7498BCEE8F5F2FFFFF3410F1144DD08E9A7020000B90C000000663BC10F849F0200004533C0440FB7C8488BD6488BCEFF15E41D00004C8D459733D2488BCFFF154D1E00004C8B5D974D895CDD08E969020000B90C000000663BC10F845B0200004533C0440FB7C8488BD6488BCEFF15A61D000085C00F8440020000B803000000488BCE66413944DD000F85D900000049637CDD08FF152F1D0000488B442468460FB70C604533C0488BD6488BCEFF15661D0000488B442468460FB71C60B81100000066443BD8750A41887CDD08E9E9010000B81200000066443BD8750B6641897CDD08E9D3010000B80200000066443BD874EAB813000000448D50F166443BD8750A41897CDD08E9B501000066453BDA7513660F6EC70F5BC0F3410F1144DD08E99C010000B80500000066443BD87514660F6EC7F30FE6C0F2410F1144DD08E97D010000B81500000066443BD8740FB81400000066443BD80F856301000049897CDD08E959010000B80500000066413944DD000F8528010000F2410F1074DD08FF15431C0000460FB70C674533C0488BD6488BCEFF157F1C0000460FB71C67B81100000066443BD87511660F28CE498BCEE85BEBFFFFE9E5FDFFFFB81200000066443BD87511660F28CE498BCEE877EBFFFFE987FDFFFFB80200000066443BD87511660F28CE498BCEE893EBFFFFE96BFDFFFFB81300000066443BD87516660F28CE498BCEE8AFEBFFFF418944DD08E9A700000041BA0400000066453BDA7511660F28CE498BCEE8C5EBFFFF"
		$sBinaryDll &= "E9D7FDFFFFB80300000066443BD8750E660F28CE498BCEE8E1EBFFFFEBC0B81500000066443BD8753533C9660F2F35621F0000761FF20F5C35581F0000660F2F35501F0000730D48B80000000000000080488BC8F2480F2CC64803C1EB10B81400000066443BD8752CF2480F2CC6498944DD08EB20FF15221B0000460FB70C674533C0488BD6488BCEFF155E1B000041BA04000000488B442450488B5C24404A8934E033C04533C04A8904E3EB05488B5C2440488B742450FF442464488B7D9F488B4D8F49FFC48B442460FFC848FFC9E96DF3FFFF488B44246848897424304C8BC348894424288B5424644D8BCF498BCE4C896C2420E822E9FFFF41FF4E0CB827800280E919080000488B4424504C8B44244048894424304889542428EBC8BB04000280EB05BB27800280488B4424504C8B4424408B54246448894424304D8BCF498BCE48897C24284C896C2420E8CAE8FFFFE98E0600004533E4448954245844896424644439277412488BCFE8AFE4FFFF418D4C2408488B38EB1948634587488D0C40488B4567488B00488B7CC8F00FB74CC8E8488BD7E88C0B00000FB7D86689455FB8FFFF0000895C2460663BD87542488D455F4C8D4C24584C8D442464488BD7498BCE4889442420E8F9E6FFFF85C0750A4889742430E9E105000044396424647407BB15400000EB040FB75D5F895C2460B81E000000663BD8740AB81F000000663BD8750E66895C2470BB15000000895C2460488D4DB7FF1575190000453966547441498BCE498BFCE844E6FFFF4885C07544488B4424684C8B4424408B5583488974243048894424284D8BCF498BCE4C896C2420E8C0E7FFFFBB2F800280E97F050000488B4D9F498B7E20E805E5FFFF8BC048C1E003448B6583448B442458488D4DB748894C2438488B4C2468488974243048894C2428440FB7CB488BD0488BCF4489642420FF15D518000033FF418D4424014C8D45AF8D4F0C8D5701897DB38945AFFF15F8180000488D542448488BC84C8BE048894597FF150319000085C00F85E50500008BF748897C245848397DA70F8E8F0400008D4701448D671889455F4898488D3C40488B442448488D0CF8FF157B180000488B4424680FB71C70B8004000006685D80F844D0300006633D8488B4424484533C0488D0CF8440FB7CB488BD1FF15A018000033D26685DB0F84FC0200008D42118BCA663BD88BC20F94C16683FB100F94C00BC874164B8B4427F08A08488B44244841884C0408E9CE020000B80B000000663BD8751C4B8B4427F08BCA38100F95C1488B4424486641894C0408E9B6020000B802000000663BD8750A4B8B4427F00FB708EBDCB812000000663BD874ECB813000000663BD875164B8B4427F08B08488B44244841894C0408E978020000B803000000663BD874E0B80C000000663BD80F8521010000488B4424484B8B5C27F04533C0440FB70B488D0CF8488BD1"
		$sBinaryDll &= "FF15CD170000440FB71BB81E00000066443BD80F858C000000488B442448B9080000006641890C04488B730833C04883CFFF4C8BC68944242833D233C9448BCF4889442420FF15581600004863D88D470348F7E3480F40C7488BC8E81BC6FFFF4183C9FF4C8BC633D233C9895C2428488BF84889442420FF1526160000488BCFFF1505170000488BCF4C8BD8488B4424484D895C0408E808C6FFFF488B742458E9A3010000B81F00000066443BD8752B488B442448B9080000006641890C04488B4B08FF15C21600004C8BD8488B4424484D895C0408E96D010000B800200000664485D8488B44244874186645891C04488B4B08488B44244849894C0408E945010000488B4B08EBF041B81400000066413BD8750A4B8B4427F0488B08EBD5BA15000000663BDA74EC8D42EF663BD80F8485FEFFFF8D42F0663BD874D88D4209663BD87523488B442448448D4AF34533C0488D0CF8488BD1FF15751600004B8B7427F0E9C4FEFFFFB81F000000663BD87525488B44244841B9080000004533C0488D0CF8488BD1FF15461600004B8B4C27F0E92CFFFFFFB808000000663BD8752F4B8B4427F0488B08488B44244849894C04088B5D5F8D43FF4863C8488D0449498D4CC500FF15B8150000E9780100006683FB1A0F843BFFFFFF6683FB257525458BC8488B4424484533C0488D0CF8488BD1FF15DB1500004F8B5C27F0498B0BE9EFFEFFFF6683FB267505448BCAEBD3B909000000663BD90F857D010000488B4424486641890C044B8B4427F0488B08488B44244849894C0408B808000000663BD80F846BFFFFFF8B5D5F8D43FF4863C8488D0449498D0CC7FF1524150000E952FFFFFFB81E0000006643394427E80F858A000000488B442448B9080000004883CFFF6641890C044B8B7427F033C089442428448BCF33D24C8BC633C94889442420FF15FB1300004863D88D470348F7E3480F40C7488BC8E8BEC3FFFF4183C9FF4C8BC633D233C9895C2428488BF84889442420FF15C9130000488BCFFF15A8140000488BCF4C8BD8488B4424484D895C0408E8ABC3FFFF488B742458EB49B81F0000006643394427E8488B4424487524B9080000006641890C044B8B4C27F0FF15651400004C8BD8488B4424484D895C0408EB13488D0CF8488B442450488B14F0FF15AB1400008B455F48FFC64983C418FFC0488974245889455F483B75A70F8C85FBFFFF8B5C24604C8B659733FF488B4C2448FF1500140000B8004000006685D87452488B442448B915000000668908488B45BFE9E8000000488B4424504889442430488B4424684C8B4424408B558348894424284D8BCF498BCE4C896C2420E83CE2FFFFBB2780028041FF4E0C8BC3E9310100000FB7442470B91E000000663BC1757C488B4C2448B808000000897C2428668901488B75BF48897C24204883CFFF33D233C94C8BC6448BCFFF158F1200004863D88D4703"
		$sBinaryDll &= "48F7E3480F40C7488BC8E852C2FFFF4183C9FF4C8BC633D233C9895C2428488BF84889442420FF155D120000488BCFFF153C130000488B4C244848894108488BCFE843C2FFFFEB3BB91F000000663BC17522488B442448B908000000668908488B4DBFFF1508130000488B4C244848894108EB0F488B4C2448488D55B7FF1556130000488D4DB7FF15DC120000498BCCFF1513130000488B742450488B4D6FB80C200000498D56284D8966306641894628FF152213000041FF4E0C498D4E28FF15A4120000488B4424684C8B4424408B5583488974243048894424284D8BCF498BCE4C896C2420E8FDE0FFFF33C04C8D9C2400010000498B5B30498B7338498B7B40410F2873F0498BE3415F415E415D415C5DC3CCB801000000C3CCCC4883EC28B918000000E836C1FFFF488BC833C04885C97405E8A7DBFFFF4883C428C3CCCC4883EC28B9A0000000E812C1FFFF488BC833C04885C97405E8BFD1FFFF4883C428C3CCCC40534883EC20488BD9B9A0000000E8E9C0FFFF488BC833C04885C97408488BD3E84BD2FFFF4883C4205BC3CC40534883EC20488BDAE822C4FFFF488BCB4883C4205BE919C2FFFFCCE993D5FFFFCCCCCCE96BD0FFFFCCCCCCE997C4FFFFCCCCCCE90FD6FFFFCCCCCC48895C2408574883EC20488BF9B9600000008ADAE87BC0FFFF488BC833C04885C9740E4533C9448AC3488BD7E847E7FFFF488B5C24304883C4205FC348895C240848896C24104889742418574883EC30488BE9B960000000418AD9418AF8488BF2E82EC0FFFF488BC833C04885C9741688442428448ACF4C8BC6488BD5885C2420E8F2E1FFFF488B5C2440488B6C2448488B7424504883C4305FC3CC488BC44889580848896810488970184889782041544883EC204C8BE1B928000000418BF9498BF0488BEAE8C9BFFFFF33DB4885C0740B488BC8E88EDAFFFF488BD8488BD5488BCBE8D4DAFFFF8BD7488BCBE88ADCFFFF488BD6488BCBE82BDBFFFF488BD3498BCC488B5C2430488B6C2438488B742440488B7C24484883C420415CE9AEE3FFFFCCCC48895C24084889742410574883EC30488BFA33D2FF15860F000033DB488BF04885C07455B960000000E842BFFFFF4885FF75174885C0743341B10133D2488BC8458AC1E80CE6FFFFEB1E4885C0741C41B1014C8BC733D2488BC8C644242801885C2420E8ECE0FFFF488BD8488BD6488BCBE8D2DCFFFF488BC3488B5C2440488B7424484883C4305FC3CCCCCC48895C24084889742410574883EC40488BDA488BF1488D54246833C9FF15DA10000033FF85C0740433C0EB62488D542430488BCBFF15CA100000488B4C246885C07408488B01FF5010EBDD4C8B4C2430897C24604C8B11488D4424604C8BC6BA01000000488944242041FF5218488B4C2430488B118BD8FF5210488B4C2468488B11FF521085DB0F447C24608BC7488B5C2450488B7424584883C4405F"
		$sBinaryDll &= "C3CCCC40534883EC208BD9488D54243833C9FF154710000085C0740432C0EB1F488B4C24388BD3488B01FF5020488B4C2438488B118BD8FF521085DB0F94C04883C4205BC3CCCC81F9ADDE0000754A534883EC3081FAEFBE00007538B9F5FFFFFFFF15280E00004883642420004C8D4C2440488D159E130000488BC841B822000000488BD8FF15FC0D0000488BCBFF15EB0D00004883C4305BC3CC488B0148FF6008CC488B0148FF6010CC488BC1C34883EC384183C9FF4C8BC1B90008000044894C24284889542420418D5102FF15C40D000083E8024883C438C348895C240848896C24104889742418574883EC20BD08000000488BF2663BCD74058D4502EB3233DB391D9E2E00007623488D3D852D0000488B0F488BD6E892FFFFFF85C07427FFC34803FD3B1D7B2E000072E4B8FFFF0000488B5C2430488B6C2438488B7424404883C4205FC3488D0DF82C00008BC30FB70459EBDC40534883EC20488B014C8D442430488D1543150000488BD9FF1085C07510488B5C2430488BCB488B03FF5040EB28488B034C8D442430488D150B150000488BCBFF1085C0751A488B5C243033D2488B03488BCBFF50284C8B1B488BCB41FF53104883C4205BC3CCCC48895C2408488974241855574154488BEC4883EC7033FF4D8BE0488BF2488BD94885D20F85A80000000F100580140000F30F7F45D8488D55E8488BCBFF152E0E000085C00F8420010000488D55E8488BCBFF15390E000085C00F840B010000488BCBFF15280C000041B904000000413BC10F8EF3000000488D054A11000044894C2428418D51FD4C8BC3B9000800004889442420FF153E0C000083F8020F85C7000000488D552833C9FF15F10D000085C07533488D4B08488D5538FF15E70D0000488B4D2885C07424488B01FF5010EB15488D55D8488BCEFF159A0D000085C00F844FFFFFFF33C0E9F4000000488B553848897DC0488B014C8D45C0FF5030488B4D38488B118BD8FF5210488B4D28488B11FF521085DB75CD488B4DC04C8D45D0488D55D8488B01FF1085C075B8488B5DD04D85E4757A4885F67508488BC3E99D000000B960000000E83ABBFFFF4885C00F84870000004533C94533C0488BD3488BC8E804E2FFFFEB7133C9FF150E0D000083F8017506FF150B0D000033D2488D45C84C8D4DD8448D4201488D4DE84889442420FF151E0D000085C00F8544FFFFFF488B4DC8E8EDFDFFFF488B5DC8EB81B960000000E8CDBAFFFF4885C0741E4533C94D8BC4488BD3488BC840887C242840887C2420E891DCFFFF488BF8488BC74C8D5C2470498B5B20498B7330498BE3415C5F5DC3CCCC48895C24084C894C24205556574154415541564157488D6C24E94881ECA00000004C8BF24C8BE133D233C9498BD94D8BF8FF15690C000033FF4D85FF0F85160100000F10056F120000F30F7F45F7488D5507498BCEFF151D0C000085C00F8428020000"
		$sBinaryDll &= "498BCEFF152C0A000041B904000000413BC10F8EF2000000488D055E0F000044894C2428418D51FD4D8BC6B9000800004889442420FF15420A000083F8020F85C60000004C8BC3498BD7498BCEE853FDFFFF488BF04885C00F85AF03000041BD00000100418BCDE8C1B9FFFF418BCD488BD8488945EFE8B2B9FFFF8D4E6848894567E8A6B9FFFF8D4E18488945DFE89AB9FFFF488D55C74C8BE8488B45DF498BCCC70008000000FF15180A000085C07560488B556741B8FF7F000033C9FF15FA090000488D15C30E0000488BCBFF15E2090000498BD4488BCBFF15D6090000488D15A30E0000488BCBFF15C60900004C8B6567EB2C488D55F7498BCFFF151B0B000085C00F84E1FEFFFF33C0E9FC020000498BD44C8B6567498BCCFF150C090000488D159D0E0000488BCBFF1584090000488B45DF4C896C2448488944244048897C243848897C24304533C94533C0488BD3498BCC897C2428897C2420FF154A090000488B4DEF8BD8E8E7B8FFFF498BCCE8DFB8FFFF85DB0F848E0000008B4D7FB8B80B0000897D6785C98BDF0F44C8B8CDCCCCCCF7E1448BE241C1EC034585E47453498B4D00488D5567FF15F4080000817D6703010000753C4C8B456F498BD7498BCEE8DCFBFFFF488BF04885C075258D480AFF15C3080000FFC3413BDC72C2817D6703010000750C498B4D0033D2FF159F080000498B4D00FF158D080000498B4D08FF1583080000EB03488BF7488B4DDFE83DB8FFFF498BCDE835B8FFFF488BC6E9E5010000448A6D77498BCC4584ED750DBA01000000FF15CE090000EB06FF153E080000488BF04885C00F84B7FEFFFF488D158B0D0000488BC8FF15DA0700004885C0750E488BCEFF15DC070000E994FEFFFF4C8D45E7488D15F40F0000488D4D07FFD085C075DD8BDF4584ED75474C8D45CF8D5002498BCCFF155308000085C07533488B4DCF4533C0498BD4FF154708000085C075058D5802EB1A488B4DCF4533C0498BD4FF1536080000F7D81BDB83E3FE83C303488B4DE74C8D4DD74C8D45F7488B0133D2FF501885C00F848400000085DB7471488B4DCF488D5567488B01FF503885C0755583EB027406FFCB7420EB3C488B4D678B4114448B4910440FB7411A0FB7511889442420FF15D9070000488B4D678B4114448B4910440FB7411A0FB7511889442420FF15C3070000488B4DCF488B5567488B01FF5060488B4DCF488B01FF5010488B4DE7488B01FF5010E9EFFEFFFF85DB740A488B4DCF488B01FF5010488B4DE7488B01FF5010488B4DD7E8A3F9FFFF488B5D6F4885DB752E4584ED7506488B45D7EB5FB960000000E875B6FFFF4885C07442488B55D74533C94533C0488BC8E842DDFFFFEB2BB960000000E852B6FFFF4885C0741F488B55D74533C94C8BC3488BC840887C242840887C2420E815D8FFFF488BF8488BD6488BCFE8FBD3FFFF488BC7488B9C24E00000004881C4A000"
		$sBinaryDll &= "0000415F415E415D415C5F5E5DC30000000000386D000000000000446D000000000000506D000000000000626D000000000000786D000000000000866D0000000000009C6D000000000000AE6D000000000000C26D000000000000CE6D000000000000DE6D000000000000F06D000000000000006E0000000000000E6E000000000000226E0000000000002A6E000000000000406E000000000000526E0000000000005E6E000000000000746E000000000000A46F000000000000986F000000000000B06F00000000000000000000000000000501000000000080B700000000000080A300000000000080BA01000000000080BA00000000000080BB01000000000080920000000000008054000000000000800800000000000080090000000000008002000000000000804A00000000000080190000000000008013000000000000800F000000000000801A000000000000801100000000000080180000000000008017000000000000800C0000000000008007000000000000807D0000000000008085000000000000800A000000000000803300000000000080120100000000008047000000000000803D000000000000808800000000000080080100000000008036000000000000801501000000000080400000000000008000000000000000007C6F00000000000000000000000000003A6F000000000000286F000000000000066F000000000000F66E000000000000E46E000000000000166F0000000000004A6F000000000000B86E000000000000A46E000000000000946E000000000000D06E000000000000000000000000000000000000A48BD54D000000000200000082000000786800007856000000000000A011008001000000EC2C008001000000D41200800100000040120080010000007412008001000000A4120080010000004C260080010000005F005F00640065006600610075006C0074005F005F0000005F004E006500770045006E0075006D0000000000000000005F005F006200720069006400670065005F005F00000000005F005F0070006100720061006D0073005F005F00000000005F005F006500720072006F0072005F005F000000000000005F005F0072006500730075006C0074005F005F00000000005F005F00700072006F007000630061006C006C005F005F0000000000000000005F005F006E0061006D0065005F005F000000000000000000430061006C006C004100720067004100720072006100790000000000000000006813008001000000EC2C008001000000C422008001000000CC2D008001000000EC13008001000000B82300800100000078160080010000004F0062006A0065006300740000000000430072006500610074006500000000004100640064004D006500740068006F00640000007E000000410064006400500072006F007000650072007400790000"
		$sBinaryDll &= "00410064006400440065007300740072007500630074006F00720000000000000041006400640045006E0075006D000000520065006D006F00760065004D0065006D0062006500720000000000000000005F005F00640065006600610075006C0074005F005F00000044260080010000003826008001000000582A0080010000004C260080010000004C26008001000000542600800100000050270080010000005F005F007000740072005F005F000000000000000000000000000000000000007300740072000000770073007400720000000000000000006200730074007200000000000000000063006400650063006C00000000000000000000000000E043F82C008001000000EC2C0080010000007037008001000000CC2D008001000000EC13008001000000983700800100000010380080010000006300620069003A0000000000000000006300620069003A00000000002200000020002F004100750074006F00490074003300450078006500630075007400650053006300720069007000740020002200000000000000000020002F0053007400610072007400530065007200760065007200000000000000446C6C476574436C6173734F626A656374000000000000004C6F6C2E20596F7520666F756E6420746865206561737465722D6567672E200D0A000000000000006F0062006A0065006300740000000000690064006900730070006100740063006800000000000000770070006100720061006D0000000000640077006F00720064005F0070007400720000000000000075006C006F006E0067005F00700074007200000000000000750069006E0074005F0070007400720000000000000000006C0070006100720061006D00000000006C0072006500730075006C00740000006C006F006E0067005F00700074007200000000000000000069006E0074005F007000740072000000680077006E0064000000000000000000680061006E0064006C00650000000000700074007200000062007300740072000000000000000000770073007400720000000000000000007300740072000000680072006500730075006C007400000064006F00750062006C0065000000000066006C006F0061007400000000000000750069006E007400360034000000000069006E00740036003400000000000000760061007200690061006E007400000069006E00740000006C006F006E0067000000000000000000750069006E007400000000000000000075006C006F006E006700000000000000640077006F007200640000000000000077006F007200640000000000000000007500730068006F007200740000000000730068006F007200740000000000000062006F006F006C00000000000000000062006F006F006C00650061006E000000620079007400650000000000000000006E006F006E00650000"
		$sBinaryDll &= "000000000000000004020000000000C0000000000000460000000000000000C0000000000000460100000000000000C0000000000000460A01000000000000C0000000000000468023D57F074E1B10AE2D08002B2EC713525344536F5AD3309A95BD4F86971C0CCA3AB8CC9D000000443A5C446F63756D656E747320616E642053657474696E67735C7472616E636578785C4465736B746F705C56617A6E6520736B72697074655C4175746F49744F626A656374325C7472756E6B5C7836345C52656C656173655C4175746F49744F626A6563742E70646200000001060200063202300109020009720250010602000652023001180A0018640A001854090018340800183214D012C01070010F06000F6407000F3406000F320B70011F0C001F7412001F6411001F3410001F9218F016E014D012C01050011408001464090014540800143407001432107001190A0019740900196408001954070019340600193215C0010903000901880002300000011D0C001D740B001D640A001D5409001D3408001D3219E017D015C001120300126802000462000001190A0019340F00193215F013E011D00FC00D700C600B500114080014640800145407001434060014321070012A0F002A680F002374280023642700233426002301200018F016E014D012C0105000000104010004420000010A04000A3406000A3206700114080014640A00145409001434080014521070010F06000F6409000F3408000F520B70010F06000F640B000F340A000F720B70010D02000D520930010401000462000001150800156414001534120015D20EC00C700B5001210B0021341C002101140015F013E011D00FC00D700C600B500000F86A00000000000000000000866E000000600000D86C00000000000000000000646F0000E0610000B86B000000000000000000006E6F0000C0600000C86C000000000000000000008C6F0000D0610000000000000000000000000000000000000000000000000000386D000000000000446D000000000000506D000000000000626D000000000000786D000000000000866D0000000000009C6D000000000000AE6D000000000000C26D000000000000CE6D000000000000DE6D000000000000F06D000000000000006E0000000000000E6E000000000000226E0000000000002A6E000000000000406E000000000000526E0000000000005E6E000000000000746E000000000000A46F000000000000986F000000000000B06F00000000000000000000000000000501000000000080B700000000000080A300000000000080BA01000000000080BA00000000000080BB01000000000080920000000000008054000000000000800800000000000080090000000000008002000000000000804A00000000000080190000000000008013000000000000800F000000000000801A00000000000080110000"
		$sBinaryDll &= "0000000080180000000000008017000000000000800C0000000000008007000000000000807D0000000000008085000000000000800A000000000000803300000000000080120100000000008047000000000000803D000000000000808800000000000080080100000000008036000000000000801501000000000080400000000000008000000000000000007C6F00000000000000000000000000003A6F000000000000286F000000000000066F000000000000F66E000000000000E46E000000000000166F0000000000004A6F000000000000B86E000000000000A46E000000000000946E000000000000D06E00000000000000000000000000005B056C73747263707957000061056C7374726C656E5700004C0247657450726F6341646472657373000020055769646543686172546F4D756C746942797465006801467265654C6962726172790069034D756C746942797465546F57696465436861720040034C6F61644C69627261727945785700005D01466C75736846696C654275666665727300003405577269746546696C65006B0247657453746448616E646C6500006400436F6D70617265537472696E6757000041034C6F61644C6962726172795700005200436C6F736548616E646C6500CE045465726D696E61746550726F636573730000C004536C65657000E60147657445786974436F646550726F636573730000A80043726561746550726F6365737357000052056C7374726361745700001A024765744D6F64756C6546696C654E616D65570000770147657442696E617279547970655700004B45524E454C33322E646C6C00006C00436F5461736B4D656D4672656500820043726561746546696C654D6F6E696B6572009B0047657452756E6E696E674F626A6563745461626C65001400436F437265617465496E7374616E636500007000436F556E696E697469616C697A6500004200436F496E697469616C697A650000010149494446726F6D537472696E67000A00434C53494446726F6D50726F674944000C00434C53494446726F6D537472696E67004A00436F4C6F61644C696272617279002200436F46726565556E757365644C69627261726965734578006F6C6533322E646C6C004F4C4541555433322E646C6C00004A01537472546F496E7436344578570053484C574150492E646C6C00D30248656170416C6C6F6300D70248656170467265650000510247657450726F63657373486561700000000000000000000000000000000000000000A48BD54D00000000C0700000010000001400000014000000F86F000048700000987000005C4F00004C4F0000644F00007853000070550000044F0000E04E0000BC4E0000905000006C4F0000A84F0000545200005C520000304F0000005200001C510000544F000064520000BC51000008500000D5700000DD700000E7700000F3"
		$sBinaryDll &= "7000000C71000027710000397100004C71000064710000787100008C710000A2710000B1710000C1710000CC710000DC710000EB710000F8710000037200001472000000000100020003000400050006000700080009000A000B000C000D000E000F0010001100120013004175746F49744F626A6563745F5836342E646C6C00416464456E756D004164644D6574686F640041646450726F7065727479004175746F49744F626A6563744372656174654F626A656374004175746F49744F626A6563744372656174654F626A656374457800436C6F6E654175746F49744F626A656374004372656174654175746F49744F626A656374004372656174654175746F49744F626A656374436C61737300437265617465446C6C43616C6C4F626A65637400437265617465577261707065724F626A65637400437265617465577261707065724F626A65637445780049556E6B6E6F776E4164645265660049556E6B6E6F776E52656C6561736500496E697469616C697A65004D656D6F727943616C6C456E7472790052656769737465724F626A6563740052656D6F76654D656D6265720052657475726E5468697300556E52656769737465724F626A65637400577261707065724164644D6574686F640000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011000B000B00020012001200130013001300030003000C00140015000400050013001E001F000800150015001500140014001400140015001500150015000900090000000000000000000000000018680080010000000868008001000000F867008001000000E8670080010000"
		$sBinaryDll &= "00D867008001000000C867008001000000B867008001000000A86700800100000098670080010000008867008001000000786700800100000070670080010000006067008001000000506700800100000040670080010000003067008001000000206700800100000010670080010000000867008001000000F866008001000000E866008001000000E066008001000000D066008001000000C066008001000000B06600800100000098660080010000008866008001000000786600800100000060660080010000004866008001000000306600800100000020660080010000000866008001000000F865008001000000220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000026100000FC680000281000004B100000FC6800004C10000070100000FC6800007010000096100000FC680000AC100000F81000002C6900000411000064110000106A00006C1100009E110000FC680000A01100003D1200000469000040120000731200000C69000074120000A31200000C690000A4120000D31200000C690000D4120000FC120000FC680000FC1200005D1300002C69000068130000EB130000106A0000F8130000FA14000014690000FC140000921500002C69000094150000B5150000FC680000B815000078160000D0690000781600005A1F00003C6900005C1F0000C21F0000D0690000C41F000030200000D069000030200000BC200000D0690000BC20000073210000106A000074210000C122000014690000C4220000B523000058690000B8230000E1240000106A0000E4240000772500006C69000078250000122600006C6900001426000037260000086A00005426000050270000FC68000050270000552A00002C690000582A0000802A0000FC680000802A0000D22A0000106A0000EC2A0000202B0000FC680000282B00008A2B0000106A0000942B0000E22C00006C690000F82C0000CA2D0000106A0000E02D0000342E000084690000342E0000882F000090690000882F0000FE2F0000D0690000003000004D300000106A00005030000085300000AC69000088300000BE300000AC690000C0300000F6300000AC690000F83000002D310000AC6900003031000066310000AC690000683100009D310000AC690000E43100001E330000B869000020330000D1330000D0690000D43300003B340000D06900003C340000B8340000D0690000B834000003350000FC6800000435000051350000FC68000054350000A1350000FC680000A4"
		$sBinaryDll &= "350000EF350000FC680000F03500003B360000FC6800003C36000090360000FC68000090360000E4360000FC680000E43600006D3700002C6900007037000098370000FC680000983700000F380000106A000010380000B34E0000E4690000BC4E0000DE4E0000086A0000E04E0000024F0000086A0000044F00002F4F0000FC680000304F00004B4F0000FC6800006C4F0000A84F0000106A0000A84F0000075000001C6A0000085000008E5000006C6900009050000019510000306A00001C510000BA510000406A0000BC510000FE510000FC6800000052000053520000506A00006852000094520000586A00009452000010530000D06900001053000076530000FC680000785300006E550000606A000070550000FB590000746A00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100100000001800008000000000000000000000000000000100010000003000008000000000000000000000000000000100090400004800000060A000001803000000000000000000000000000000000000180334000000560053005F00560045005200530049004F004E005F0049004E0046004F0000000000BD04EFFE00000100020001000200080002000100020008000000000000000000040000000200000000000000000000000000000076020000010053007400720069006E006700460069006C00650049006E0066006F000000520200000100300034003000390030003400420030000000300008000100460069006C006500560065007200730069006F006E000000000031002E0032002E0038002E0032000000340008000100500072006F006400750063007400560065007200730069006F006E00000031002E0032002E0038002E00320000007A0029000100460069006C0065004400650073006300720069007000740069006F006E0000000000500072006F007600690064006500730020006F0062006A006500630074002000660075006E006300740069006F006E0061006C00690074007900200066006F00720020004100750074006F0049007400000000003A000D000100500072006F0064007500630074004E0061006D006500000000004100750074006F00490074004F0062006A006500630074000000000058001A0001004C006500670061006C0043006F0070007900720069006700680074000000280043002900200054006800650020004100750074006F00490074004F0062006A006500630074002D005400650061006D0000004A00110001004F0072006900670069006E0061006C00460069006C0065006E0061006D00650000004100750074006F00490074004F0062"
		$sBinaryDll &= "006A006500630074002E0064006C006C00000000007A002300010054006800650020004100750074006F00490074004F0062006A006500630074002D005400650061006D00000000006D006F006E006F00630065007200650073002C0020007400720061006E0063006500780078002C0020004B00690070002C002000500072006F00670041006E006400790000000000440000000100560061007200460069006C00650049006E0066006F00000000002400040000005400720061006E0073006C006100740069006F006E00000000000904B00400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006000004000000060A268A270A278A280A288A290A280A388A390A398A3A0A3A8A3B0A370A478A480A488A490A498A4A0A408A510A518A520A528A530A538A5008000004C00000050A058A060A068A070A078A080A088A090A098A0A0A0A8A0B0A0B8A0C0A0C8A0D0A0D8A0E0A0E8A0F0A0F8A000A108A110A118A120A128A130A138A140A148A150A158A1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
		Return $sBinaryDll
	EndFunc
#EndRegion
