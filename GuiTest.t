import
    In in "Modules/In.tu",
    Shape in "Modules/Shape.tu",
    Gui in "Modules/Gui.tu"

%%%
% Frames Per Second Util
%%%


fcn calcFpsDelay (desiredFrames : int) : int
    result 1000 div desiredFrames
end calcFpsDelay

%%%
% Array util function
%%%

%%%
% Util function used for showing Input
%%%

proc charLine (s : string, f : function f2 (c : char) : boolean)
    put s ..
    for c : char
	if f (c) then
	    put c, "" ..
	end if
    end for
    put ""
end charLine

%%%
% Simple procures for use with Gui
%%%

forward proc upValue
forward proc downValue

%%%
% Gui
%%%

proc setupGui
    Gui.addElement (Gui.newButton (Shape.rect (100, 100, 100, 100), upValue))
    Gui.addElement (Gui.newButton (Shape.rect (300, 300, 50, 30), downValue))
    Gui.addElement (
	Gui.newImageButton (
	Shape.point (400, 200),
	Pic.FileNew ("resources/img/imageButton.bmp"),
	Pic.FileNew ("resources/img/imageButtonHover.bmp"),
	Pic.FileNew ("resources/img/imageButtonPress.bmp"),
	downValue)
	)
    var gTB1 := Gui.newTextBox (Shape.rect (200, 10, 200, 30), downValue)
    gTB1 -> setFont ("monotype:30")
    gTB1 -> appendToKeyMap (".!,")
    Gui.addElement (gTB1)
    var gTB2 := Gui.newTextBox (Shape.rect (400, 10, 200, 30), downValue)
    gTB2 -> setFont ("serif:30")
    Gui.addElement (gTB2)
    Gui.addElement (Gui.newLabel ("Test: ", gTB1))


    % All elements are stored in Gui.elements and can be accessed that way.
    % Add the character '@' to all currently added textboxes.
    for i : lower (Gui.elements) .. upper (Gui.elements)
	if objectclass (Gui.elements (i)) >= Gui.GuiTextBox then
	    Gui.GuiTextBox (Gui.elements (i)).appendToKeyMap ("@")
	end if
    end for

    % So you can manually modify it manually (not reccomended.
    % Will Create warnings, but runs fine.
    /*
     new Gui.elements, upper (Gui.elements) + 1
     new Gui.GuiButton, Gui.elements (upper (Gui.elements))
     var gB := Gui.elements (upper (Gui.elements))
     if objectclass (gB) >= Gui.GuiAbstractButton then
     Gui.GuiAbstractButton (gB).setRect (Shape.rect (10, 10, 20, 20))
     Gui.GuiAbstractButton (gB).setCallOnClick (upValue)
     end if
     */

    % You can also create new instances of elements, it
    % will Create warnings, but runs fine.
    /*
     var gB : ^Gui.GuiButton
     new Gui.GuiButton, gB
     gB -> setRect (Shape.rect (10, 10, 20, 20))
     gB -> setCallOnClick (upValue)
     Gui.addElement (gB)
     */

    Gui.addElement (Gui.newButton (Shape.rect (10, 10, 20, 20), upValue))
end setupGui

%%%
% Variables
%%%

var fpsDelay : int
fpsDelay := calcFpsDelay (60)
var value := 0

%%%
% Functions that modify local variables
%%%

body proc upValue
    value += 1
end upValue

body proc downValue
    value -= 1
end downValue

%%%
% Variables
%%%

setupGui ()
var window := Window.Open ("graphics:640;480,nobuttonbar,offscreenonly")
In.Initialize ()

loop
    In.Update ()
    exit when In.KeyDown (KEY_ESC)
    Gui.Update ()


    Gui.PreRender ()
    cls
    put "ESC to Exit", skip
    put "Mouse: (", In.mouse.x, ",", In.mouse.y, ") ", In.mouse.b
    put "    Up: ", In.MouseUp ()
    put "    Pressed: ", In.MousePressed ()
    put "    Down: ", In.MouseDown ()
    put "    DoubleClick: ", In.DoubleClick (500)
    put "    Last Up: ", Time.Elapsed - In.mouseLast.lastUp
    put skip
    put "Keyboard: "
    charLine ("    Fired: ", In.KeyFired)
    put skip
    put "Gui:"
    put "    Value: ", value
    put "    Focused: ", Gui.focus not= nil, " (id = ", Gui.focusedId, ")"

    Gui.Render ()

    View.Update
    delay (fpsDelay)
end loop
Window.Close (window)
