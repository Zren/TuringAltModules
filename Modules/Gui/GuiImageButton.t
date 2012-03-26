class GuiImageButton
    inherit GuiAbstractButton
    import Shape
    export
    % Setters
	setPic, setPicHover, setPicPress

    var pic,
	picHover,
	picPress : int

    proc setPic (p : int)
	pic := p
    end setPic

    proc setPicHover (p : int)
	picHover := p
    end setPicHover

    proc setPicPress (p : int)
	picPress := p
    end setPicPress

    body proc onHover ()
    end onHover

    body proc onPress ()
    end onPress

    body proc onClick ()
	callOnClick ()
    end onClick

    body proc onFocus ()
    end onFocus

    body proc preRender ()
    end preRender

    body proc render ()
	if state = ElementState.hover then
	    Pic.Draw (picHover, round (rect.x), round (rect.y), picMerge)
	elsif state = ElementState.pressed or state = ElementState.clicked then
	    Pic.Draw (picPress, round (rect.x), round (rect.y), picMerge)
	else
	    Pic.Draw (pic, round (rect.x), round (rect.y), picMerge)
	end if
    end render
end GuiImageButton
