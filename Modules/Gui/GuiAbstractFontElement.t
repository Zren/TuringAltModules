class GuiAbstractFontElement
    inherit GuiElement
    import Fonts, Shape
    export
    % Getters
	font,
    % Setters
	setFont, setFontData

    var font := newFont ("serif:12")
    
    proc setFont (s : string)
	if font.id > 0 then
	    Font.Free (font.id)
	end if
	font := newFont (s)
	setRect (Shape.rect (rect.x, rect.y, rect.w, font.height + font.descent))
    end setFont
    
    proc setFontData (data : Fonts.Data)
	font := data
	setRect (Shape.rect (rect.x, rect.y, rect.w, font.height + font.descent))
    end setFontData
end GuiAbstractFontElement
