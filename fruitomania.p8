pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
--- experimentation with pico8 platform for the first time
--- this is also my first time writing lua
function _init()
    srand()
    // contains numbers of berry sprites
    berry_sprites = {4,5,6,7,8}
    berry_spawn_timer = 2 // seconds to wait until next berry spawn
    timer = 0  // global timer
    logfile = "fruitomania.log"

    // directions
    lookright = true
    lookleft = false
    // end of directions

    // player init
    player = {}
    player.x = 0
    player.y = 96
    player.sprite = 0
    player.frame = 0 // nth frame in the sprite
    player.speed = 1
    player.direction = lookright // initialize char looking to the right
    player.score = {["yum"] = 0, ["fail"] = 0}

    // keeps track of active berries on the screen
    active_berries = {}
    music(0)
end

function init_berry(sprite_id)
    berry = {}
    berry.x = 0 + flr(rnd(128))
    berry.y = 0
    berry.sprite = sprite_id
    berry.speed = 1
    return berry
end

function move_berries()
    for berry in all(active_berries) do
        // berry collided with ground ?
        if berry.y + berry.speed > 97 then
            del(active_berries, berry)
            player.score["fail"] += 1
            sfx(1)
            printh("berry hit the platform: "..berry.sprite, logfile)
        elseif berry.y + berry.speed > player.y and (berry.x >= player.x - 4 and berry.x <= player.x + 4) then
            del(active_berries, berry)
            player.score["yum"] += 1
            sfx(2)
            printh("berry hit the player: "..berry.sprite, logfile)
        else // ugh.. lua does not have continue support in loops
            berry.y = berry.y + berry.speed
        end
    end
end

function init_random_berry()
    random_number = flr(rnd(#berry_sprites)) + 1
    random_berry_sprite_id = berry_sprites[random_number]
    printh("random berry sprite id generated: "..random_berry_sprite_id, logfile)
    new_berry = init_berry(random_berry_sprite_id)
    add(active_berries, new_berry)
    printh("new berry was spawned. count of active berries now: "..#active_berries, logfile)
end

function _update()
    if timer % (30 * berry_spawn_timer) == 0 then // every 5 seconds or 150 frames generate a new berry
       init_random_berry()
        printh("new berry initialized on timer: ".. timer , logfile) 
        timer = 0
        sfx(0)
    end
    timer += 1
 
    move_berries() // advances berry movement from the sky
    if btn(0) then
        player.x = player.x - player.speed*1
        player.direction = lookleft
    end
    if btn(1) then
        player.x = player.x + player.speed*1
        player.direction = lookright
    end
    if btn(0) or btn(1) then
        // advance player animation each time we move by 4 pixels
        player.frame = player.x % 4
        if player.sprite > 3 then
            player.frame = 0
        end
    else
        player.frame = 0 // reset if we are standing
    end
end

function _draw()
    cls()
    spr(player.sprite + player.frame, player.x, player.y, 1, 1, player.direction)
    for berry in all(active_berries) do
        spr(berry.sprite, berry.x, berry.y, 1, 1)
    end
    // map( celx, cely, sx, sy, celw, celh, [layer] )
    // main platform
    map(0, 61, 0, 104, 16, 3)
    // draw canopy
    map(0,54, 0, 0, 16, 5)
    // print score
    print("fail:"..player.score["fail"], 0,36,8) // red
    print("yum:"..player.score["yum"], 0,43,11) // green
end
__gfx__
55555500555555005555550055555500000330000000000000000000000b00000000000033333333444444444444444430222200002222000000000000000000
5000550050005500500055005000550000333300000cc000000bb00000bbb0000000000044444444544444544544455520242200004222230000000000000000
5b7b75005b7b75005b7b75005b7b75000883388000cccc0000bbbb0000cbc0000000000044434444454545454444554422222203302222000000000000000000
a77aa550a77aa555a77aa555a77aa550088888800ccddcc0088888800c0c0c000000000044444444445454544455445500242202304222000000000000000000
aeeaa550aeeea555aeeea555aeeaa550088888800ccddcc088888888c0c0c0c0b880088b44444444454545455454545400222222204222000000000000000000
0d000d000d000d000d000d000d000d000088880000cccc00888888880c0c0c00bb8888bb43444444445454544444554400222400202222000000000000000000
0d000d000d000d000d000d000d000d0000888800000cc0000888888000c0c0000bb88bb044444434444545454444444400222400202224000000000000000000
dd00dd0000000d000d000000dd00dd00000880000000000000888800000c000000bbbb0044444444444444444444444400222400222222000000000000000000
0c3c3c3cbc3c3b3b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3cbbc3c33cbbc3c30000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0bcbbb3ccbc3bb3c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b3030303b3c3c3c30000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
03b0b0bcc3bcbcbc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bc3c3c33bc3c3c330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3cbcbcbc3cbbccbc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b3c3c3c3b3c3cbc30000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01110111011101110101011101110101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01111101010111010101110111011101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01011111010101010101111101111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00010100110111110000111100001101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00310000001100000000000000000011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
90909090909090909090909090909090000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b0a0b0a0b0a0b0b0a0b0b0a0a0b0b0a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
00040000030502e050340500c0500f0500f0000d0000e0002b10032200363003a3003c40036000300002d00025000200000a0000d0001000014000190001c0002000024000270002c0002f000330001c00018000
000200001705017050170501705014050110500d05008050020500700004000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0004000006050120501f05028050310503b0503f0503e0503e0503b050350502f050290501e050180500000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100001513018150161502b1502915027150261502315022150201501f1501d1501c1501b1501a1501a1501c1501e15021150251502c1503015032150321502315000000000000000000000000000000000000
002300000c150000000c150000000e150101500e1500c1500c1500c1500c1500c1500e150101500e1500c1500e1500e1500e1500e1501015011150101500e1500e1501315011150101500e150101500e1500c150
__music__
03 04424344
