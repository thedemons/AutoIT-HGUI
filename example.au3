
#include <HGUI.au3>


$GUI = _GUICreate("HGUI Test", 700, 500)

; color and label

;~ _GUICtrlCreateLabel($text, $x, $y, $w = -1, $h = -1, $bkColor = -2, $textColor = 0xffffff)
_GUICtrlCreateLabel("this is some text", 320, 90)

_GUICtrlCreateLabel("this is some text with red background", 320, 120, -1, -1, 0xCC0000)

_GUICtrlCreateLabel("this is some text with blue background", 320, 150)
_GUICtrlSetBkColor(-1, 0x0000CC) ; _GUICtrlSetBkColor($ctrl, $color, $autoHover = True) [$autoHover = auto select hover and click color]

_GUICtrlCreateLabel("this is some text with yellow color", 320, 180, -1, -1, -2, 0xFFFF00)


; input
;~ _GUICtrlCreateInput($text, $x, $y, $w, $h, $bkColor =, $textColor =)
_GUICtrlCreateInput("", 40, 90, 250, 30)
_GUICtrlSetPlaceHolder(-1, "username")

_GUICtrlCreateInput("", 40, 130, 250, 30, 0xDE4094, 0x88C200)
_GUICtrlSetPlaceHolder(-1, "input with gay color...")


; button and box
;~ _GUICtrlCreateButton($text, $x, $y, $w, $h, $bkColor = $cBlue, $textColor = 0xffffff)
$btntest = _GUICtrlCreateButton("Click Me!", 40, 180, 250, 50)

$btn = _GUICtrlCreateButton("Button with box", 40, 250, 250, 50)
$box = _GUICtrlCreateBox(40, 250, 250, 50, 0xFFFFFF) ; x, y, w, h, color
_GUICtrlSetAttach($btn, $box) ; hover button will also hover the box


$btn2 = _GUICtrlCreateButton("Button attached to picture", 40, 320, 250, 50, 0x11CC11) ; red color
$pic = _GUICtrlCreatePic("c:\Program Files (x86)\AutoIt3\Examples\GUI\Torus.png", 320, 250)

_GUICtrlSetAttach($btn2, $pic) ; hover button will also hover the picture, but hover the picture does not hover the button

GUISetState()

While 1
	Switch GUIGetMsg()
		Case -3
			Exit
		Case $btntest

			; you can use the return value from all the _GUICtrlCreate functions as normal
			GUICtrlSetData($btntest, "KIMOCHI")
	EndSwitch
WEnd
