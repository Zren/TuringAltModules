class GuiTextBox
    inherit GuiAbstractFontElement
    import Shape, Fonts,
	textInsertionPointerFlash
    export
    % Getters
	
    % Setters
	
    %
	alphaNumericKeyMap, appendToKeyMap
	
    var keyMap := ""
    var value : string := ""
    var insertIndex := 0
    var textRender : int := -1
    var textOffset := 0

    proc alphaNumericKeyMap ()
	keyMap := " "
	for i : 48 .. 57
	    keyMap += chr (i)
	end for
	for i : 65 .. 90
	    keyMap += chr (i)
	end for
	for i : 97 .. 122
	    keyMap += chr (i)
	end for
    end alphaNumericKeyMap

    proc appendToKeyMap (s : string)
	keyMap += s
    end appendToKeyMap

    body proc onHover ()
    end onHover

    body proc onPress ()
    end onPress

    body proc onClick ()

    end onClick

    body proc onFocus ()
    end onFocus

    proc addText (s : char)
	if length (value) = 0 then
	    % Empty Text
	    value := s
	elsif insertIndex = 0 then
	    % Pointer at start
	    value := s + value
	elsif insertIndex = length (value) then
	    % Pointer at end
	    value += s
	else
	    % Pointer in the middle
	    value := value (1 .. insertIndex)
		+ s
		+ value (insertIndex + 1 .. length (value))
	end if
	insertIndex += 1
    end addText

    proc onBackspace ()
	if length (value) = 0 then
	    % Empty Text

	elsif insertIndex = 0 then
	    % Pointer at start

	elsif insertIndex = length (value) then
	    % Pointer at end
	    value := value (1 .. length (value) - 1)
	    insertIndex -= 1
	else
	    % Pointer in the middle
	    value := value (1 .. insertIndex - 1)
		+ value (insertIndex + 1 .. length (value))
	    insertIndex -= 1
	end if
    end onBackspace

    body proc onFocusKeyFired (k : char)
	if k = KEY_BACKSPACE then
	    onBackspace ()
	elsif k = KEY_LEFT_ARROW then
	    insertIndex -= 1
	    if insertIndex < 0 then
		insertIndex := 0
	    end if
	elsif k = KEY_RIGHT_ARROW then
	    insertIndex += 1
	    if insertIndex > length (value) then
		insertIndex := length (value)
	    end if
	else
	    for i : 1 .. length (keyMap)
		if keyMap (i) = k then
		    addText (k)
		    exit
		end if
	    end for
	end if
    end onFocusKeyFired

    body proc preRender ()
	if textRender > 0 then
	    Pic.Free (textRender)
	end if

	var w := Font.Width (value, font.id)
	var wI := Font.Width (value (1 .. insertIndex), font.id)

	textOffset := round (rect.w - wI)
	if textOffset > 0 then
	    textOffset := 0
	end if

	Draw.FillBox (0, 0, round (rect.w), round (rect.h), white)
	Font.Draw (value, textOffset, font.descent, font.id, black)

	if focused then
	    var textPointerX := round (textOffset + wI)
	    if Time.Elapsed mod textInsertionPointerFlash * 2 < textInsertionPointerFlash then
		Draw.Line (textPointerX, 0, textPointerX, font.height, black)
	    end if
	end if

	textRender := Pic.New (0, 0, round (rect.w), round (rect.h))
    end preRender

    body proc render ()
	Pic.Draw (textRender, round (rect.x), round (rect.y), picMerge)
	Shape.drawRect (rect, getBackroundColour (), false)
    end render
end GuiTextBox
