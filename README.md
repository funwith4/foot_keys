# foot_keys
Buttons you click with your feet. Designed to control the Autoscroll feature on Ultimate Guitar (www.ultimate-guitar.com).

## Overview

I'm learning guitar and trying to play along with the tabs on ultimate-guitar.com. I was becoming frustrated because I was constantly forced to stop strumming to adjust the scroll speed or pause it. I decided to make a foot operated keyboard so controlling the scroll wouldn't interrupt my playing.

## Required Materials

  * 3d printer for case.
  * Arduino Micro (to deliver key-presses via usb).
  * Micro-usb cord (to connect computer to arduino micro).
  * Four buttons (12.5mm x 12.5mm), for example:

     - yellow &rarr; "slow"
     - green &rarr; "faster/start"
     - red &rarr; "start/stop autoscroll"
     - blue &rarr; "start/stop video"

  * 90&deg; male header (or solder onto the board, straight headers are too tall).
  * Easily bendable wire.
  * Shrink-wrap tubes, liquid electrical tape. [or the like]
  * Soldering iron, etc.
  * Hot glue gun for assembly.
  * Non-skid mat so it doesn't slide around the floor. [optional]

## Instructions

  1. Prepare Arduino Micro

     a. Solder 6pin header spanning pins GND,2,3,4,5.
     b. Upload .ino file via Arduino IDE.

  2. Prepare buttons

     a. Each button gets one `GND` wire and one `+` wire.
     b. Solder the wires to the button leads (be sure to choose the leads that make the connection when pressed).
     c. Leave enough wire to comfortably work with when the button is locked in.
        * The `+` wire will connect to the pin on the Arduino.
	* The `GND` wires will be connected together, then connected to the Arduino's GND pin.
     d. Thread the wires through the holes for the leads in the button mount.

  3. Prepare Case

     a. Print two each of button_case_top and button_case_bottom.

        * I use supports when printing the button_case_bottom, due to the overhang of the button mount.
        * I always oriented the printing with the flattest-face against the plate.

     b. Print wedge_top and wedge_bottom.

  3. Assemble

     a. The Arduino can be glued to the bracket in either end-case. I used the left.
     b. The buttons should be glued down into the brackets.
     b. The wires from the opposite end-case should be thread through the holes on the sides of the top pieces and into the case with the Arduino.
     c. The buttons `+` wire, from left to right, should connect to the pin 2-5. (I used shrink tubes here.)
        * This pin assignment could be re-mapped in hardware or software.
     d. The `GND` wires should be connected together and then connected to the `GND` pin. (I used liquid electrical tape here.)
     e. I hot-glued some of the wires against the case to keep them out of the way of the buttons.
     f. The tops gets hot-glued to the bottoms.
     g. The wedge gets hot-glued between the two button cases.
     h. The non-skid layer gets hot-glued to the bottom.
    

## Other Notes

  * _Why are there holes all over it?_

    I have problems with my 3d-prints warping. The holes help relieve the stress of the piece and the pieces don't warp. An added bonus is that it saves material. The main drawback is that it's incompatible with spilled beverages.

  * _Why not build it as one piece?_

    I wanted four buttons, spread far enough apart that I could sloppily step on them individually. I only have a 6" bed on my 3D printer, so this meant I had to break it up. The final shape just evolved, mostly out of my reluctance to waste filament by printing many revisions.

  * _Sometimes some things don't work_

    Focus needs to be in the autoscroll's window, so at least in the current version of ultimate-guitar (Mar 2021), you cannot control both the autoscroll and the embedded video without a click. Solving that reliably is beyond the scope of a macro keyboard (I think).

  * _The higher the button sits, the better._

    I found it hard to use when the button was inlaid deep in the recess of the button hole. It registered the clicks fine, but I find that I appreciate the tactile feedback from high buttons. It's easier to recognize that you're above the button.

