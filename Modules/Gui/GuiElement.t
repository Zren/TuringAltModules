class GuiElement
    import Shape, ElementState, Gui
    export
	initialize,
    % Getters
	rect, state, focused, canHaveFocus,
	colourReady, colourHover, colourPressed, colourClicked, colourFocused,
    % Setters
	setState, setRect, isFocused,
    % Events
	onHover, onPress, onClick, onFocus, onFocusKeyFired,
    %
	preRender, render

    var rect : Shape.Rect
    var state : ElementState
    var focused : boolean

    var colourReady := black
    var colourHover := gray
    var colourPressed := yellow
    var colourClicked := red
    var colourFocused := cyan
    
    var canHaveFocus := true

    proc initialize ()
	state := ElementState.ready
	focused := false
    end initialize

    proc setRect (r : Shape.Rect)
	rect := r
    end setRect

    proc isFocused (b : boolean)
	focused := b
    end isFocused

    fcn getBackroundColour () : int
	if state = ElementState.ready then
	    result colourReady
	elsif state = ElementState.hover then
	    result colourHover
	elsif state = ElementState.pressed then
	    result colourPressed
	elsif state = ElementState.clicked then
	    result colourClicked
	elsif focused then
	    result colourFocused
	else
	    result black
	end if
    end getBackroundColour

    deferred proc onHover ()
    deferred proc onPress ()
    deferred proc onClick ()
    deferred proc onFocus ()

    proc _setState (s : ElementState)
	state := s
    end _setState

    proc setState (s : ElementState)
	_setState (s)
	case state of
	    label ElementState.hover :
		onHover ()
	    label ElementState.pressed :
		onPress ()
	    label ElementState.clicked :
		onClick ()
	    label :
	end case
    end setState

    deferred proc onFocusKeyFired (k : char)

    deferred proc preRender ()
    deferred proc render ()
end GuiElement
