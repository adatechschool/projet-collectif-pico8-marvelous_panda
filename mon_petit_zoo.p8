pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
function _init()
 create_player()
 init_msg()
 create_msg("bonjour meng meng",
 "sors vite du zoo")
end

function _update()
 if not messages[1] then
  player_mouvement()
 end
 update_msg()
 update_camera()
 --interact(x,y)
 --interact_cle(x,y)
end

function _draw()
	cls(3)
	palt(0,false)
	palt(12,true)
	draw_map()
	draw_player()
	draw_msg()
	draw_ui()
	palt()
end
-->8
--map

function draw_map()
	map(0,0,0,0,128,64)
end

function check_flag(flag,x,y)
 local sprite=mget(x,y)
 return fget(sprite,flag)
end


function update_camera()
 local map_width=127
 local map_height=63
 local camx=mid(0,(p.x-7.5)*8,
            (map_width-15)*8)
 local camy=mid(0,(p.y-7.5)*8,
            (map_height-15)*8)
 camera(camx,camy)
end

--function update_camera()
-- local camx=flr(p.x/16)*16
-- local camy=flr(p.y/16)*16
-- camera(camx*8,camy*8)
--end

function next_tile(x,y)
 local sprite=mget(x,y)
 mset(x,y,sprite+1)
end




-->8
--player

function create_player()
 p={
   x=5,y=25,
   sprite=20,
   oeufs=0,
   cles=0
   }
end

function player_mouvement()
 newx=p.x
 newy=p.y
  if btn(⬅️) then
	  newx-=1
	  p.flip=true
	 elseif btn(➡️) then
	  newx+=1
	  p.flip=false
	 elseif btn(⬆️) then
	  newy-=1
	 elseif btn(⬇️) then
	 	newy+=1
	 end
 if (p.x%2==0 and p.oeufs==0) then 
   p.sprite=20
  elseif (p.x%2!=0 and p.oeufs==0) then
   p.sprite=21
  elseif (p.x%2==0 and p.oeufs!=0) then
   p.sprite=22
  else p.sprite=23
 end

 interact(newx,newy)
 interact_cle(newx,newy)

 if (newx!=p.x or newy!=p.y)and not
   check_flag(0,newx,newy)
 then
  p.x=mid(0,newx,47)
  p.y=mid(0,newy,31)
	end
end

function draw_player()
	spr(p.sprite,p.x*8,p.y*8,1,1,p.flip)
end

-->8
--oeuf
function pick_up_oeuf(x,y)
 next_tile(x,y)
 p.oeufs+=1
end

function interact(x,y)
	if check_flag(1,x,y) then
	 pick_up_oeuf(x,y)
	elseif check_flag(2,x,y)
	and p.oeufs>0 then
		open_door_poule(x,y)
 end
end

function draw_ui()
	camera()
 spr(15)
 print("X"..p.oeufs,10,2,7)
end

-->8
-- open_door

function open_door_poule(x,y)
	next_tile(x,y)
	p.oeufs-=1
end

-->8
--messages
function init_msg()
 messages={}
 end

function create_msg(name,...)
 msg_title=name
 messages={...}
 end

function update_msg()
 if (btnp(❎)) then
 deli(messages,1)
 end
end

function draw_msg()
 if messages[1] then
 local y=179
 if p.y%16>9 then
    y=10
 end
 rectfill(0,y+40,125,y+70,1)
 rect(0,y+40,125,y+70,5)
 print(msg_title,7,y+45,4)
 print(messages[1],7,y+55,7)
 end
end


-->8
--cles
function pick_up_cle(x,y)
 next_tile(x,y)
 p.cles+=1
end

function interact_cle(x,y)
	if check_flag(3,x,y) then
	 pick_up_cle(x,y)
--	elseif check_flag(?,x,y)
--	and p.oeufs>0 then
	--	open_door_poule(x,y)
 end
end
__gfx__
00000000cccccccccccccccc33333333ccbbbccccccccccc11111111000000009ccc9cccccc777cccccc8cccccaccaccccdccdcccc9cc9cccc4cc4cccccaaccc
00000000cccccccccccccccc33333333ccbbbccccccccccc111111110000000099c999c9cc77c7cccc7777ccccaaaacccc7dd7cccc7997cccc4444ccccaaaacc
00700700cccc00cccc00cccc33333333ccbbbcccccc7cccc111111110000000099c999c977ccc777cc7070cccc0aa0cccc0dd0cccc9090cccc0440cccaaaaaac
00077000cccc00cccc00cccc33333333cccccccccc7a7ccc1111111100000000999999997cccccc7cc777accacaaaacccc7447cc0c9999c04c4444c4aaaaaaaa
00077000cccc77777777cccc33333333ccbbbcccccc7cccc111111110000000099c999c97cccccc77aa77877caaaaaaccddddddc9c9999094c4994c4aaaaaaaa
00700700ccc7777777777ccc33333333ccbbbcccccccc9cc111111110000000099c999c97cccccc7c7a7777ccca77acadd0dd0dd099779cc44499444aaaaaaaa
00000000cc777007700777cc33333333ccbbbccccccc9a9c111111110000000099c999c97cccccc7cc7777cccca77acccddddddccc0770cccc4444ccaaaaaaaa
00000000cc777007700777cc33333333ccbbbcccccccc9cc111111110000000099c999c97cccccc7ccaccaccccaccacccc0dd0cccc9cc9cccc4cc4cccaaaaaac
33333333cc777777777777cccc9cc9cccc0cc0cccc0cc0cccc0cc0cbcc0cc0cbccbbbbccccccccccccccccccccccccccdccccccccccccccc0000000000000000
33333333cccc00777700cccccc9999cccc7777cccc7777cccc7777cbcc7777cbcbbaab1cccc88ccccccccccccccccccdddcccccccccccccc0000000000000000
33333333cccc77777777cccccc9070cccc7070cccc7070cccc7070cbcc7070cbcbbbab1ccc8cc8ccccccccccccccccdddddccccccccccccc0000000000000000
33333333c00077777777000c9c9777c9cc7777cccc7777cccc7777cbcc7777cbcbbbb31cc8cccc8ccccccccccccccddd6666cccccccccccc0000000000000000
33333333cc007777777700cc9c77779cc000000cc000000cc0000000c0000000c13b331cc8cccc8ccccccccccccdddd666666ccccccccccc0000000000000000
33333333cccc777cc777cccc997777cc0c7777c0c077770c0c7777cbc07777cbcc1111ccc8cccc8cccccccccccddd666666666cccccccccc0000000000000000
33333333cccc000cc000cccccc9999cccc0770cccc7070cccc0770cccc7070ccccc22cccc8cccc8ccccccccccddd66666666666ccccccccc0000000000000000
33333333cccccccccccccccccc9cc9cccc0cc0ccccc0c0cccc0cc0ccccc0c0cccc1442ccc8cccc8cccccccccdddd6666d6666666cccccccc0000000000000000
33333333333333330000000000000000000000000000000000000000000000000000000000000000ccccccddddddd666dd6666666ccccccc0000000000000000
33333333333333330000000000000000000000000000000000000000000000000000000000000000cccccdddddddd666ddd6666666cccccc0000000000000000
33333a33333333330000000000000000000000000000000000000000000000000000000000000000ccccdd66ddddd666dddd6666666ccccc0000000000000000
3aaaa3a3333333330000000000000000000000000000000000000000000000000000000000000000cccdddd6ddddd6666dddd6666666cccc0000000000000000
3a333a33333333330000000000000000000000000000000000000000000000000000000000000000ccddddd66dddd6666ddddd6666666ccc0000000000000000
33333333333333330000000000000000000000000000000000000000000000000000000000000000cddddddd6666d66666dddddd666666cc0000000000000000
33333333333333330000000000000000000000000000000000000000000000000000000000000000cdddddddd66dd66666ddddddd666666c0000000000000000
33333333333333330000000000000000000000000000000000000000000000000000000000000000dddddddddd666666666ddddddd6666660000000000000000
0000000000000000000000000000000000000000000000000000000000000000cccccccccccccccccccccccccccccccccccdddcccccccccccccccccccccccccc
0000000000000000000000000000000000000000000000000000000000000000cccccccccccccccccccccccccccccccccccddddccccccccccccccccccccccccc
0000000000000000000000000000000000000000000000000000000000000000cccccccccccccccccccccccccccccccccddddddccccccccccccccccccccccccc
0000000000000000000000000000000000000000000000000000000000000000cccccccccccccccccccccccccccccccddddd6666cccccccccccccccccccccccc
0000000000000000000000000000000000000000000000000000000000000000ccccccccccccccccccccccccccccccdddd6666666ccccccccccccccccccccccc
0000000000000000000000000000000000000000000000000000000000000000ccccccccccccccccccccccccccccddddd666666666cccccccccccccccccccccc
0000000000000000000000000000000000000000000000000000000000000000ccccccccccccccccccccccccccccdddd6666666666cccccccccccccccccccccc
0000000000000000000000000000000000000000000000000000000000000000ccccccccccccccccccccccccccddddd666666666666ccccccccccccccccccccc
0000000000000000000000000000000000000000000000000000000000000000ccccccccccccccccccccccccccddd666666666666666cccccccccccccccccccc
0000000000000000000000000000000000000000000000000000000000000000ccccccccccccccccccccccccdddd66666666666666666ccccccccccccccccccc
0000000000000000000000000000000000000000000000000000000000000000cccccccccccccccccccccccdddd6666666666666666666cccccccccccccccccc
0000000000000000000000000000000000000000000000000000000000000000cccccccccccccccccccccddddd666666666666666666666ccccccccccccccccc
0000000000000000000000000000000000000000000000000000000000000000ccccccccccccccccccccddddd6666666666666666666666ccccccccccccccccc
0000000000000000000000000000000000000000000000000000000000000000cccccccccccccccccccdddddd6666ddd6666666666666666cccccccccccccccc
0000000000000000000000000000000000000000000000000000000000000000cccccccccccccccccdddddddd6666dddd6666666666666666ccccccccccccccc
0000000000000000000000000000000000000000000000000000000000000000ccccccccccccccccdddddddddd6666dddd6666666666666666cccccccccccccc
0000000000000000000000000000000000000000000000000000000000000000cccccccccccccccddddddddddd66666dddd666666666666666cccccccccccccc
0000000000000000000000000000000000000000000000000000000000000000ccccccccccccccddddddddddd6666666dddd666666dd6666666ccccccccccccc
0000000000000000000000000000000000000000000000000000000000000000cccccccccccccddddddddddd666666666ddd666666ddd666666ccccccccccccc
0000000000000000000000000000000000000000000000000000000000000000ccccccccccccdddddddddddd6666666666ddd66666dddd666666cccccccccccc
0000000000000000000000000000000000000000000000000000000000000000cccccccccccdddddddddddddd66666666ddddd66666ddd6666666ccccccccccc
0000000000000000000000000000000000000000000000000000000000000000ccccccccccdddddddddddddddd6666666ddddd666666dddd666666cccccccccc
0000000000000000000000000000000000000000000000000000000000000000ccccccccdddddddddddddddddd6666666dddddd666666ddd666666cccccccccc
0000000000000000000000000000000000000000000000000000000000000000cccccccddddddddddddddddddd666666666ddddd666666ddd666666ccccccccc
0000000000000000000000000000000000000000000000000000000000000000ccccccdddddddd66dddddddddddd66666666ddddd66666dddd666666cccccccc
0000000000000000000000000000000000000000000000000000000000000000ccccddddddddd6666666dddddddd6666666666dddd66666ddd6666666ccccccc
0000000000000000000000000000000000000000000000000000000000000000cccdddddddd66666666666ddddddd6666666666dddd66666dd66666666cccccc
0000000000000000000000000000000000000000000000000000000000000000ccddddddd666666666666666dddddd6666666666ddddd66666666666666ccccc
0000000000000000000000000000000000000000000000000000000000000000cdddddd66666666666666666666ddd66666666666ddddd66666666666666cccc
0000000000000000000000000000000000000000000000000000000000000000dddddd666666666666666666666666666666666666dddd666666666666666ccc
0000000000000000000000000000000000000000000000000000000000000000dddd6666666666666666666666666666666666666666666666666666666666cc
0000000000000000000000000000000000000000000000000000000000000000dddd66666666666666666666666666666666666666666666666666666666666c
00000000000000000000000000000000000000000000000000000000000000000000000000000000303030303030303030303030303030303030303030303030
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000303030303030303030303030303030303030303030303030
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000303030303030303030303030303030303030303030303030
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000303030303030303030303030303030303030303030303030
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
30303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
30303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
30303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
30303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
30303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030300000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
30303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030300000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
30303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030300000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
30303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030300000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
30303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030300000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
30303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030300000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
30303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030300000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
30303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030300000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
30303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030300000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
30303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030300000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
30303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030300000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
30303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030300000000000
__gff__
0000000000000000010000000000000200000100000000000105000000000000080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
181818181818183b3c3d18181818181818181818181808181818181808181818181818181818181818183b3c3d1818080303030303030303030303030303030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1818181818184a4b4c4d181818180303030303030808080303030308181818181818180303030318184a4b4c4d1818080303030303030303030303030303030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
181b1c1818595a5b5c5d5e1803030303030303030803030303030308080303030303030303030318595a5b5c5d5e18080303030303030303030303030303030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2a2b2c2d68696a6b6c6d6e6f03030303030303030803030303030303080303030303030303030368696a6b6c6d6e6f080303030303030303030303030303030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1818030303030303030303030303050303030308080303030303030308030303030303030303030303030303030303080303030303030303030303030303030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1818030303030303030303030303030303030808030305030303030308030303030503030303030303030303030303080303030303030303030303030303030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1803030303030e03030303030303030908080303030303030303030303080808030303030303030303030303030303080303030303030303030303030303030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1803030303030303030303030303090303030303030303030303030303030308030303030303030d20030303030303080303030303030303030303030303030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1803030303030303030303030308030303030303030303030303030303030303090903030303030303030303030303080303030303030303030303030303030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1803030303030303030303080808030303030303030303030303030303030303030308080803030303050303030303080303030303030303030303030303030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1803030303030303080808030303030303030303030303030808080808030303030303030808080808080808080808080303030303030303030303030303030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0808080808080808080303030303030303030303030303080303030308030303030303030303030303030303030303080303030303030303030303030303030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1803030303030303030303030303030305030303090909030303030303080303030303030303030303030303030303080303030303030303030303030303030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1803030303030303030303030303030305030303090303030303030303080303030503030303030303030303030303080303030303030303030303030303030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1803030303030303030303030303030503030308030303030303030303080303030303030808080808080808080808080303030303030303030303030303030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
18030303030503030303030303030303030308030303030c0303030308080303030303030903030318181818181818080303030303030303030303030303030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1818030303030303030305030303030503030803030303030303030808030303030303030903030303030303181818080303030303030303030303030303030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1818030303030303030303030303030303080303030303030303080803030303030303030903030303130303030303080303030303030303030303030303030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1818030303030303030303030303030303080303030303030308080303030303030303030803030303030305030303080303030303030303030303030303030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1818030303030303030303030303030303080303030303030808030303030303050303030808030303030303030303080303030303030303030303030303030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0808080808080808080909080303030303030808030308080803031908080808030303030308080808080808080808080303030303030303030303030303030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0303030303030303030303080803030303030308080803030303190303030308080303030303030303030303030303080303030303030303030303030303030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0303030303030303030303030803030303030303030303030308030303030303080303030303030303030303030303080303030303030303030303030303030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0303030303030303030303030803030303030303030303080808030303030303080803030303030303030303080808080303030303030303030303030303030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0303030303030f03030303030808030303050303030808080303030303050303030803030303090909080808030318080303030303030303030303030303030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0303030503030303030303030308030303030303030803030303030303030303030803030303080303030303030318080303030303030303030303030303030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0303030303030303030303030308030303030303081803030303030303030303030308030303080303030303050318080303030303030303030303030303030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0303030303030303030303030308080303030303081818030303030a03030303030308030303080303030303030318080303030303030303030303030303030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
030303030303030303030503030308030303030308081803030303030303050303030803030308030503030b030318080303030303030303030303030303030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0303030303030303030303030303080803030303030818030303030303030303030308030303080803030303031818080303030303030303030303030303030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1818181818090918181818181818180803030303030818030303030303030303030308030303030803030318181818080303030303030303030303030303030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080303030303030303030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
