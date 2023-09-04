addi $duration, $r0, 5
addi $r23, $r0, 2
addi $r24, $r0, 3
addi $r25, $r0, 4
addi $r26, $r0, 5
addi $r27, $r0, 6
addi $r28, $r0, 7
addi $r29, $r0, 8


checkButtons:
# Check home press
addi $r5, $r0, 7
bne $button, $r5, next1
jal resetButtonReg
jal turnOnIdleScreen
# Check edit saves press
next1:
addi $r5, $r0, 1
bne $button, $r5, next2
jal resetButtonReg
j turnOnSaveEditScreen
# Check enter press
next2:
addi $r5, $r0, 6
bne $button, $r5, next3
jal resetButtonReg
j pressedEnter
# Check delete press
next3:
addi $r5, $r0, 5
bne $button, $r5, next4
jal resetButtonReg
j pressedDelete
# Press edit clock
next4:
addi $r5, $r0, 8
bne $button, $r5, next5
jal resetButtonReg
addi $screen, $r0, 5
j pressedEditClock
# Check for save triggers
next5:
addi $r5, $r0, 9
bne $button, $r5, next6
bne $screen, $r0, next6
jal resetButtonReg
jal triggerFeed
j endCheckButtons
next6:
bne $currS, $r0, endCheckButtons
j checkSaves
endCheckButtons:
j checkButtons


checkSaves:
bne $currH, $hour1, checkSecondSave
bne $currM, $min1, checkSecondSave
bne $currAM, $am1, checkSecondSave
jal triggerFeed
checkSecondSave:
bne $currH, $hour2, checkThirdSave
bne $currM, $min2, checkThirdSave
bne $currAM, $am2, checkThirdSave
jal triggerFeed
checkThirdSave:
bne $currH, $hour3, endCheckButtons
bne $currM, $min3, endCheckButtons
bne $currAM, $am3, endCheckButtons
jal triggerFeed
j endCheckButtons

triggerFeed:
addi $screen, $r0, 6
addi $r8, $time, 0
addi $motor, $r0, 1
feedLoop:
sub $r7, $time, $r8
bne $r7, $duration, feedLoop
addi $motor, $r0, 0
addi $screen, $r0, 0
jr $r31


turnOnIdleScreen:
addi $screen, $r0, 0
jr $r31

turnOnSaveEditScreen:
addi $screen, $r0, 4
j endCheckButtons

pressedEditClock:
## Check hour increase
bne $button, $r23, nextEditClock1 
jal resetButtonReg
addi $r6, $r0, 12
blt $currH, $r6, skipSetClockHourZero
addi $currH, $r0, 0
skipSetClockHourZero:
addi $currH, $currH, 1
## Check minute increase
nextEditClock1:
bne $button, $r24, nextEditClock2
jal resetButtonReg
bne $currH, $r0, skipClockFix
addi $currH, $r0, 12
skipClockFix:
addi $r6, $r0, 59
blt $currM, $r6, skipSetClockMinZero
addi $currM, $r0, 0
j nextEditClock2
skipSetClockMinZero:
addi $currM, $currM, 1
## Check amp/pm toggle
nextEditClock2:
bne $button, $r25, nextEditClock3
jal resetButtonReg
bne $currAM, $r0, toggleClockAM
addi $currAM, $r0, 1
j nextEditClock3
toggleClockAM:
addi $currAM, $r0, 0
## Check enter
nextEditClock3:
bne $button, $r27, pressedEditClock
jal resetButtonReg
jal turnOnIdleScreen
j checkButtons


pressedEnter:
addi $r5, $r0, 4
bne $screen, $r5, enterNext
j pressedEnterSaveScreen
enterNext:
addi $r5, $r0, 0
bne $screen, $r5, endCheckButtons
j pressedEnterIdleScreen


pressedEnterIdleScreen:
addi $r5, $r0, 5
bne $duration, $r5, enterIdleNext1
addi $duration, $r0, 8
j endCheckButtons
enterIdleNext1:
addi $r5, $r0, 8
bne $duration, $r5, enterIdleNext2
addi $duration, $r0, 11
j endCheckButtons
enterIdleNext2:
addi $duration, $r0, 5
j endCheckButtons


pressedDelete:
addi $r5, $r0, 4
bne $screen, $r5, endCheckButtons
j pressedDeleteSaveScreen

pressedDeleteSaveScreen:
bne $hour3, $r0, deleteThirdSave
bne $hour2, $r0, deleteSecondSave
bne $hour1, $r0, deleteFirstSave
j endCheckButtons

deleteFirstSave:
addi $hour1, $r0, 0
addi $min1, $r0, 0
addi $am1, $r0, 0
j endCheckButtons

deleteSecondSave:
addi $hour2, $r0, 0
addi $min2, $r0, 0
addi $am2, $r0, 0
j endCheckButtons

deleteThirdSave:
addi $hour3, $r0, 0
addi $min3, $r0, 0
addi $am3, $r0, 0
j endCheckButtons

pressedEnterSaveScreen:
bne $hour1, $r0, enterSaveNext1
addi $screen, $r0, 1
j editFirstSave
enterSaveNext1:
bne $hour2, $r0, enterSaveNext2
addi $screen, $r0, 2
j editSecondSave
enterSaveNext2:
bne $hour3, $r0, endCheckButtons
addi $screen, $r0, 3
j editThirdSave


editFirstSave:
## Check hour increase
bne $button, $r23, nextEditFirst1 
jal resetButtonReg
addi $r6, $r0, 12
blt $hour1, $r6, skipSetHourZero1
addi $hour1, $r0, 0
skipSetHourZero1:
addi $hour1, $hour1, 1
## Check minute increase
nextEditFirst1:
bne $button, $r24, nextEditFirst2 
jal resetButtonReg
bne $hour1, $r0, skipFirstFix
addi $hour1, $r0, 12
skipFirstFix:
addi $r6, $r0, 59
blt $min1, $r6, skipSetMinZero1
addi $min1, $r0, 0
j nextEditFirst2
skipSetMinZero1:
addi $min1, $min1, 1
## Check amp/pm toggle
nextEditFirst2:
bne $button, $r25, nextEditFirst3
jal resetButtonReg
bne $am1, $r0, toggleAM1
addi $am1, $r0, 1
j nextEditFirst3
toggleAM1:
addi $am1, $r0, 0
## Check enter
nextEditFirst3:
bne $button, $r27, editFirstSave
jal resetButtonReg
addi $screen, $r0, 4
j checkButtons


editSecondSave:
## Check hour increase
bne $button, $r23, nextEditSecond1 
jal resetButtonReg
addi $r6, $r0, 12
blt $hour2, $r6, skipSetHourZero2
addi $hour2, $r0, 0
skipSetHourZero2:
addi $hour2, $hour2, 1
## Check minute increase
nextEditSecond1:
bne $button, $r24, nextEditSecond2 
jal resetButtonReg
bne $hour2, $r0, skipSecondFix
addi $hour2, $r0, 12
skipSecondFix:
addi $r6, $r0, 59
blt $min2, $r6, skipSetMinZero2
addi $min2, $r0, 0
j nextEditSecond2
skipSetMinZero2:
addi $min2, $min2, 1
## Check amp/pm toggle
nextEditSecond2:
bne $button, $r25, nextEditSecond3
jal resetButtonReg
bne $am2, $r0, toggleAM2
addi $am2, $r0, 1
j nextEditSecond3
toggleAM2:
addi $am2, $r0, 0
## Check enter
nextEditSecond3:
bne $button, $r27, editSecondSave
jal resetButtonReg
addi $screen, $r0, 4
j checkButtons


editThirdSave:
## Check hour increase
bne $button, $r23, nextEditThird1 
jal resetButtonReg
addi $r6, $r0, 12
blt $hour3, $r6, skipSetHourZero3
addi $hour3, $r0, 0
skipSetHourZero3:
addi $hour3, $hour3, 1
## Check minute increase
nextEditThird1:
bne $button, $r24, nextEditThird2 
jal resetButtonReg
bne $hour3, $r0, skipThirdFix
addi $hour3, $r0, 12
skipThirdFix:
addi $r6, $r0, 59
blt $min3, $r6, skipSetMinZero3
addi $min3, $r0, 0
j nextEditThird2
skipSetMinZero3:
addi $min3, $min3, 1
## Check amp/pm toggle
nextEditThird2:
bne $button, $r25, nextEditThird3
jal resetButtonReg
bne $am3, $r0, toggleAM3
addi $am3, $r0, 1
j nextEditThird3
toggleAM3:
addi $am3, $r0, 0
## Check enter
nextEditThird3:
bne $button, $r27, editThirdSave
jal resetButtonReg
addi $screen, $r0, 4
j checkButtons


resetButtonReg:
addi $button, $r0, 0
bne $button, $r0, resetButtonReg
jr $r31 
