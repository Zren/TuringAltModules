class GuiLabel
    inherit GuiAbstractFontElement
    import Fonts
    export
    % Getters
	target, text,
    % Setters
	setTarget, setText, setFontAsTarget

    var target : ^GuiElement
    var text := ""
    canHaveFocus := false

    proc _setRect ()
	var w := Font.Width (text, font.id)
	if target not= nil then
	    setRect (Shape.rect (target -> rect.x - w, target -> rect.y, w, font.height))
	else
	    setRect (Shape.rect (0, 0, w, font.height + font.descent))
	end if
    end _setRect

    proc setTarget (e : ^GuiElement)
	target := e
	_setRect ()
    end setTarget

    proc setText (s : string)
	text := s
	_setRect ()
    end setText

    proc setFontAsTarget ()
	if target not= nil and objectclass (target) >= Gui.GuiAbstractFontElement then
	    setFontData (Gui.GuiAbstractFontElement (target).font)
	    _setRect ()
	end if
    end setFontAsTarget

    body proc onHover ()
    end onHover

    body proc onPress ()
    end onPress

    body proc onClick ()
    end onClick

    body proc onFocus ()
	if target not= nil then
	    Gui.focusOn (target)
	end if
    end onFocus

    body proc onFocusKeyFired (k : char)
    end onFocusKeyFired

    body proc preRender ()
    end preRender

    body proc render ()
	if target not= nil then
	    Font.Draw (text, round (rect.x), round (rect.y + font.descent), font.id, black)
	end if
    end render
end GuiLabel
