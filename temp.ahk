; Timer GUI
; progress bar 

;Gui, Color, 212121
;Gui +LastFound +AlwaysOnTop -Caption +ToolWindow  ; +ToolWindow avoids a taskbar button and an alt-tab menu item. http://ahkscript.org/docs/misc/Styles.htm
;Gui,Font, s8, Verdana

;Gui, Add, Progress, x10 y10 w300 h18 vIndex c00C6FF Background000000
;Gui, Add, Text, x10 y10 w300 h20 +0x200 cFFFFFF +Center +BackgroundTrans vText , 1 of 100

;WinSet, TransColor, 212121 %transparancy%
;Gui, Show, h55 x1500 y100, Progress.Bar.GUI

;
;
;

VarExist(Var="")        
{       ; * * * Determines a variable existence. * * *
                                ;
	IfEqual, Var,,Return, 0         ; If no parameter, return 0
                                ;
	VarAddr = % & %Var%             ; Obtain pointer to the variable
                                ;
	x := "Var" . Chr(160)           ; x will contain a non-existing variable name
	NonExistent := &%x%             ; Obtain pointer to the non-existing variable
                                ;
	if ( VarAddr = NonExistent ) 
	{  ; Compare both the pointers and
   		Return, 0                    ; if equal, Return 0 to indicate that
    }  ; the variable does not exist 
	else if ( %Var% = "" )         
   	{  ; If Var is empty Return 2
    	Return, 2                 ;  
    }  ;
	Return 1                        ; If above conditions do not apply, Return 1
}       ; to indicate variable exists with data{\rtf1}