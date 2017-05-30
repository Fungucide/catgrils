var map : int
map := Pic.FileNew ("map.jpg")
map := Pic.Scale (map, 900, 600)

View.Set ("offscreenonly")

%gold
var gold : int := 1000000
var health : int := 3
%pnosisiton on screen
var nosi : int := 0
var nos : array 0 .. 54, 1 .. 3 of int
var eosi : int := 0
var eos : array 0 .. 54, 1 .. 4 of int
var rangeX1, rangeY1, rangeX2, rangeY2 : int
%wave procdeure/array
var waves : array 1 .. 4 of string
var wavesi : int := 0

var grida : array 1 .. 17, 1 .. 2 of int
var gridi : int := 0

procedure waveStats (next : string)
    wavesi += 1
    waves (wavesi) := next
end waveStats

procedure gridStat (x, y : int)
    gridi += 1
    grida (gridi, 1) := x
    grida (gridi, 2) := y
end gridStat
gridStat (9, 1)
gridStat (8, 1)
gridStat (7, 1)
gridStat (7, 2)
gridStat (7, 3)
gridStat (7, 4)
gridStat (7, 5)
gridStat (6, 5)
gridStat (4, 5)
gridStat (4, 4)
gridStat (4, 3)
gridStat (3, 3)
gridStat (3, 3)
gridStat (2, 3)
gridStat (2, 4)
gridStat (2, 5)
gridStat (1, 5)

procedure drawSprite (gameTick : int, var data : array 0 .. *, 0 .. * of int)
    for i : 0 .. upper (data)
	if gameTick mod data (i, 2) = 0 then
	    data (i, 3) += data (i, 5)
	    data (i, 4) += data (i, 6)
	end if
	drawfillbox (data (i, 3) - 50, data (i, 4) - 50, data (i, 3) + 50, data (i, 4) + 50, data (i, 7))
    end for
end drawSprite

waveStats ("1234")
waveStats ("123234")
waveStats ("12323412")
waveStats ("123412")



%enemy
var enemyId : int := 0
var enemies : array 0 .. 3, 0 .. 7 of int
procedure eStats (enemyId, health, gold, speed, x, y, xd, xy, c : int)
    enemies (enemyId, 0) := health
    enemies (enemyId, 1) := gold
    enemies (enemyId, 2) := speed
    enemies (enemyId, 3) := x
    enemies (enemyId, 4) := y
    enemies (enemyId, 5) := xd
    enemies (enemyId, 6) := xy
    enemies (enemyId, 7) := c
end eStats
eStats (enemyId, 3, 2, 2, 900, 50, -1, 0, black)
enemyId += 1
eStats (enemyId, 3, 4, 4, 900, 50, -1, 0, red)
enemyId += 1
eStats (enemyId, 3, 4, 6, 900, 50, -1, 0, yellow)
enemyId += 1
eStats (enemyId, 3, 4, 8, 900, 50, -1, 0, blue)

%nekos
var nekoid : int := 0
var nekos : array 1 .. 3, 1 .. 5 of int
procedure nekoStats (atkspd, range, dmg, gold : int)
    nekoid += 1
    nekos (nekoid, 1) := atkspd
    nekos (nekoid, 2) := range
    nekos (nekoid, 3) := dmg
    nekos (nekoid, 4) := nekoid
    nekos (nekoid, 5) := gold
end nekoStats
nekoStats (9, 150, 1, 100)
nekoStats (2, 150, 0, 100)
nekoStats (2, 150, 5, 100)
setscreen ("graphics:900;700,nobuttonbar")
%grid
var cordx : array 1 .. 10 of int
var cordy : array 1 .. 8 of int
var gridx, gridy : int := 1
for i : 1 .. 10
    cordx (i) := 100 * (i - 1)
end for
for i : 1 .. 8
    cordy (i) := 100 * (i - 1)
end for
for j : 1 .. 9
    for i : 1 .. 6
	gridy := i
	drawbox (cordx (gridx), cordy (gridy), cordx (gridx + 1), cordy (gridy + 1), 7)
    end for
    gridx += 1
end for

var mx, my, button : int
var select : int := 0
var selectUnitX : int
%tracking mouse on grid
var gcx, gcy : int := 0
delay (3000)

var gameTick : int := 0

loop
    gameTick := (gameTick + 1) mod 24
    drawSprite (gameTick, enemies)

    View.Update
    delay (12)

    Pic.Draw (map, 0, 0, 2)
    Mouse.Where (mx, my, button)

    for i : 1 .. 10
	if mx < cordx (i) and mx > cordx (i) - 100 then
	    gcx := i - 1
	    locatexy (mx, my)
	end if
    end for
    for i : 1 .. 8
	if my < cordy (i) and my > cordy (i) - 100 then
	    gcy := i - 1
	    locatexy (mx + 10, my)
	    %put gcy
	end if
    end for
    %selecting units
    if gcy = 7 and gcx <= 3 and button = 1 then
	selectUnitX := gcx
	case selectUnitX of
	    label 1 :
		select := 1
	    label 2 :
		select := 2
	    label 3 :
		select := 3
	end case
    end if
    if select not= 0 then
	if gold < nekos (select, 5) then
	    select := 0
	end if
    end if
    if button = 1 and gcy not= 7 then
	%checking if box is filled
	for i : 1 .. nosi
	    if nos (i, 1) = gcx and nos (i, 2) = gcy - 1 then
		select := 0
	    end if

	end for
	%checking if box in on gird
	for i : 1 .. gridi
	    if grida (i, 1) = gcx and grida (i, 2) = gcy then
		select := 0
	    end if
	end for
	if select not= 0 then
	    nosi += 1
	    nos (nosi, 1) := gcx*100
	    nos (nosi, 2) := (gcy - 1)*100
	    nos (nosi, 3) := select
	    gold -= nekos (select, 5)
	    select := 0
	end if

    end if
    if nosi not= 0 then
	for i : 1 .. nosi
	    if nos (i, 1) not= 0 then
		drawoval (nos (i, 1) - 50, nos (i, 2)+ 50, nekos (nos (i, 3), 2), nekos (nos (i, 3), 2), 6)
		%reading unit location
		drawfillbox (nos (i, 1) , nos (i, 2), nos (i, 1) - 100, nos (i, 2)+100, nos (i, 3))
	    end if
	end for
    end if
    %attacking
    for i : 1 .. nosi
	for j : 1 .. upper (enemies)
	    if Math.Distance (nos (i, 1)-50, nos (i, 2)-50, enemies (j, 3), enemies (j, 4)) < nekos (nos (i, 3),2)  then
	    if gameTick mod nekos (nos (i, 3),1)=0 then
	    enemies (j, 0) -= 1
	    end if
	    end if
	end for
    end for 
end loop
