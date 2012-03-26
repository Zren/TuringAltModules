class GuiButton
    inherit GuiAbstractButton
    import Shape

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
	Shape.drawRect (rect, getBackroundColour (), true)
	if focused then
	    Shape.drawRect (rect, colourFocused, false)
	end if
    end render
end GuiButton
