class GuiAbstractButton
    inherit GuiElement
    export
    % Getters
	callOnClick,
    % Setters
	setCallOnClick

    var callOnClick : proc p

    proc setCallOnClick (p : proc p2)
	callOnClick := p
    end setCallOnClick

    body proc onFocusKeyFired (k : char)
	if k = KEY_ENTER then
	    onClick ()
	end if
    end onFocusKeyFired
end GuiAbstractButton
