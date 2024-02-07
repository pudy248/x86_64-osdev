//TODO: check how easy easyzoom integration would be, mouse hover coordinates, click to set position, orb tooltips on map, way to mark found orbs (include separate marking for parallels)

var map_canvas = null;
var ctx = null;
var width = null
var height = null
var scale = 0

search_spiral_start = Module.cwrap('search_spiral_start', 'number', ['number', 'number', 'number', 'number', 'number', 'number', 'number', 'number', 'number'])
search_spiral_step = Module.cwrap('search_spiral_step', 'number', ['number'])


function refresh_canvas_size()
{
    width = map_canvas.width
    height = map_canvas.height
    scale = height/48
}

function init()
{
    var inputs = document.getElementsByTagName("input");
    for(i = 0; i < inputs.length; i++)
    {
        if(inputs[i].getAttribute("type") == "number")
        {
            input = inputs[i]
            increment_box = document.createElement('div');
            increment_box.className = "increment_box";
            inc_button = document.createElement('button');
            dec_button = document.createElement('button');
            increment_box.appendChild(inc_button);
            increment_box.appendChild(dec_button);
            input.insertAdjacentElement("afterend", increment_box);

            inc_button.innerHTML = "▲";
            dec_button.innerHTML = "▼";
            inc_button.type = "button"
            dec_button.type = "button"
            inc_button.tabIndex = -1
            dec_button.tabIndex = -1

            function make_increment_function(input, amount)
            {
                return function()
                {
                    input.value = parseInt(input.value)+amount;
                }
            }

            inc_button.onclick = make_increment_function(input, +1);
            dec_button.onclick = make_increment_function(input, -1);
        }
    }

    function change_searchmode(event, event2) {
        if(parseInt(event.target.value) == 2) {
            var x_input = document.getElementById("x");
            var y_input = document.getElementById("y");
            x_input.value = "14941"
            y_input.value = "18654"
        }
		if (parseInt(event.target.value) == 3) {
			document.getElementById("wand_body").style.display = "none";
			document.getElementById("potion_body").style.display = "block";
		}
		else {
			document.getElementById("wand_body").style.display = "block";
			document.getElementById("potion_body").style.display = "none";
		}
    }

    var search_input = document.getElementById("search_mode");
    search_input.onchange = change_searchmode

    map_canvas = document.getElementById('map_canvas');
    refresh_canvas_size()
    ctx = map_canvas.getContext('2d');
}

function reset_xy()
{
    var x_input = document.getElementById("x");
    var y_input = document.getElementById("y");
    x_input.value = 0;
    y_input.value = 0;
}

function far_xy()
{
    var x_input = document.getElementById("x");
    var y_input = document.getElementById("y");
    var big_number = 1050000;
    var x_sign = -(y_input.value > 32*512 ? 1:-1);
    var y_sign = (x_input.value > 28*512 ? 1:-1);
    x_input.value = x_sign*big_number;
    y_input.value = y_sign*big_number;
}

var parallel_width = (64*512)
var parallel_left_edge_tile = -32
var parallel_left_edge = parallel_left_edge_tile*512

function world_to_canvas(x, y)
{
    const world_width = 64*512;
    const world_height = world_width*48/64;
    return [width*x/world_width-parallel_left_edge_tile*scale,
            height*y/world_height+14*scale]
}

var world_seed = 0;
var effective_world_seed = 0;
var ng = 0;
var x0 = 0;
var y0 = 0;
var stat = 0;
var stat_threshold = 27;
var less_than = false;
var search_mode = 0;
var animation_request_id;

function draw_disc(x, y, r)
{
    ctx.beginPath();
    ctx.arc(x, y, r, 0, 2 * Math.PI);
    ctx.fill();
    ctx.stroke();
}

function draw_line_segment(x0, y0, x1, y1)
{
    ctx.beginPath();
    ctx.moveTo(x0, y0);
    ctx.lineTo(x1, y1);
    ctx.stroke();
}

function get_parallel_name(parallel_number, show_main_world = true)
{
    return ((parallel_number > 0) ? "East "+parallel_number
            : ((parallel_number < 0) ? "West "+(-parallel_number)
               : (show_main_world) ? "Main World" : ""));
}


var search_x = 0;
var search_y = 0;
var search_iters = 0;
var search_parallel_number = 0;
var search_color = "#FFFFFF";
var search_color2 = "#FFFFFF";
var show_search = true;
var map_title;

function redraw_map()
{
    // Draw the orbs on the map
    ctx.clearRect(0, 0, width, height);

    if(show_search)
    {
        var show_x = ((((search_x-parallel_left_edge)%parallel_width)+parallel_width)%parallel_width)+parallel_left_edge;
        var parallel_number = Math.floor((search_x-parallel_left_edge)/parallel_width)
        map_title.innerHTML = get_parallel_name(parallel_number, false)

        p = world_to_canvas(show_x, search_y);
        var x = p[0]
        var y = p[1]

        ctx.fillStyle = search_color;
        ctx.strokeStyle = search_color2;

        ctx.lineWidth = 5
        var a = 0.5*scale
        draw_line_segment(x-a, y-a, x+a, y+a);
        draw_line_segment(x-a, y+a, x+a, y-a);

        ctx.lineWidth = 2
        draw_disc(x, y, 0.3*scale);
    }
}

function update_orbs()
{
    var seed_input = document.getElementById("seed");
    var ng_input = document.getElementById("ng");
    var x_input = document.getElementById("x");
    var y_input = document.getElementById("y");
    var stat_input = document.getElementById("stat");
    var threshold_input = document.getElementById("threshold");
    var lt_input = document.getElementById("less_than")
    var ns_input = document.getElementById("nonshuffle")
    var noac_input = document.getElementById("no_ac")
    var search_input = document.getElementById("search_mode");
    var newgame_plus_map = document.getElementById("newgame_plus_map")
    var newgame_map = document.getElementById("newgame_map")
    world_seed = parseInt(seed.value)
    ng = parseInt(ng_input.value)
    effective_world_seed = world_seed+ng
    x0 = parseFloat(x_input.value)
    y0 = parseFloat(y_input.value)
    stat = parseInt(stat_input.value)
    stat_threshold = parseFloat(threshold_input.value)
    less_than = lt_input.checked
    nonshuffle = ns_input.checked
	noac = noac_input.checked
    search_mode = parseInt(search_input.value);

    var output = document.getElementById("output");
    output.innerHTML = "";
	var potion_index = -1

	if (search_mode == 3) {
		potion_name = document.getElementById("material").value.toLowerCase()
		for(var i = 0; i < 455; i++) {
			if(potion_name === MaterialNames[i]) {
				potion_index = i
			}
		}
		if (potion_index == -1) {
			output.innerHTML = "<p>Invalid material!<\p>"
			return false
		}
	}

    var status = document.getElementById("status");
    status.innerHTML = "Searching...";
    map_title = document.getElementById("map_title")
    map_title.innerHTML = "";

    if(ng > 0)
    {
        map_canvas.width = 1280
        refresh_canvas_size()
        newgame_map.style.display = "none"
        newgame_plus_map.style.display = "block"
    }
    else
    {
        map_canvas.width = 1280*70/64
        refresh_canvas_size()
        newgame_map.style.display = "block"
        newgame_plus_map.style.display = "none"
    }

    parallel_width = (ng > 0) ? (64*512) : (70*512)
    parallel_left_edge_tile = (ng > 0) ? (-32) : (-35)
    parallel_left_edge = parallel_left_edge_tile*512
    var find_chest_orb = true

    show_search = true;
    redraw_map();

    search_x = x0
    search_y = y0

    var count = 38373
    if(search_mode > 0) count = 19287

    var parallel_name = ""
    //TODO: stop this loop if button is pressed a second time, currently prints twice and wastes compute
    function search_step(timestamp)
    {
        search_color = "#7F5476"
        search_color2 = "#7F5476"
        search_x = getValue(search_spiral_result_ptr, "double");
        search_y = getValue(search_spiral_result_ptr+8, "double");
        search_iters = getValue(search_spiral_result_ptr+16, "double");
        redraw_map();
        status.innerHTML = search_iters + " pixels checked...";

        var found_spiral = false
        found_spiral = search_spiral_step(count)

        if(!found_spiral)
        {
            animation_request_id = window.requestAnimationFrame(search_step);
            return;
        }

        search_x = getValue(search_spiral_result_ptr, "double");
        search_y = getValue(search_spiral_result_ptr+8, "double");
        search_iters = getValue(search_spiral_result_ptr+16, "double");

		ret_string_x = search_x.toString()
		ret_string_y = search_y.toString()

		if (search_mode == 3) {
			output.innerHTML += "<p>Flask found at x = " + ret_string_x + ", y = " + ret_string_y + "<\p>";
		}
		else {
			var search_capacity = getValue(search_spiral_result_ptr+24, "double");
			var search_multicast = getValue(search_spiral_result_ptr+32, "double");
			var search_delay = getValue(search_spiral_result_ptr+40, "double");
			var search_reload = getValue(search_spiral_result_ptr+48, "double");
			var search_mana = getValue(search_spiral_result_ptr+56, "double");
			var search_regen = getValue(search_spiral_result_ptr+64, "double");
			var search_spread = getValue(search_spiral_result_ptr+72, "double");
			var search_speead = getValue(search_spiral_result_ptr+80, "double");
			var search_shuffle = getValue(search_spiral_result_ptr+88, "double");
			var search_ac = getValue(search_spiral_result_ptr+96, "double");

			//make ranges for rounding imprecision
			//this continues to be the worst way to implement these things
			if(search_mode == 0 && Math.abs(search_x) > 1000000) {
				var plusminus = 5
				if(Math.abs(search_x) > 10000000) plusminus = 50
				ret_string_x = (search_x).toString() + " \u00B1 " + (plusminus).toString()
			}

			if(search_mode == 0 && Math.abs(search_y) > 1000000) {
				var plusminus = 5
				if(Math.abs(search_y) > 10000000) plusminus = 50
				ret_string_y = (search_y).toString() + " \u00B1 " + (plusminus).toString()
			}

			search_color = "#FF5E26"
			search_color2 = "#FFE385"
			redraw_map();
			output.innerHTML += "<p>Wand found at x = " + ret_string_x + ", y = " + ret_string_y + "<\p>";
			output.innerHTML += "<p>Capacity: " + Math.floor(search_capacity) + "<\p>";
			output.innerHTML += "<p>Multicast: " + search_multicast + "<\p>";
			output.innerHTML += "<p>Cast Delay: " + (search_delay / 60).toFixed(2) + " sec<\p>";
			output.innerHTML += "<p>Reload: " + (search_reload / 60).toFixed(2) + " sec<\p>";
			output.innerHTML += "<p>Max Mana: " + search_mana + "<\p>";
			output.innerHTML += "<p>Mana Regen: " + search_regen + "<\p>";
			output.innerHTML += "<p>Spread: " + search_spread + " deg<\p>";
			output.innerHTML += "<p>Speed: " + search_speead.toFixed(3) + "x<\p>";
			output.innerHTML += "<p>" + (search_shuffle == 0 ? "Nonshuffle" : "Shuffle") + "<\p>";
			if(search_ac > 0) {
				output.innerHTML += "<p>Always Cast: " + SpellNames[search_ac] + "<\p>";
			}
		}
        status.innerHTML = "";
    }

    //start the search
    var search_spiral_result_ptr = search_spiral_start(world_seed, ng, x0, y0, search_mode == 3 ? potion_index : stat, stat_threshold, (less_than ? 1 : 0) + (nonshuffle ? 2 : 0) + (noac ? 4 : 0), search_mode);
    window.cancelAnimationFrame(animation_request_id);
    if(true) animation_request_id = window.requestAnimationFrame(search_step);
    else status.innerHTML = "";

    return false;
}

SpellNames = [
	"None",
	"Bomb",
	"Spark bolt",
	"Spark bolt with trigger",
	"Spark bolt with double trigger",
	"Spark bolt with timer",
	"Magic arrow",
	"Magic arrow with trigger",
	"Magic arrow with timer",
	"Magic bolt",
	"Magic bolt with trigger",
	"Magic bolt with timer",
	"Burst of air",
	"Energy orb",
	"Energy orb with a trigger",
	"Energy orb with a timer",
	"Hookbolt",
	"Black hole",
	"Black hole with death trigger",
	"Giga black hole",
	"Giga white hole",
	"Omega black hole",
	"Eldritch portal",
	"Spitter bolt",
	"Spitter bolt with timer",
	"Large spitter bolt",
	"Large spitter bolt with timer",
	"Giant spitter bolt",
	"Giant spitter bolt with timer",
	"Bubble spark",
	"Bubble spark with trigger",
	"Disc projectile",
	"Giga disc projectile",
	"Omega disc projectile",
	"Energy sphere",
	"Energy sphere with timer",
	"Bouncing burst",
	"Arrow",
	"Pollen",
	"Glowing lance",
	"Holy lance",
	"Magic missile",
	"Large magic missile",
	"Giant magic missile",
	"Firebolt",
	"Firebolt with trigger",
	"Large firebolt",
	"Giant firebolt",
	"Odd firebolt",
	"Dropper bolt",
	"Unstable crystal",
	"Unstable crystal with trigger",
	"Dormant crystal",
	"Dormant crystal with trigger",
	"Summon fish",
	"Summon deercoy",
	"Flock of ducks",
	"Worm launcher",
	"Explosive detonator",
	"Concentrated light",
	"Intense concentrated light",
	"Lightning bolt",
	"Ball lightning",
	"Plasma beam",
	"Plasma beam cross",
	"Plasma cutter",
	"Digging bolt",
	"Digging blast",
	"Chainsaw",
	"Luminous drill",
	"Luminous drill with timer",
	"Summon tentacle",
	"Summon tentacle with timer",
	"Healing bolt",
	"Spiral shot",
	"Magic guard",
	"Big magic guard",
	"Chain bolt",
	"Fireball",
	"Meteor",
	"Flamethrower",
	"Iceball",
	"Slimeball",
	"Path of dark flame",
	"Summon missile",
	"??? (Bullet)",
	"Summon rock spirit",
	"Dynamite",
	"Glitter bomb",
	"Triplicate bolt",
	"Freezing gaze",
	"Pinpoint of light",
	"Prickly spore pod",
	"Glue ball",
	"Holy bomb",
	"Giga holy bomb",
	"Propane tank",
	"Bomb cart",
	"Cursed sphere",
	"Expanding sphere",
	"Earthquake",
	"Rock",
	"Summon egg",
	"Summon hollow egg",
	"Summon explosive box",
	"Summon large explosive box",
	"Summon fly swarm",
	"Summon firebug swarm",
	"Summon wasp swarm",
	"Summon friendly fly",
	"Acid ball",
	"Thunder charge",
	"Firebomb",
	"Chunk of soil",
	"Death cross",
	"Giga death cross",
	"Infestation",
	"Horizontal barrier",
	"Vertical barrier",
	"Square barrier",
	"Summon wall",
	"Summon platform",
	"Glittering field",
	"Delayed spellcast",
	"Long-distance cast",
	"Teleporting cast",
	"Warp cast",
	"Inner spell",
	"Toxic mist",
	"Mist of spirits",
	"Slime mist",
	"Blood mist",
	"Circle of fire",
	"Circle of acid",
	"Circle of oil",
	"Circle of water",
	"Water",
	"Oil",
	"Blood",
	"Acid",
	"Cement",
	"Teleport bolt",
	"Small teleport bolt",
	"Return",
	"Swapper",
	"Homebringer teleport bolt",
	"Nuke",
	"Giga nuke",
	"Fireworks!",
	"Summon taikasauva",
	"Touch of gold",
	"Touch of water",
	"Touch of oil",
	"Touch of spirits",
	"Touch of blood",
	"Touch of smoke",
	"Destruction",
	"Double spell",
	"Triple spell",
	"Quadruple spell",
	"Octuple spell",
	"Myriad spell",
	"Double scatter spell",
	"Triple scatter spell",
	"Quadruple scatter spell",
	"Formation - behind your back",
	"Formation - bifurcated",
	"Formation - above and below",
	"Formation - trifurcated",
	"Formation - hexagon",
	"Formation - pentagon",
	"Iplicate spell",
	"Yplicate spell",
	"Tiplicate spell",
	"Wuplicate spell",
	"Quplicate spell",
	"Peplicate spell",
	"Heplicate spell",
	"Reduce spread",
	"Heavy spread",
	"Reduce recharge time",
	"Increase lifetime",
	"Reduce lifetime",
	"Nolla",
	"Slow but steady",
	"Remove explosion",
	"Concentrated explosion",
	"Plasma beam enhancer",
	"Add mana",
	"Blood magic",
	"Gold to power",
	"Blood to power",
	"Spell duplication",
	"Quantum split",
	"Gravity",
	"Anti-gravity",
	"Slithering path",
	"Chaotic path",
	"Ping-pong path",
	"Avoiding arc",
	"Floating arc",
	"Fly downwards",
	"Fly upwards",
	"Horizontal path",
	"Linear arc",
	"Orbiting arc",
	"Spiral arc",
	"Phasing arc",
	"True orbit",
	"Bounce",
	"Remove bounce",
	"Homing",
	"Anti homing",
	"Wand homing",
	"Short-range homing",
	"Rotate towards foes",
	"Boomerang",
	"Auto-aim",
	"Accelerative homing",
	"Aiming arc",
	"Projectile area teleport",
	"Piercing shot",
	"Drilling shot",
	"Damage plus",
	"Random damage",
	"Bloodlust",
	"Mana to damage",
	"Critical plus",
	"Damage field",
	"Spells to power",
	"Essence to power",
	"Null shot",
	"Heavy shot",
	"Light shot",
	"Knockback",
	"Recoil",
	"Recoil damper",
	"Speed up",
	"Accelerating shot",
	"Decelerating shot",
	"Explosive projectile",
	"Water to poison",
	"Blood to acid",
	"Lava to blood",
	"Liquid detonation",
	"Toxic sludge to acid",
	"Ground to sand",
	"Chaotic transmutation",
	"Chaos magic",
	"Necromancy",
	"Light",
	"Explosion",
	"Magical explosion",
	"Explosion of brimstone",
	"Explosion of poison",
	"Explosion of spirits",
	"Explosion of thunder",
	"Circle of fervour",
	"Circle of transmogrification",
	"Circle of unstable metamorphosis",
	"Circle of thunder",
	"Circle of stillness",
	"Circle of vigour",
	"Circle of displacement",
	"Circle of buoyancy",
	"Circle of shielding",
	"Projectile transmutation field",
	"Projectile thunder field",
	"Projectile gravity field",
	"Powder vacuum field",
	"Liquid vacuum field",
	"Vacuum field",
	"Sea of lava",
	"Sea of alcohol",
	"Sea of oil",
	"Sea of water",
	"Summon swamp",
	"Sea of acid",
	"Sea of flammable gas",
	"Rain cloud",
	"Oil cloud",
	"Blood cloud",
	"Acid cloud",
	"Thundercloud",
	"Electric charge",
	"Matter eater",
	"Freeze charge",
	"Critical on burning",
	"Critical on wet (water) enemies",
	"Critical on oiled enemies",
	"Critical on bloody enemies",
	"Charm on toxic sludge",
	"Explosion on slimy enemies",
	"Giant explosion on slimy enemies",
	"Explosion on drunk enemies",
	"Giant explosion on drunk enemies",
	"Petrify",
	"Downwards bolt bundle",
	"Octagonal bolt bundle",
	"Fizzle",
	"Explosive bounce",
	"Bubbly bounce",
	"Concentrated light bounce",
	"Plasma beam bounce",
	"Larpa bounce",
	"Sparkly bounce",
	"Lightning bounce",
	"Vacuum bounce",
	"Fireball thrower",
	"Lightning thrower",
	"Tentacler",
	"Plasma beam thrower",
	"Two-way fireball thrower",
	"Personal fireball thrower",
	"Personal lightning caster",
	"Personal tentacler",
	"Personal gravity field",
	"Venomous curse",
	"Weakening curse - projectiles",
	"Weakening curse - explosives",
	"Weakening curse - melee",
	"Weakening curse - electricity",
	"Sawblade orbit",
	"Fireball orbit",
	"Nuke orbit",
	"Plasma beam orbit",
	"Orbit larpa",
	"Chain spell",
	"Electric arc",
	"Fire arc",
	"Gunpowder arc",
	"Poison arc",
	"Earthquake shot",
	"All-seeing eye",
	"Firecrackers",
	"Acid trail",
	"Poison trail",
	"Oil trail",
	"Water trail",
	"Gunpowder trail",
	"Fire trail",
	"Burning trail",
	"Torch",
	"Electric torch",
	"Energy shield",
	"Energy shield sector",
	"Projectile energy shield",
	"Summon tiny ghost",
	"Ocarina - note a",
	"Ocarina - note b",
	"Ocarina - note c",
	"Ocarina - note d",
	"Ocarina - note e",
	"Ocarina - note f",
	"Ocarina - note g#",
	"Ocarina - note a2",
	"Kantele - note a",
	"Kantele - note d",
	"Kantele - note d#",
	"Kantele - note e",
	"Kantele - note g",
	"Random spell",
	"Random projectile spell",
	"Random modifier spell",
	"Random static projectile spell",
	"Copy random spell",
	"Copy random spell thrice",
	"Copy three random spells",
	"Spells to nukes",
	"Spells to giga sawblades",
	"Spells to magic missiles",
	"Spells to death crosses",
	"Spells to black holes",
	"Spells to acid",
	"The end of everything",
	"Summon portal",
	"Add trigger",
	"Add timer",
	"Add expiration trigger",
	"Chaos larpa",
	"Downwards larpa",
	"Upwards larpa",
	"Copy trail",
	"Larpa explosion",
	"Alpha",
	"Gamma",
	"Tau",
	"Omega",
	"Mu",
	"Phi",
	"Sigma",
	"Zeta",
	"Divide by 2",
	"Divide by 3",
	"Divide by 4",
	"Divide by 10",
	"Meteorisade",
	"Matosade",
	"Wand refresh",
	"Requirement - enemies",
	"Requirement - projectile spells",
	"Requirement - low health",
	"Requirement - every other",
	"Requirement - endpoint",
	"Requirement - otherwise",
	"Red glimmer",
	"Orange glimmer",
	"Green glimmer",
	"Yellow glimmer",
	"Purple glimmer",
	"Blue glimmer",
	"Rainbow glimmer",
	"Invisible spell",
	"Rainbow trail",
]

MaterialNames = [
	"material_none",
	"waterrock",
	"ice_glass",
	"ice_glass_b2",
	"glass_brittle",
	"wood_player_b2",
	"wood",
	"wax_b2",
	"fuse",
	"wood_loose",
	"rock_loose",
	"ice_ceiling",
	"brick",
	"concrete_collapsed",
	"tnt",
	"tnt_static",
	"meteorite",
	"sulphur_box2d",
	"meteorite_test",
	"meteorite_green",
	"steel",
	"steel_rust",
	"metal_rust_rust",
	"metal_rust_barrel_rust",
	"plastic",
	"aluminium",
	"rock_static_box2d",
	"rock_box2d",
	"crystal",
	"magic_crystal",
	"crystal_magic",
	"aluminium_oxide",
	"meat",
	"meat_slime",
	"physics_throw_material_part2",
	"ice_melting_perf_killer",
	"ice_b2",
	"glass_liquidcave",
	"glass",
	"neon_tube_purple",
	"snow_b2",
	"neon_tube_blood_red",
	"neon_tube_cyan",
	"meat_burned",
	"meat_done",
	"meat_hot",
	"meat_warm",
	"meat_fruit",
	"crystal_solid",
	"crystal_purple",
	"gold_b2",
	"magic_crystal_green",
	"bone_box2d",
	"metal_rust_barrel",
	"metal_rust",
	"metal_wire_nohit",
	"metal_chain_nohit",
	"metal_nohit",
	"glass_box2d",
	"potion_glass_box2d",
	"gem_box2d",
	"item_box2d_glass",
	"item_box2d",
	"rock_box2d_nohit_hard",
	"rock_box2d_nohit",
	"poop_box2d_hard",
	"rock_box2d_hard",
	"templebrick_box2d_edgetiles",
	"metal_hard",
	"metal",
	"metal_prop_loose",
	"metal_prop_low_restitution",
	"metal_prop",
	"aluminium_robot",
	"plastic_prop",
	"meteorite_crackable",
	"wood_prop_durable",
	"cloth_box2d",
	"wood_prop_noplayerhit",
	"wood_prop",
	"fungus_loose_trippy",
	"fungus_loose_green",
	"fungus_loose",
	"grass_loose",
	"cactus",
	"wood_wall",
	"wood_trailer",
	"templebrick_box2d",
	"fuse_holy",
	"fuse_tnt",
	"fuse_bright",
	"wood_player_b2_vertical",
	"meat_confusion",
	"meat_polymorph_protection",
	"meat_polymorph",
	"meat_fast",
	"meat_teleport",
	"meat_slime_cursed",
	"meat_cursed",
	"meat_trippy",
	"meat_helpless",
	"meat_worm",
	"meat_slime_orange",
	"meat_slime_green",
	"ice_slime_glass",
	"ice_blood_glass",
	"ice_poison_glass",
	"ice_radioactive_glass",
	"ice_cold_glass",
	"ice_acid_glass",
	"tube_physics",
	"rock_eroding",
	"meat_pumpkin",
	"meat_frog",
	"meat_cursed_dry",
	"nest_box2d",
	"nest_firebug_box2d",
	"cocoon_box2d",
	"item_box2d_meat",
	"gem_box2d_yellow_sun",
	"gem_box2d_red_float",
	"gem_box2d_yellow_sun_gravity",
	"gem_box2d_darksun",
	"gem_box2d_pink",
	"gem_box2d_red",
	"gem_box2d_turquoise",
	"gem_box2d_opal",
	"gem_box2d_white",
	"gem_box2d_green",
	"gem_box2d_orange",
	"gold_box2d",
	"bloodgold_box2d",
	"sand_static",
	"nest_static",
	"bluefungi_static",
	"rock_static",
	"lavarock_static",
	"static_magic_material",
	"meteorite_static",
	"templerock_static",
	"steel_static",
	"rock_static_glow",
	"snow_static",
	"ice_static",
	"ice_acid_static",
	"ice_cold_static",
	"ice_radioactive_static",
	"ice_poison_static",
	"ice_meteor_static",
	"tubematerial",
	"glass_static",
	"snowrock_static",
	"concrete_static",
	"wood_static",
	"cheese_static",
	"mud",
	"concrete_sand",
	"sand",
	"bone",
	"soil",
	"sandstone",
	"fungisoil",
	"honey",
	"glue",
	"explosion_dirt",
	"vine",
	"root",
	"snow",
	"snow_sticky",
	"rotten_meat",
	"meat_slime_sand",
	"rotten_meat_radioactive",
	"ice",
	"sand_herb",
	"wax",
	"gold",
	"silver",
	"copper",
	"brass",
	"diamond",
	"coal",
	"sulphur",
	"salt",
	"sodium_unstable",
	"gunpowder",
	"gunpowder_explosive",
	"gunpowder_tnt",
	"gunpowder_unstable",
	"gunpowder_unstable_big",
	"monster_powder_test",
	"rat_powder",
	"fungus_powder",
	"orb_powder",
	"gunpowder_unstable_boss_limbs",
	"plastic_red",
	"grass",
	"grass_ice",
	"grass_dry",
	"fungi",
	"spore",
	"moss",
	"plant_material",
	"plant_material_red",
	"ceiling_plant_material",
	"mushroom_seed",
	"plant_seed",
	"mushroom",
	"mushroom_giant_red",
	"mushroom_giant_blue",
	"glowshroom",
	"bush_seed",
	"wood_player",
	"trailer_text",
	"poo",
	"mammi",
	"glass_broken",
	"blood_thick",
	"sand_static_rainforest",
	"sand_static_rainforest_dark",
	"bone_static",
	"rust_static",
	"sand_static_bright",
	"meat_static",
	"moss_rust",
	"fungi_creeping_secret",
	"fungi_creeping",
	"grass_dark",
	"sand_static_red",
	"fungi_green",
	"shock_powder",
	"fungus_powder_bad",
	"burning_powder",
	"purifying_powder",
	"sodium",
	"metal_sand",
	"steel_sand",
	"gold_radioactive",
	"rock_static_intro",
	"rock_static_trip_secret",
	"endslime_blood",
	"endslime",
	"rock_static_trip_secret2",
	"sandstone_surface",
	"soil_dark",
	"soil_dead",
	"soil_lush_dark",
	"soil_lush",
	"sand_petrify",
	"lavasand",
	"sand_surface",
	"sand_blue",
	"plasma_fading_pink",
	"plasma_fading_green",
	"corruption_static",
	"wood_static_gas",
	"wood_static_vertical",
	"gold_static_dark",
	"gold_static_radioactive",
	"gold_static",
	"creepy_liquid_emitter",
	"wood_burns_forever",
	"root_growth",
	"wood_static_wet",
	"ice_slime_static",
	"ice_blood_static",
	"rock_static_intro_breakable",
	"steel_static_unmeltable",
	"steel_static_strong",
	"steelpipe_static",
	"steelsmoke_static",
	"steelmoss_slanted",
	"steelfrost_static",
	"rock_static_cursed",
	"rock_static_purple",
	"steelmoss_static",
	"rock_hard",
	"templebrick_moss_static",
	"templebrick_red",
	"glowstone_potion",
	"glowstone_altar_hdr",
	"glowstone_altar",
	"glowstone",
	"templebrick_static_ruined",
	"templebrick_diamond_static",
	"templebrick_golden_static",
	"wizardstone",
	"templebrickdark_static",
	"rock_static_fungal",
	"wood_tree",
	"rock_static_noedge",
	"rock_hard_border",
	"templerock_soft",
	"templebrick_noedge_static",
	"templebrick_static_soft",
	"templebrick_static_broken",
	"templebrick_static",
	"rock_static_wet",
	"rock_magic_gate",
	"rock_static_poison",
	"rock_static_cursed_green",
	"rock_static_radioactive",
	"rock_static_grey",
	"coal_static",
	"rock_vault",
	"rock_magic_bottom",
	"templebrick_thick_static",
	"templebrick_thick_static_noedge",
	"templeslab_static",
	"templeslab_crumbling_static",
	"the_end",
	"steel_rusted_no_holes",
	"steel_grey_static",
	"fungi_yellow",
	"skullrock",
	"water_static",
	"endslime_static",
	"slime_static",
	"spore_pod_stalk",
	"water",
	"water_temp",
	"water_ice",
	"water_swamp",
	"oil",
	"alcohol",
	"sima",
	"juhannussima",
	"magic_liquid",
	"material_confusion",
	"material_darkness",
	"material_rainbow",
	"magic_liquid_weakness",
	"magic_liquid_movement_faster",
	"magic_liquid_faster_levitation",
	"magic_liquid_faster_levitation_and_movement",
	"magic_liquid_worm_attractor",
	"magic_liquid_protection_all",
	"magic_liquid_mana_regeneration",
	"magic_liquid_unstable_teleportation",
	"magic_liquid_teleportation",
	"magic_liquid_hp_regeneration",
	"magic_liquid_hp_regeneration_unstable",
	"magic_liquid_polymorph",
	"magic_liquid_random_polymorph",
	"magic_liquid_unstable_polymorph",
	"magic_liquid_berserk",
	"magic_liquid_charm",
	"magic_liquid_invisibility",
	"cloud_radioactive",
	"cloud_blood",
	"cloud_slime",
	"swamp",
	"blood",
	"blood_fading",
	"blood_fungi",
	"blood_worm",
	"porridge",
	"blood_cold",
	"radioactive_liquid",
	"radioactive_liquid_fading",
	"plasma_fading",
	"gold_molten",
	"wax_molten",
	"silver_molten",
	"copper_molten",
	"brass_molten",
	"glass_molten",
	"glass_broken_molten",
	"steel_molten",
	"creepy_liquid",
	"cement",
	"slime",
	"slush",
	"vomit",
	"plastic_red_molten",
	"acid",
	"lava",
	"urine",
	"rocket_particles",
	"peat",
	"plastic_prop_molten",
	"plastic_molten",
	"slime_yellow",
	"slime_green",
	"aluminium_oxide_molten",
	"steel_rust_molten",
	"metal_prop_molten",
	"aluminium_robot_molten",
	"aluminium_molten",
	"metal_nohit_molten",
	"metal_rust_molten",
	"metal_molten",
	"metal_sand_molten",
	"steelsmoke_static_molten",
	"steelmoss_static_molten",
	"steelmoss_slanted_molten",
	"steel_static_molten",
	"plasma_fading_bright",
	"radioactive_liquid_yellow",
	"cursed_liquid",
	"poison",
	"blood_fading_slow",
	"pus",
	"midas",
	"midas_precursor",
	"liquid_fire_weak",
	"liquid_fire",
	"just_death",
	"void_liquid",
	"water_salt",
	"water_fading",
	"pea_soup",
	"smoke",
	"cloud",
	"cloud_lighter",
	"smoke_explosion",
	"steam",
	"acid_gas",
	"acid_gas_static",
	"smoke_static",
	"blood_cold_vapour",
	"sand_herb_vapour",
	"radioactive_gas",
	"radioactive_gas_static",
	"magic_gas_hp_regeneration",
	"magic_gas_midas",
	"magic_gas_worm_blood",
	"rainbow_gas",
	"magic_gas_polymorph",
	"magic_gas_weakness",
	"magic_gas_teleport",
	"magic_gas_fungus",
	"alcohol_gas",
	"poo_gas",
	"fungal_gas",
	"poison_gas",
	"steam_trailer",
	"smoke_magic",
	"fire",
	"spark",
	"spark_electric",
	"flame",
	"fire_blue",
	"spark_green",
	"spark_green_bright",
	"spark_blue",
	"spark_blue_dark",
	"spark_red",
	"spark_red_bright",
	"spark_white",
	"spark_white_bright",
	"spark_yellow",
	"spark_purple",
	"spark_purple_bright",
	"spark_player",
	"spark_teal"
]