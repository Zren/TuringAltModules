unit
module Shape
    export
    % Types
	Point, Line, Circle, Rect,
    % Constructors
	point, line, circle, rect,
    % Collision Functions
	pointInRect,
    % Render
	drawPoint, drawCircle, drawLine, drawRect

    type Point :
	record
	    x, y : real
	end record
    type Line :
	record
	    a, b : Point
	end record
    type Circle :
	record
	    p : Point
	    r : real
	end record
    type Rect :
	record
	    x, y, w, h : real
	    a, b, c, d : Point
	end record

    fcn point (x, y : real) : Point
	var p : Point
	p.x := x
	p.y := y
	result p
    end point

    fcn line (a, b : Point) : Line
	var l : Line
	l.a := a
	l.b := b
	result l
    end line

    fcn rect (x, y, w, h : real) : Rect
	var r : Rect
	r.x := x
	r.y := y
	r.w := w
	r.h := h
	r.a := point (r.x, r.y)
	r.b := point (r.x + r.w, r.y)
	r.c := point (r.x, r.y + r.h)
	r.d := point (r.x + r.w, r.y + r.h)
	result r
    end rect

    fcn circle (p : Point, r : real) : Circle
	var c : Circle
	c.p := p
	c.r := r
	result c
    end circle

    fcn pointInRect (p : Point, r : Rect) : boolean
	result r.a.x <= p.x and p.x <= r.d.x and r.a.y <= p.y and p.y <= r.d.y
    end pointInRect

    proc drawPoint (p : Point, c : int)
	Draw.Dot (round (p.x), round (p.y), c)
    end drawPoint

    proc drawCircle (circle : Circle, c : int, fill : boolean)
	if fill then
	    Draw.FillOval (round (circle.p.x), round (circle.p.y), round (circle.r), round (circle.r), c)
	else
	    Draw.Oval (round (circle.p.x), round (circle.p.y), round (circle.r), round (circle.r), c)
	end if
    end drawCircle

    proc drawLine (a, b : Point, c : int)
	Draw.Line (round (a.x), round (a.y), round (b.x), round (b.y), c)
    end drawLine

    proc drawRect (r : Rect, c : int, fill : boolean)
	if fill then
	    Draw.FillBox (round (r.a.x), round (r.a.y), round (r.d.x), round (r.d.y), c)
	else
	    Draw.Box (round (r.a.x), round (r.a.y), round (r.d.x), round (r.d.y), c)
	end if
    end drawRect
end Shape
