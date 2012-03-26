unit
module Gui
    import Fonts, In, Shape
    export
    % Classes
	GuiElement,
	GuiAbstractButton,
	GuiButton,
	GuiImageButton,
	GuiAbstractFontElement,
	GuiLabel,
	GuiTextBox,
    %
	Update, PreRender, Render,
    %
	addElement,
    %
	newButton,
	newImageButton,
	newLabel,
	newTextBox,
    % Getters
	focus, elements,
	focusedId,
    % Setters
	focusOn

    %%%
    % Types and Constants
    %%%

    const textInsertionPointerFlash := 500

    proc emptyProc
    end emptyProc

    type ElementState : enum (ready, hover, pressed, clicked)

    type GuiElementData :
	record
	    rect : Shape.Rect
	    state : ElementState
	end record

    %%%
    % Root element class
    %%%

    include "Gui/GuiElement.t"

    %%%
    % All Elements
    %%%

    var elements : flexible array 1 .. 0 of ^GuiElement
    var focus : ^GuiElement := nil
    var focusedId := -1

    proc addElement (e : ^GuiElement)
	new elements, upper (elements) + 1
	elements (upper (elements)) := e
	elements (upper (elements)) -> initialize ()
    end addElement

    %%%
    % Focused Element
    %%%

    proc focusOn (element : ^GuiElement)
	if focus not= nil then
	    focus -> isFocused (false)
	end if
	focus := element
	if focus not= nil then
	    element -> isFocused (true)
	    element -> onFocus ()

	    for i : lower (elements) .. upper (elements)
		if elements (i) = focus then
		    focusedId := i
		    exit
		end if
	    end for
	end if
    end focusOn

    % Returns the next possible element starting at the desired id. Does not wrap around.
    fcn getNextFocusFrom (id : int) : ^GuiElement
	var start := (id - lower (elements)) mod sizeof (elements) + lower (elements)


	% Check each element for if it can attain focus.
	for i : start .. upper (elements)
	    if elements (i) -> canHaveFocus then
		result elements (i)
	    end if
	end for

	% No possible focus
	result nil
    end getNextFocusFrom

    % Returns the first element that can be focused on.
    fcn getFirstPossibleFocus () : ^GuiElement
	result getNextFocusFrom (lower (elements))
    end getFirstPossibleFocus

    % Returns the next possible element starting at the desired id. Will wrap around once.
    fcn getNextFocusWrap (id : int) : ^GuiElement
	var nextTarget := getNextFocusFrom (id)
	if nextTarget = nil then
	    result getFirstPossibleFocus ()
	else
	    result nextTarget
	end if
    end getNextFocusWrap

    proc focusOnFirstPossibleElement ()
	focusOn (getFirstPossibleFocus ())
    end focusOnFirstPossibleElement

    proc nextFocus ()
	if focus = nil then
	    focusOnFirstPossibleElement ()
	else
	    focusOn (getNextFocusWrap (focusedId + 1))
	end if
    end nextFocus
    
    %%%
    % Cyrcling methods for main loop.
    %%%

    proc Update ()
	var element : ^GuiElement
	var point := Shape.point (In.mouse.x, In.mouse.y)
	for i : lower (elements) .. upper (elements)
	    element := elements (i)
	    if Shape.pointInRect (point, element -> rect) then
		if In.MousePressed () then
		    focusOn (element)
		    element -> setState (ElementState.pressed)
		elsif In.MouseUp () then
		    element -> setState (ElementState.clicked)
		else
		    element -> setState (ElementState.hover)
		end if
	    elsif focus = element then
		% Still focused or focused but no longer hovering
	    else
		element -> setState (ElementState.ready)
	    end if
	end for

	if In.KeyFired (KEY_TAB) then
	    nextFocus ()
	end if


	% TODO: Fix shifted character input
	if focus not= nil then
	    for c : char
		if In.KeyFired (c) then
		    var k : string := c
		    /*
		     if In.KeyPressed (KEY_SHIFT) then
		     var ascii := ord (k) - 32
		     if 0 <= ascii and ascii < 256 then
		     k := chr (ascii)
		     end if
		     end if
		     */
		    focus -> onFocusKeyFired (k)
		end if
	    end for
	end if
    end Update

    proc PreRender ()
	for i : lower (elements) .. upper (elements)
	    elements (i) -> preRender ()
	end for
    end PreRender

    proc Render ()
	for i : lower (elements) .. upper (elements)
	    elements (i) -> render ()
	end for
	if focus not= nil then
	    Shape.drawRect (focus -> rect, focus -> colourFocused, false)
	end if
    end Render
    
    %%%
    % Built in Element classes
    %%%

    include "Gui/GuiAbstractButton.t"
    include "Gui/GuiButton.t"
    include "Gui/GuiImageButton.t"
    include "Gui/GuiAbstractFontElement.t"
    include "Gui/GuiLabel.t"
    include "Gui/GuiTextBox.t"

    %%%
    % Shortcut util functions for built in element types.
    %%%

    fcn newButton (r : Shape.Rect, p : proc p2) : ^GuiButton
	var gB : ^GuiButton
	new GuiButton, gB
	gB -> setRect (r)
	gB -> setCallOnClick (p)
	result gB
    end newButton

    fcn newImageButton (point : Shape.Point, pic, picHover, picPress : int, p : proc p2) : ^GuiImageButton
	var gIB : ^GuiImageButton
	new GuiImageButton, gIB
	gIB -> setPic (pic)
	gIB -> setPicHover (picHover)
	gIB -> setPicPress (picPress)
	gIB -> setRect (Shape.rect (point.x, point.y, Pic.Width (pic), Pic.Height (pic)))
	gIB -> setCallOnClick (p)
	result gIB
    end newImageButton

    fcn newLabel (text : string, e : ^GuiElement) : ^GuiLabel
	var gL : ^GuiLabel
	new GuiLabel, gL
	gL -> setTarget (e)
	gL -> setText (text)
	gL -> setFontAsTarget ()
	result gL
    end newLabel

    fcn newTextBox (r : Shape.Rect, p : proc p2) : ^GuiTextBox
	var gTB : ^GuiTextBox
	new GuiTextBox, gTB
	gTB -> setRect (r)
	gTB -> alphaNumericKeyMap ()
	result gTB
    end newTextBox
end Gui

