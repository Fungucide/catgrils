%test

class Enemy

    export (health, gold, speed, x, y, xd, yd, c, ti, isValid, initialize, draw,setValid)

    var health, gold, speed, x, y, xd, yd, c, ti : int
    var isValid : boolean

    procedure initialize (health2, gold2, speed2, x2, y2, xd2, yd2, ti2, c2 : int, v : boolean)
	health := health2
	gold := gold2
	speed := speed2
	x := x2
	y := y2
	xd := xd2
	yd := yd2
	ti := ti2
	c := c2
	isValid := v
    end initialize

    procedure setValid(v:boolean)
	isValid:=v
    end setValid
    
    procedure draw (gt : int, turnPoint : array 0 .. *, 0 .. * of int)
	if isValid
	    if (gt mod speed = 0) then
		x += xd
		y += yd
	    end if
	    if x = turnPoint (ti, 0) and y = turnPoint (ti, 1) then
		xd := turnPoint (ti, 2)
		yd := turnPoint (ti, 3)
		ti += 1
	    end if
	    drawfillbox (x - 50, y - 50, x + 50, y + 50, c)
	end if
    end draw

end Enemy
