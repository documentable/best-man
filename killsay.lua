-- # tranquil.monster trashtalk (gamesense lua conversion)

-- # required libraries
local ui = ui
local client = client
local entity = entity

-- # trashtalk phrases
local trashtalk_phrases = {
    'it feels so good when you let me do that to you',
    'ur such a good femboy 4 daddy',
    'lsd.tech probably taps',
	'pibble@gmail.dog',
	'oh yes fawk me like that ughh it feels so good',
	'that makes me so hard',
	'i just creamed a little',
	'are you a good boy for daddy',
	'are you a good girl for daddy',
	'whos daddys good girl',
	'whos daddys good boy',
	'hawk luah',
	'whos a good boy',
	'whos a good girl',
	'i need a chubby femboy with a loving heart',
	'i need a chubby femboy with a loving heart',
	'i need a chubby femboy with a loving heart',
	'i need a chubby femboy with a loving heart',
	'i just r4ped this neurodivergent kid',
    'sweet talk talkin to me all night (>3<)',
    '#luckboosted',
	'FEAST MODE ACTIVED #HUNGRY FEEDMEMORE DOT COM',
    'js like me, i could teach u how 2 be js like me, man ik u wanna be js like me',
    'im luck boosted by lsd.tech',
	'me, u, my peanits, and u know the rest...',
	'me, u, my peanits, and u know the rest...',
	'me, u, my peanits, and u know the rest...',
	'lil b baim god',
	'lsd.tech',
	'?',
	':3',
	':3',
	':3',
	':3',
	'ling ling',
	':3',
	'*spread your butts and touched your anus with his tongue, starting to lick it*',
	'*i watch as u two kiss and get hornier while my bussy getter more and more wet*',
}

-- # ui checkbox to enable/disable trashtalk
local trashtalk_toggle = ui.new_checkbox("misc", "settings", "enable trashtalk")

-- # function to handle player deaths
local function on_player_death(event)
    if not ui.get(trashtalk_toggle) then return end

    local local_player = entity.get_local_player()
    local attacker = client.userid_to_entindex(event.attacker)
    local victim = client.userid_to_entindex(event.userid)

    -- only trigger trashtalk if local player gets the kill
    if attacker == local_player and victim ~= local_player then
        local phrase = trashtalk_phrases[math.random(#trashtalk_phrases)]
        client.exec("say \"" .. phrase .. "\"")
    end
end

-- # register trashtalk callback
client.set_event_callback("player_death", on_player_death)
