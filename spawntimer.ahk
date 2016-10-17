; spawntimer v0.1
;
; code gathered from various sources
; hacking and improvements by: rZr/opicr0n
;

#NoEnv
#Persistent ; keep running due to timers
#SingleInstance, Force
#Include timer.ahk
#include circleprogress.ahk

; #include mutesound.ahk
; add mixer to windows 7 by playing empty wave
; SoundPlay, sounds\void.wav, Wait
; SetAutoHotkeyVol(10)

Menu, Tray, NoStandard
Menu, Tray, Add, Toggle primary timer on/off, _t1Toggle
Menu, Tray, Add, Toggle secondary timer on/off, _t2Toggle
Menu, Tray, Add, &Reload, _reload
Menu, Tray, Add, E&xit, _exit

; tray icon
Menu, Tray, Icon, gfx\timer.ico, 0


;------------------------------------------------------------------
; Add your games window class name to this list (use windowspy)
;------#GAMES#--------------------------------------------------

;GroupAdd,gamewindow ,ahk_class CoD4         ;COD 4: MW
;GroupAdd,gamewindow ,ahk_class CoD-WaW      ;COD 5: WAW
;GroupAdd,gamewindow ,ahk_class IW4          ;COD 6: MW2
;GroupAdd,gamewindow ,ahk_class CoDBlackOps  ;COD 7: BO
;GroupAdd,gamewindow ,ahk_class IW5          ; COD 8: MW3
GroupAdd,gamewindow ,ahk_class LaunchUnrealUWindowsClient   ;DB

;------------------------------------------------------------------
;Maps and timings
;------#INFO#------------------------------------------------------
;oData := {	trainyard:	{ 	1: 	{part:	1,	time: 4, 	name: "#1: left bridge"}
;		,					2:	{part:	1,	time: 6, 	name: "#1: right bridge"}
;		,					3:	{part:	1,	time: 10, 	name: "#1: tank"}
;,					4:	{part:	2,	time: 6, 	name: "#2: ammo"}
;		,					5:	{part:	2,	time: 10, 	name: "#2: tunnel"}}        
;        ,   chapel:		{ 	1: 	{time: 2, 	name: "#1: left bridge"}}}

;CircleProgressSpawn1 := new CircleProgressClass({ X: 45, Y: 895, BackgroundColor: "", BarBGColor: "33eeeeee", BarColor: "ffF2FF00", TextColor: "eeFFFFFF", BarThickness: 4, BarDiameter: 70})
;CircleProgressSpawn1.Update(100, oData[j, k].name, "")		

CreateSubProgress(loopX=38, loopY=885, loopDeg=86)
{
	global CircleProgressSub := []
	loopIndex := 0

	Loop, 5
	{
		CircleProgressSub[loopIndex] := new CircleProgressClass({ X: loopX, Y: loopY, BackgroundColor: "", BarBGColor: "", TextRendering: "", BarColor: "dd00C6FF", TextColor: "eeFFFFFF", BarThickness: 4, BarDiameter: loopDeg})	
		
		; x - 7 ; y - 10 ; degrees + 15
		loopX -= 7	
		loopY -= 10
		loopDeg += 15
		loopIndex ++

		;ToolTip, %loopIndex% %loopX%
		;Sleep 500
	}

}

; maps
; attacking / defending

mapPosition := "ATTACK" ; or "DEFEND"
mapName := "CHAPEL" ; or "UNDERGROUND", "BRIDGE", "TRAINYARD", "TERMINAL"

;mapData := {	chapel:	{ 	1: 	{time: 24, 	name: "BRIDGE L"}
;,								2:	{time: 22, 	name: "BRIDGE R"}
;,								3:	{time: 21, 	name: "TANK"}		
;,								4:	{time: 20, 	name: "AMMO"}
;,								5:	{time: 18, 	name: "NOOBNESS"}
;,								6:	{time: 17, 	name: "ENEMIE"}
;,								7:	{time: 16, 	name: "CARGO"}
;,								8:	{time: 15, 	name: "TUNNEL"}}}
      

;------------------------------------------------------------------
;#IfWinActive ahk_group gamewindow
;------#INFO#------------------------------------------------------

spawnTime := 25000

; read configuration
ScriptName := A_ScriptName
StringReplace, ScriptName, ScriptName, .ahk,, All
StringReplace, ScriptName, ScriptName, .exe,, All

alarmTime := 0
beep1Time := 0
beep2Time := 0
beepSound := ""
alarmSound := ""
decreaseSound := ""
increaseSound := ""

goSub, _read

SetTimer, displayTimer, 100
SetTimer, audioTimer, 100

;CircleProgressSpawn1 := new CircleProgressClass({ X: 50, Y: 900, BackgroundColor: "", BarColor: "dd00C6FF", TextColor: "eeFFFFFF", BarThickness: 4, BarDiameter: 60})
;CircleProgressSpawn1 := new CircleProgressClass({ X: 45, Y: 895, BackgroundColor: "", BarColor: "ffF2FF00", TextColor: "eeFFFFFF", BarThickness: 4, BarDiameter: 70})
;CircleProgressSpawn2 := new CircleProgressClass({X: 150, Y: 895, BackgroundColor: "", BarColor: "bb00C6FF", TextColor: "eeFFFFFF", BarThickness: 4, BarDiameter: 70})


; eeeeee gray
; E81717 red
; F2FF00 yellow
; 00C6FF blue

audioTimer:
	if (Timer("spawntimer1","Finish") > 0)
	{
		timeLeft := Abs(Timer("spawntimer1","Left"))
		
		if (TimeLeft > 3199 && TimeLeft < beep2Time)
			SoundPlay, %beepSound%, Wait

		if (TimeLeft > 2199 && TimeLeft < beep1Time)
			SoundPlay, %beepSound%, Wait

		if (TimeLeft > 1199 && TimeLeft < alarmTime)
			SoundPlay, %alarmSound%, Wait

		;if (TimeLeft > 199 && TimeLeft < 399)
		;	SoundPlay, sounds\buzzer_x.wav, Wait
	}
Return


displayTimer:
	;test := Timer("spawntimer1","DONE")
	;ToolTip, %test%
	;test := Timer("spawntimer1","FINISH")
	;ToolTip, %test%

	; 
	;	Timer #1 [yellow left]
	;

	if (Timer("spawntimer1","DONE") && Timer("spawntimer1","Finish") > 0)
		Timer("spawntimer1", (spawnTime-10))	
	
	;if (IsObject(Timer["spawntimer1"]))
	if (Timer("spawntimer1","Finish") > 0)
	{
		;timeLeft := Round(Abs(Timer("spawntimer1","Left") / 1000), 0)
		;timeProgress := Round((100 / (spawnTime/1000)) * timeLeft, 0)
		
		timeLeft := Abs(Timer("spawntimer1","Left") / 1000)
		timeProgress := (100 / (spawnTime/1000)) * timeLeft
		timeRound := Round(timeLeft, 0)
		
		;if (timeLeft <= 3)
		;	CircleProgressSpawn1.Update(timeProgress, "`nSPAWN`n`n" timeRound, "FFE81717")			
		;else		
			;CircleProgressSpawn1.Update(timeProgress, "SPAWN [" timeRound "]", "")		
			CircleProgressSpawn1.Update(timeProgress, "", "", "[" timeRound "]")		
			;CircleProgressSpawn1sub2.Update(timeProgress-80, "BRIDGE", "")		
			;CircleProgressSpawn2.Update(timeProgress, "`n`n[" timeLeft "]", "")				

		; sub timers
		subTimerCount := 0

		; loop maps
		for loopMapName, ele in mapData 
		{				
			StringLower, tmpMapName, mapName

			; if current map selected
			if (tmpMapName == loopMapName)			
			{

				; loop map timings
				for k, ele in mapData[loopMapName] 
				{
					timeCheck := timeLeft - mapData[loopMapName, k].time

					if (timeCheck > 0 && timeCheck < 3)
					{				
						subTimeProgress := (100 / (spawnTime/1000)) * timeCheck

						; loop circles
						foundTimer := false
						loopIndex := 0
						timerSlot := ""
						emptySlot := ""
						found := false

						Loop, 5						
						{
							; store first empty slot
							if (emptySlot = "" && CircleProgressSub[loopIndex].timer = "")
								emptySlot := loopIndex

							; find current timer in slots
							if (CircleProgressSub[loopIndex].timer = subTimerCount)
							{
								timerSlot := loopIndex
								found := true
								break
							}

							;ToolTip, %loopIndex%
							loopIndex ++
							;Sleep, 500
						}

						if (found = false)
						{
								timerSlot := emptySlot
								CircleProgressSub[timerSlot].timer := subTimerCount
						}

						; if not already in circle put in first available slot
						CircleProgressSub[timerSlot].Update(subTimeProgress, mapData[loopMapName, k].name, "")						
						
					} else {
						
						; if timed out but slot still occupied
						loopIndex := 0
						Loop, 5						
						{
							; find current timer in slots
							if (CircleProgressSub[loopIndex].timer = subTimerCount)
							{								
								CircleProgressSub[loopIndex].timer := ""
								CircleProgressSub[loopIndex].Clear()
							}
							loopIndex ++
						}

					}

					subTimerCount ++
				}
			}
		}
	}


	; 
	;	Timer #2 [blue right]
	;

	if (Timer("spawntimer2","DONE") && Timer("spawntimer2","Finish") > 0)
		Timer("spawntimer2", (spawnTime-10))			

	;if (IsObject(Timer["spawntimer2"]))
	if (Timer("spawntimer2","Finish") > 0)	
	{
		;timeLeft := Round(Abs(Timer("spawntimer2","Left") / 1000), 0)
		;timeProgress := Round((100 / (spawnTime/1000)) * timeLeft, 0)

		timeLeft := Abs(Timer("spawntimer2","Left") / 1000)
		timeProgress := (100 / (spawnTime/1000)) * timeLeft
		timeRound := Round(timeLeft, 0)

		;if (timeLeft <= 3)
			;CircleProgressSpawn2.Update(timeProgress, "`nSAFE!`n`n" timeRound "", "") ;FF0DFF00
		;	CircleProgressSpawn2.Update(timeProgress, "`nSAFE!`n`n" timeRound "", "DD0DFF00") 
		;else		
			CircleProgressSpawn2.Update(timeProgress, "", "", "<" timeRound ">")
			;CircleProgressSpawn1.Update(timeProgress, "<" timeLeft ">`n`n`n", "")
	}
Return


*!WheelUp::
	if (Timer("spawntimer1","Finish") > 0)
	{
		Timer("spawntimer1", "Minus")
		SoundPlay, %decreaseSound%, Wait
	}
Return

*!WheelDown::
	if (Timer("spawntimer1","Finish") > 0)
	{
		Timer("spawntimer1", "Plus")
		SoundPlay, %increaseSound%, Wait
	}
Return

;~*!WheelUp::
;	Timer("spawntimer1", "Plus")
;Return
;
;~*!WheelDown::
;	Timer("spawntimer1", "Minus")
;Return
DoubleRightClick()
{
  SystemDoubleClickTime := DllCall("GetDoubleClickTime")
  KeyWait, RButton, U
  Sleep 10
  KeyWait, RButton, D, T0.%SystemDoubleClickTime%
  ;KeyWait, RButton, D, T0.1
  If ErrorLevel = 0
    Return True 
  Else 
    Return False
}

$*!RButton::
	if DoubleRightClick()
	{		
		global mapName

		if (mapName = "CHAPEL")
			mapName := "UNDERGROUND"
		else if (mapName = "UNDERGROUND")
			mapName := "BRIDGE"
		else if (mapName = "BRIDGE")
			mapName := "TRAINYARD"
		else if (mapName = "TRAINYARD")
			mapName := "TERMINAL"
		else if (mapName = "TERMINAL")
			mapName := "CHAPEL"


		mapNameSound := "sounds/map_" mapName ".wav"
		StringLower, mapNameSound, mapNameSound

		;toolTip, %mapNameSound%
		SoundPlay, %mapNameSound%, Wait
		
	}
Return

DoubleClick()
{
  SystemDoubleClickTime := DllCall("GetDoubleClickTime")
  KeyWait, LButton, U
  Sleep 10
  KeyWait, LButton, D, T0.%SystemDoubleClickTime%
  ;KeyWait, LButton, D, T0.1
  If ErrorLevel = 0
    Return True 
  Else 
    Return False
}

$*!LButton::
	if DoubleClick()
	{
		global mapPostion
		mapPosition := mapPosition = "ATTACK" ? "DEFENCE" : "ATTACK"
		
		if (mapPosition = "ATTACK")
			SoundPlay, sounds\voice_attack.wav, Wait
		else 
			SoundPlay, sounds\voice_defend.wav, Wait
	}
Return

_t1Toggle:
$*!XButton1::
	if (Timer("spawntimer1","Finish") > 0)
	{
		Timer("spawntimer1", "Unset")
		;CircleProgressSpawn1.Clear()
		CircleProgressSpawn1=""
		CircleProgressSub=""
	} else {
		Timer("spawntimer1", spawnTime)		
		CircleProgressSpawn1 := new CircleProgressClass({ X: 45, Y: 895, BackgroundColor: "", BarBGColor: "33eeeeee", BarColor: "ffF2FF00", TextColor: "eeFFFFFF", BarThickness: 4, BarDiameter: 70})
		CreateSubProgress()
		SoundPlay, %startSound%, Wait
	}
	;send {blind}
Return

_t2Toggle:
$*!XButton2::
	if (Timer("spawntimer2","Finish") > 0)
	{
		Timer("spawntimer2", "Unset")
		;CircleProgressSpawn2.Clear()
		CircleProgressSpawn2=""
	} else {		
		Timer("spawntimer2", spawnTime)
		CircleProgressSpawn2 := new CircleProgressClass({X: 150, Y: 895, BackgroundColor: "", BarColor: "bb00C6FF", TextColor: "eeFFFFFF", BarThickness: 4, BarDiameter: 70})
	}
	;send {blind}
Return

_read:
  IniRead, spawnTime, %ScriptName%.ini, Timer, spawntime

  IniRead, alarmTime, %ScriptName%.ini, Alerts, alarm
  IniRead, beep1Time, %ScriptName%.ini, Alerts, beep1
  IniRead, beep2Time, %ScriptName%.ini, Alerts, beep2

  IniRead, beepSound, %ScriptName%.ini, Sounds, beep
  IniRead, alarmSound, %ScriptName%.ini, Sounds, alarm
  IniRead, increaseSound, %ScriptName%.ini, Sounds, increase
  IniRead, decreaseSound, %ScriptName%.ini, Sounds, decrease
  IniRead, startSound, %ScriptName%.ini, Sounds, start
  
  ;IniRead, x_id, %ScriptName%.ini, Main, x_id, %x_id%
  ;IniRead, x_alpha, %ScriptName%.ini, Main, x_alpha, %x_alpha%
  ;IniRead, PosX, %ScriptName%.ini, Main, PosX, %PosX%
  ;IniRead, PosY, %ScriptName%.ini, Main, PosY, %PosY%
  ;IniRead, Center_X, %ScriptName%.ini, Main, Center_X, %Center_X%
  ;IniRead, Center_Y, %ScriptName%.ini, Main, Center_Y, %Center_Y%
  ;OCX := Center_X + PosX
  ;OCY := Center_Y + PosY
Return

_reload:
	Reload

_exit:
	ExitApp

GuiEscape:
	ExitApp