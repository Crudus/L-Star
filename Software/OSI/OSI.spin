''***************************************************************************
''* OSI Superboard II Emulator
''* Copyright (C) 2014 Jac Goudsmit
''*
''* Thanks to Vince Briel for the great cooperation! Buy his retro kits at
''* brielcomputers.com after the aliens return him to Earth.
''*
''* TERMS OF USE: MIT License. See bottom of file.                                                            
''***************************************************************************
''
'' This project emulates the Ohio Scientific Superboard II on the L-Star
'' hardware.
''
CON
  _clkmode      = xtal1 + pll16x
  _xinfreq      = 5_000_000

  RAM_SIZE      = 16384         ' Number of RAM bytes to make available
  
OBJ
  hw:           "Hardware"      ' Hardware constants
  clock:        "Clock"         ' Clock generator
  mon_ram:      "Memory"        ' Monitor ROM and base RAM emulation
  basic:        "Memory"        ' BASIC ROM
  video:        "Memory"        ' Video RAM
  'acia:         "OSIacia"       ' ACIA (UART) emulator
  font:         "OSIfont"       ' OSI 256 character font
  'kb:           "OSIkeyboard"   ' OSI keyboard driver
  tv:           "1pinTV256"     ' OSI 1-pin TV driver

PUB Main | screenptr, i

  ' Initialize the clock before starting any cogs that wait for it
  clock.Init(1_000_000)

  'acia.Start
  'kb.Start(hw#pin_KBDATA, hw#pin_KBCLK)
  screenptr := tv.Start(hw#pin_TV, font.GetPtrToFontTable)

  video.StartEx(@screenptr, @screenptr, @screenptr + 1024, $D000, 0)
  basic.StartEx(@BasicRomStart, @BasicRomEnd, @BasicRomEnd, $A000, 0)
  mon_ram.Start(@MonRomStart, @MonRomEndRamStart, @RamEnd)

  clock.Activate

  ' Infinite loop to pump characters through the ACIA and keyboard
  repeat
    i := 0 ' todo 

DAT

BasicRomStart
        file  "OSIBASIC.ROM"
BasicRomEnd

MonRomStart
        file  "SYN600.ROM"
MonRomEndRamStart
        byte  $00[RAM_SIZE]
RamEnd

CON
''***************************************************************************
''*
''* Permission is hereby granted, free of charge, to any person obtaining a
''* copy of this software and associated documentation files (the
''* "Software"), to deal in the Software without restriction, including
''* without limitation the rights to use, copy, modify, merge, publish,
''* distribute, sublicense, and/or sell copies of the Software, and to permit
''* persons to whom the Software is furnished to do so, subject to the
''* following conditions:
''*
''* The above copyright notice and this permission notice shall be included
''* in all copies or substantial portions of the Software.
''*
''* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
''* OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
''* MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
''* IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
''* CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT
''* OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR
''* THE USE OR OTHER DEALINGS IN THE SOFTWARE.
''***************************************************************************