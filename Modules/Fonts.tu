unit
module Fonts
    export ~.*all

    type Data :
	record
	    id, height, ascent, descent, internalLeading : int
	end record

    fcn newFont (s : string) : Fonts.Data
	var font : Fonts.Data
	font.id := Font.New (s)
	Font.Sizes (font.id, font.height, font.ascent, font.descent, font.internalLeading)
	result font
    end newFont

    proc drawVecticalText (s : string, x, y : int, font : Fonts.Data, c:int)
	for i : 1 .. length (s)
	    Font.Draw (s (i), x, y + (font.descent + font.height * (length (s) - i)), font.id, c)
	end for
    end drawVecticalText
end Fonts
