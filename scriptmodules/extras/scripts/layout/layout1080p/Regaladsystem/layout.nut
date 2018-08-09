//
// Attract-Mode Front-End
// Régalad v1.0 (Game Station HD modifié et mixé avec d autre theme comme Cosmo) 
//
class UserConfig {
      </ label="Mode", help="", options="Expert", order=1 /> mode="Expert";
      </ label="Play Video Sound", help="Play Video Sound", options="Yes,No", order=2 /> sound="Yes";     
      </ label="Display Time", help="Display current time", options="Yes,No", order=3 /> enable_time="Yes";      
      </ label="Display Game List Option", help="How to display game list", options="Spin Only, Spin + ListBox, ListBox Only", order=4 /> listType="ListBox Only";
      </ label="CRT Effect", help="Enable CRT effect (requires shader support)", options="Yes,No", order=6 /> enable_crt="No";
      </ label="Flyer Aspect Ratio", help="Flyer preserve aspect ratio", options="Yes,No", order=7 /> ratio="No";
      </ label="Display Spin Option", help="The artwork to spin", options="snap,wheel", order=8 /> orbit_art="wheel";
      </ label="Transition Time", help="Time in milliseconds for spin.", order=9 /> transition_ms="40";
	  </ label="Enable system logos", help="Select system logos", options="Yes,No", order=12 /> enable_slogos="Yes";
	  </ label="Enable emulator bezel", help="Enable or disable game video preview bezel", options="Yes,No", order=13 /> enable_bezels="Yes";
	  </ label="Show character art", help="Show character at the left of the screen", options="Yes,No", order=14 /> enable_gfanart="Yes";
 }  

local my_config = fe.get_config();
local flx = fe.layout.width;
local fly = fe.layout.height;
local flw = fe.layout.width;
local flh = fe.layout.height;
fe.layout.font="roboto";

fe.load_module( "fade" );
fe.load_module("animate");

local TRIGGER = Transition.EndNavigation;

// No Available Image ///////////////////////////////////////////////////////////////////////////////
 local no_available = fe.add_artwork("no_available_image.png", flx*0.6, fly*0.35, flw*0.12, flh*0.21 );
 no_available.alpha = 230;

// Background Art ///////////////////////////////////////////////////////////////////////////////////

local b_art = fe.add_image("backgrounds/[DisplayName]", 0, 0, flw, flh );
b_art.alpha=255;

// Frame ////////////////////////////////////////////////////////////////////////////////////////////
local point = fe.add_image("bezel.png", flx*0.0429, fly*0.261, flw*0.552, flh*0.61 );


// Fill an entire surface with our snap at a resolution of 640x480///////////////////////////////////
 local surface = fe.add_surface( 640, 480 ); 
 local snap = surface.add_artwork("snap", 0, 0, 640, 480);
 snap.trigger = TRIGGER;
 snap.preserve_aspect_ratio = true;
 surface.set_pos( flx*0.05, fly*0.276, flw*0.538, flh*0.58 );
 if ( my_config["sound"] == "No" ){
     snap.video_flags = Vid.NoAudio;
 }

if ( my_config["enable_crt"] == "Yes" )
  {
    local sh = fe.add_shader( Shader.VertexAndFragment, "crt.vert", "crt.frag" );
	sh.set_param( "rubyInputSize", 640, 480 );
    	sh.set_param( "rubyOutputSize", ScreenWidth, ScreenHeight );
    	sh.set_param( "rubyTextureSize", 640, 480 );
	sh.set_texture_param("rubyTexture"); 
	surface.shader = sh;
  }

// Bezel ////////////////////////////////////////////////////////////////////////////////////////////
if ( my_config["enable_bezels"] == "Yes")
{
local point = fe.add_image("bezels/[DisplayName]", flx*0.05, fly*0.276, flw*0.539, flh*0.58 );
}
if ( my_config["enable_bezels"] == "No") 
{
 local point = fe.add_image( "", 0, 0, 0, 0 );
}

// Fanart //////////////////////////////////////////////////////////////////////////////////////////

if ( my_config["enable_gfanart"] == "Yes" )
{
	local fanart = fe.add_image("fanart/[DisplayName]", flx*0.0, fly*0.5, flw*0.5, flh*0.5 );
}

// Bottom Background ///////////////////////////////////////////////////////////////////////////////
 local bottom = fe.add_image ("bottom.png",flx*0.045, fly*0.876, flw*0.548, flh*0.11);

 
// Game name text /////////////////////////////////////////////////////////////////////////////////
 function gamename( index_offset ) {
  local s = split( fe.game_info( Info.Title, index_offset ), "(/[" );
 	if ( s.len() > 0 ) return s[0];
  return "";
}

 local gametitle = fe.add_text( gamename ( 0 ), flx*0.11, fly*0.88, flw*0.488, flh*0.05 );
       gametitle.align = Align.Left;
       gametitle.alpha = 235;
	   gametitle.set_rgb( 255, 255, 255 );

//Game Information Text /////////////////////////////////////////////////////////////////////////////
 local year = fe.add_text( "© [Year] [Manufacturer]", flx*0.113, fly*0.922, flw*0.48, flh*0.04  );
 year.alpha = 180;
 year.align = Align.Left;
 year.set_rgb( 255, 255, 255 );

// Genre_image //////////////////////////////////////////////////////////////////////////////////////
 local genre_image = fe.add_image("unknown.png", flx*0.049, fly* 0.88, flw*0.07, flh*0.1 );

 class GenreImage
   {
    mode = 1;       //0 = first match, 1 = last match, 2 = random
    supported = {
        //filename : [ match1, match2 ]
        "act": [ "action","platformer", "platform" ],
        "avg": [ "adventure" ],
        "ftg": [ "fighting", "fighter", "beat'em up" ],
        "pzg": [ "puzzle" ],
        "rcg": [ "racing", "driving" ],
        "rpg": [ "rpg", "role playing", "role-playing", "role playing game" ],
        "stg": [ "shooter", "shmup" ],
        "spt": [ "sports", "boxing", "golf", "baseball", "football", "soccer" ],
        "slg": [ "strategy"]
    }

    ref = null;
    constructor( image )
    {
        ref = image;
        fe.add_transition_callback( this, "transition" );
    }
    
    function transition( ttype, var, ttime )
    {
        if ( ttype == Transition.ToNewSelection || ttype == Transition.ToNewList )
        {
            local cat = " " + fe.game_info(Info.Category, var).tolower();
            local matches = [];
            foreach( key, val in supported )
            {
                foreach( nickname in val )
                {
                    if ( cat.find(nickname, 0) ) matches.push(key);
                }
            }
            if ( matches.len() > 0 )
            {
                switch( mode )
                {
                    case 0:
                        ref.file_name = "images/" + matches[0] + ".png";
                        break;
                    case 1:
                        ref.file_name = "images/" + matches[matches.len() - 1] + ".png";
                        break;
                    case 2:
                        local random_num = floor(((rand() % 1000 ) / 1000.0) * ((matches.len() - 1) - (0 - 1)) + 0);
                        ref.file_name = "images/" + matches[random_num] + ".png";
                        break;
                }
            } else
            {
                ref.file_name = "images/unknown.png";
            }
        }
    }
}

GenreImage(genre_image);

//System Logos //////////////////////////////////////////////////////////////////////////////////////
if ( my_config["enable_slogos"] == "Yes")  
{
local slogos = fe.add_image("slogos/[DisplayName]", flx*0.37, fly*0.13, flw*0.9, flh*0.9 );
slogos.trigger = Transition.EndNavigation;
}

//Display current time //////////////////////////////////////////////////////////////////////////////
if ( my_config["enable_time"] == "Yes" ){
  local dt = fe.add_text( "", flx*0.04, fly*0.009, flw*0.1, flh*0.040 );
  dt.align = Align.Left;
  dt.alpha = 230;

  local clock = fe.add_image ("clock.png",flx*0.02, fly*0.017, flw*0.024, flh*0.03);
  clock.alpha = 230;

function update_clock( ttime ){
  local now = date();
  dt.msg = format("%02d", now.hour) + ":" + format("%02d", now.min );
}
  fe.add_ticks_callback( this, "update_clock" );
}

// Medias listbox ///////////////////////////////////////////////////////////////////////////////////
 if ( my_config["listType"] == "ListBox Only" ) 
{
	local boxart = fe.add_artwork("boxart", flx*0.683, fly*0.2, flw*0.20, flh*0.40 );
	boxart.trigger = Transition.EndNavigation;
	local cartart = fe.add_artwork("cartart", flx*0.85, fly*0.48, flw*0.10, flh*0.15 );
	cartart.trigger = Transition.EndNavigation;
}

// Medias spin //////////////////////////////////////////////////////////////////////////////////////////
 if ( my_config["listType"] == "Spin Only" )
{
	local boxart = fe.add_artwork("boxart", flx*0.6, fly*0.845, flw*0.065, flh*0.145 );
	boxart.trigger = Transition.EndNavigation;
	local cartart = fe.add_artwork("cartart", flx*0.64, fly*0.915, flw*0.05, flh*0.07 );
	cartart.trigger = Transition.EndNavigation;
}

// Medias Spin + ListBox //////////////////////////////////////////////////////////////////////////////////////////
 if ( my_config["listType"] == "Spin + ListBox" )
{
	local boxart = fe.add_artwork("boxart", flx*0.6, fly*0.845, flw*0.065, flh*0.145 );
	boxart.trigger = Transition.EndNavigation;
	local cartart = fe.add_artwork("cartart", flx*0.64, fly*0.915, flw*0.05, flh*0.07 );
	cartart.trigger = Transition.EndNavigation;
}

// Wheel Settings Spin Only //////////////////////////////////////////////////////////////////////////////////
 if ( my_config["listType"] == "Spin Only" )
{
local bottom = fe.add_image ("bottom.png",flx*0.7, fly*0.0, flw*0.27, flh*1.3);
fe.load_module( "conveyor" );
 local wheel_x = [ flx*0.722, flx*0.722, flx*0.722, flx*0.722, flx*0.722, flx*0.722, flx*0.722, flx*0.722, flx*0.722, flx*0.722, flx*0.722, flx*0.722, ];  
 local wheel_y = [ -fly*0.22, -fly*0.105, fly*0.0, fly*0.105, fly*0.215, fly*0.325, fly*0.436, fly*0.61, fly*0.72 fly*0.83, fly*0.935, fly*0.99, ];
 local wheel_w = [ flw*0.18, flw*0.18, flw*0.18, flw*0.18, flw*0.18, flw*0.18, flw*0.24, flw*0.18, flw*0.18, flw*0.18, flw*0.18, flw*0.18, ];
 local wheel_a = [  80,  80,  80,  80,  80,  80, 255,  80,  80,  80,  80,  80, ];
 local wheel_h = [  flh*0.11,  flh*0.11,  flh*0.11,  flh*0.11,  flh*0.11,  flh*0.11, flh*0.17,  flh*0.11,  flh*0.11,  flh*0.11,  flh*0.11,  flh*0.11, ];
 local wheel_r = [  30,  25,  20,  15,  10,   5,   0, -10, -15, -20, -25, -30, ];
 local num_arts = 8;
 
 class WheelEntry extends ConveyorSlot
{
	constructor()
	{
		base.constructor( ::fe.add_artwork( my_config["orbit_art"] ) );
	}

	function on_progress( progress, var )
	{
		local p = progress / 0.1;
		local slot = p.tointeger();
		p -= slot;
		slot++;

		if ( slot < 0 ) slot=0;
		if ( slot >= 10 ) slot=10;

		m_obj.x = wheel_x[slot] + p * ( wheel_x[slot+1] - wheel_x[slot] );
		m_obj.y = wheel_y[slot] + p * ( wheel_y[slot+1] - wheel_y[slot] );
		m_obj.width = wheel_w[slot] + p * ( wheel_w[slot+1] - wheel_w[slot] );
		m_obj.height = wheel_h[slot] + p * ( wheel_h[slot+1] - wheel_h[slot] );
		m_obj.rotation = wheel_r[slot] + p * ( wheel_r[slot+1] - wheel_r[slot] );
		m_obj.alpha = wheel_a[slot] + p * ( wheel_a[slot+1] - wheel_a[slot] );
		m_obj.video_flags = Vid.NoAudio;
	}
};

 local wheel_entries = [];
 for ( local i=0; i<num_arts/2; i++ )
	wheel_entries.push( WheelEntry() );

 local remaining = num_arts - wheel_entries.len();

// we do it this way so that the last wheelentry created is the middle one showing the current
// selection (putting it at the top of the draw order)
 for ( local i=0; i<remaining; i++ )
	wheel_entries.insert( num_arts/2, WheelEntry() );

 local conveyor = Conveyor();
 conveyor.set_slots( wheel_entries );
 conveyor.transition_ms = 50;
 try { conveyor.transition_ms = my_config["transition_ms"].tointeger(); } catch ( e ) { }
}

// Wheel Settings Spin + ListBox//////////////////////////////////////////////////////////////////////////////////
 if ( my_config["listType"] == "Spin + ListBox" )
{
local bottom = fe.add_image ("bottom.png",flx*0.7, fly*0.0, flw*0.27, flh*1.3);
fe.load_module( "conveyor" );
 local wheel_x = [ flx*0.722, flx*0.722, flx*0.722, flx*0.722, flx*0.722, flx*0.722, flx*0.722, flx*0.722, flx*0.722, flx*0.722, flx*0.722, flx*0.722, ];  
 local wheel_y = [ -fly*0.22, -fly*0.105, fly*0.0, fly*0.105, fly*0.215, fly*0.325, fly*0.436, fly*0.61, fly*0.72 fly*0.83, fly*0.935, fly*0.99, ];
 local wheel_w = [ flw*0.18, flw*0.18, flw*0.18, flw*0.18, flw*0.18, flw*0.18, flw*0.24, flw*0.18, flw*0.18, flw*0.18, flw*0.18, flw*0.18, ];
 local wheel_a = [  80,  80,  80,  80,  80,  80, 255,  80,  80,  80,  80,  80, ];
 local wheel_h = [  flh*0.11,  flh*0.11,  flh*0.11,  flh*0.11,  flh*0.11,  flh*0.11, flh*0.17,  flh*0.11,  flh*0.11,  flh*0.11,  flh*0.11,  flh*0.11, ];
 local wheel_r = [  30,  25,  20,  15,  10,   5,   0, -10, -15, -20, -25, -30, ];
 local num_arts = 8;
 
 class WheelEntry extends ConveyorSlot
{
	constructor()
	{
		base.constructor( ::fe.add_artwork( my_config["orbit_art"] ) );
	}

	function on_progress( progress, var )
	{
		local p = progress / 0.1;
		local slot = p.tointeger();
		p -= slot;
		slot++;

		if ( slot < 0 ) slot=0;
		if ( slot >= 10 ) slot=10;

		m_obj.x = wheel_x[slot] + p * ( wheel_x[slot+1] - wheel_x[slot] );
		m_obj.y = wheel_y[slot] + p * ( wheel_y[slot+1] - wheel_y[slot] );
		m_obj.width = wheel_w[slot] + p * ( wheel_w[slot+1] - wheel_w[slot] );
		m_obj.height = wheel_h[slot] + p * ( wheel_h[slot+1] - wheel_h[slot] );
		m_obj.rotation = wheel_r[slot] + p * ( wheel_r[slot+1] - wheel_r[slot] );
		m_obj.alpha = wheel_a[slot] + p * ( wheel_a[slot+1] - wheel_a[slot] );
		m_obj.video_flags = Vid.NoAudio;
	}
};

 local wheel_entries = [];
 for ( local i=0; i<num_arts/2; i++ )
	wheel_entries.push( WheelEntry() );

 local remaining = num_arts - wheel_entries.len();

// we do it this way so that the last wheelentry created is the middle one showing the current
// selection (putting it at the top of the draw order)
 for ( local i=0; i<remaining; i++ )
	wheel_entries.insert( num_arts/2, WheelEntry() );

 local conveyor = Conveyor();
 conveyor.set_slots( wheel_entries );
 conveyor.transition_ms = 50;
 try { conveyor.transition_ms = my_config["transition_ms"].tointeger(); } catch ( e ) { }
}

//Game List Animation //////////////////////////////////////////////////////////////////////////////
 ::OBJECTS <- {
 tick = fe.add_image ("tick.png",flx*0.95, fly*0.398, flw*0.028, flh*0.047),
 logo = fe.add_image("logos/[DisplayName]", flx*0.722, fly*0.03, flw*0.23, flh*0.13 ),
 wheelLogo = fe.add_artwork("wheel", flx*0.67, fly*0.037, flw*0.23, flh*0.13),
 gameListBG = fe.add_image ("default.png",flx, 0, flw*0.47, flh*1.01),
 gameListTitle = fe.add_text("[Title]", flx, fly*0.055, flw*0.05, flh*0.1),
 gameListBox = fe.add_listbox( flx, fly*0.171, flw*0.4, flh*0.65 ),
 gameListList1 = fe.add_text("[ListSize]",flx, fly*0.88, flw*0.3, flh*0.1),
 gameListList2 = fe.add_text("[ListEntry]",flx, fly*0.83, flw*0.3, flh*0.1),
 gameListList3 = fe.add_text("[ListEntry]/[ListSize]",flx*0.75, fly*0.93, flw*0.3, flh*0.06), 
 }

//Animation for Global & Expert Mode ///////////////////////////////////////////////////////////////

 local move_shrink1 = {
    when = Transition.ToNewList ,property = "scale", start = 1.8, end = 1.0, time = 1500, tween = Tween.Bounce
 }
 local move_shrink2 = {
    when = Transition.ToNewSelection ,property = "scale", start = 1.8, end = 1.0, time = 1500, tween = Tween.Bounce
 }
 local move_shrink3 = {
    when = Transition.ToNewList ,property = "scale", start = 1.25, end = 1.0, time = 1200, tween = Tween.Bounce, loop=true
 } 
 local move_gameListBG1 = {
    when = Transition.ToNewSelection ,property = "x", start = flw, end = flx*0.6, time = 1
 }
 local move_gameListBG2 = {
    when = When.ToNewSelection ,property = "x", start = flx*0.6, end = flw, time = 1, delay= 2000
 } 
 local move_gameListTitle1 = {
    when = Transition.ToNewSelection ,property = "x", start = flw, end = flx*0.72, time = 1
 }
 local move_gameListTitle2 = {
    when = When.ToNewSelection ,property = "x", start = flx*0.72, end = flw, time = 1, delay= 2000
 }
 local move_gameListBox1 = {
    when = Transition.ToNewSelection ,property = "x", start = flw, end = flx*0.6, time = 1
 }
 local move_gameListBox2 = {
    when = When.ToNewSelection ,property = "x", start = flx*0.6, end = flw, time = 1, delay= 2000
 }
 local move_gameListList1 = {
    when = Transition.ToNewSelection ,property = "x", start = flw, end = flx*0.719, time = 1
 }
 local move_gameListList2 = {
    when = When.ToNewSelection ,property = "x", start = flx*0.719, end = flw, time = 1, delay= 2000
 }
 local move_gameListList3 = {
    when = Transition.ToNewSelection ,property = "x", start = flw, end = flx*0.689, time = 1
 }
 local move_gameListList4 = {
    when = When.ToNewSelection ,property = "x", start = flx*0.689, end = flw, time = 1, delay= 2000
 }
 local move_gameListList9 = {
    when = Transition.ToNewSelection ,property = "alpha", start = 200, end = 0, time = 2000
 }
 local move_gameListList10 = {
    when = Transition.ToNewList ,property = "alpha", start = 200, end = 0, time = 1
 }

//Animation for Simple Mode /////////////////////////////////////////////////////////////////////////

 local move_gameListBG3 = {
    when = Transition.StartLayout ,property = "x", start = flw*0.605, end = flx*0.6, time = 800, tween = Tween.Bounce
 }
 local move_gameListBG4 = {
    when = Transition.ToNewList ,property = "x", start = flw*0.605, end = flx*0.6, time = 800, tween = Tween.Bounce
 }
 local move_gameListTitle3 = {
    when = Transition.StartLayout ,property = "x", start = flw*0.7, end = flx*0.83, time = 800, tween = Tween.Bounce
 }
 local move_gameListTitle4 = {
    when = Transition.ToNewList ,property = "x", start = flw*0.7, end = flx*0.83, time = 800, tween = Tween.Bounce
 }
 local move_gameListBox3 = {
    when = Transition.StartLayout ,property = "x", start = flw*0.6, end = flx*0.65, time = 800, tween = Tween.Bounce
 }
 local move_gameListBox4 = {
    when = Transition.ToNewList ,property = "x", start = flw*0.6, end = flx*0.65, time = 800, tween = Tween.Bounce
 }
 local move_gameListList5 = {
    when = Transition.StartLayout ,property = "x", start = flw*0.7, end = flx*0.719, time = 800, tween = Tween.Bounce 
 }
 local move_gameListList6 = {
    when = Transition.StartLayout ,property = "x", start = flw*0.7, end = flx*0.689, time = 800, tween = Tween.Bounce
 }
 local move_gameListList7 = {
    when = Transition.ToNewList ,property = "x", start = flw*0.7, end = flx*0.719, time = 800, tween = Tween.Bounce 
 }
 local move_gameListList8 = {
    when = Transition.ToNewList ,property = "x", start = flw*0.7, end = flx*0.689, time = 800, tween = Tween.Bounce
 }

//Animation ///////////////////////////////////////////////////////////////////////////////////////////

if ( my_config["listType"] == "Spin + ListBox" ){
  animation.add( PropertyAnimation( OBJECTS.gameListBG, move_gameListBG1 ) );
  animation.add( PropertyAnimation( OBJECTS.gameListBG, move_gameListBG2 ) );
  animation.add( PropertyAnimation( OBJECTS.gameListTitle, move_gameListTitle1 ) );
  animation.add( PropertyAnimation( OBJECTS.gameListTitle, move_gameListTitle2 ) );
  animation.add( PropertyAnimation( OBJECTS.gameListBox, move_gameListBox1 ) );
  animation.add( PropertyAnimation( OBJECTS.gameListBox, move_gameListBox2 ) );
  animation.add( PropertyAnimation( OBJECTS.gameListList1, move_gameListList1 ) );
  animation.add( PropertyAnimation( OBJECTS.gameListList1, move_gameListList2 ) );
  animation.add( PropertyAnimation( OBJECTS.gameListList2, move_gameListList3 ) );
  animation.add( PropertyAnimation( OBJECTS.gameListList2, move_gameListList4 ) );
  OBJECTS.gameListList3.visible = false;
  OBJECTS.logo.visible = false;
  OBJECTS.wheelLogo.visible = false;
  }

else if ( my_config["listType"] == "Spin Only" ){
  animation.add( PropertyAnimation( OBJECTS.gameListList3, move_gameListList9 ) );
  animation.add( PropertyAnimation( OBJECTS.gameListList3, move_gameListList10 ) );
  OBJECTS.gameListList3.visible = true;
  OBJECTS.tick.visible = false; 
  OBJECTS.logo.visible = false;
  OBJECTS.wheelLogo.visible = false;
  }

else if ( my_config["listType"] == "ListBox Only" ){
  animation.add( PropertyAnimation( OBJECTS.gameListBG, move_gameListBG1 ) );
  animation.add( PropertyAnimation( OBJECTS.gameListBG, move_gameListBG2 ) );
  animation.add( PropertyAnimation( OBJECTS.gameListTitle, move_gameListTitle1 ) );
  animation.add( PropertyAnimation( OBJECTS.gameListTitle, move_gameListTitle2 ) );
  animation.add( PropertyAnimation( OBJECTS.gameListBox, move_gameListBox1 ) );
  animation.add( PropertyAnimation( OBJECTS.gameListBox, move_gameListBox2 ) );
  animation.add( PropertyAnimation( OBJECTS.gameListList1, move_gameListList1 ) );
  animation.add( PropertyAnimation( OBJECTS.gameListList1, move_gameListList2 ) );
  animation.add( PropertyAnimation( OBJECTS.gameListList2, move_gameListList3 ) );
  animation.add( PropertyAnimation( OBJECTS.gameListList2, move_gameListList4 ) );
  OBJECTS.gameListList3.visible = false; 
  OBJECTS.tick.visible = false; 
  OBJECTS.logo.visible = false;
  OBJECTS.wheelLogo.visible = true;
  OBJECTS.wheelLogo.trigger = Transition.EndNavigation;
  }

 animation.add( PropertyAnimation( OBJECTS.tick, move_shrink3 ) );

 OBJECTS.tick.alpha = 230;
 OBJECTS.gameListTitle.alpha = 230;
 OBJECTS.gameListBox.charsize = 35;
 OBJECTS.gameListBox.align = Align.Left;
 OBJECTS.gameListBox.rows=9;
 OBJECTS.gameListBox.set_sel_rgb( 240, 240, 240 );
 OBJECTS.gameListBox.set_selbg_rgb( 0, 32, 255 );
 OBJECTS.gameListBox.set_rgb( 255, 255, 255 );
 OBJECTS.gameListList1.align = Align.Right;
 OBJECTS.gameListList1.alpha = 180;
 OBJECTS.gameListList2.set_rgb( 255, 255, 255 );
 OBJECTS.gameListList2.align = Align.Right;
 OBJECTS.gameListList2.alpha = 240;
 OBJECTS.gameListList3.alpha = 180;

//Expert Mode to Setup Logo, Wheel Logo & Background Color
//Please refer as below sample to be setup and remember put system image file in correct path

//case "MAME":						System name, Input system name. eg. mame, snes, nes, md .........    
//OBJECTS.logo.file_name = "";				System logo file names, if you want to show system logo, please type system logo file name. Left it empty if want to show game wheel logo      
//lt.set_bg_rgb( 155, 0, 40 );                          Color of top background  
//lb.set_bg_rgb( 155, 0, 40 );				Color of bottom background
//OBJECTS.gameListBox.set_selbg_rgb( 155, 0, 40 );	Color of list box selection
//OBJECTS.gameListList2.set_rgb( 155, 0, 40 );		Color of game list number 
//break;

if ( my_config["mode"] == "Expert" ){
 function transition_callback(ttype, var, ttime)
  {
    switch ( ttype )
    {
        case Transition.ToNewList:
            switch ( fe.list.name )
            {              
		case "MAME":
                OBJECTS.logo.file_name = "";
		lt.set_bg_rgb( 155, 0, 40 );
		lb.set_bg_rgb( 155, 0, 40 );
		OBJECTS.gameListBox.set_selbg_rgb( 155, 0, 40 );
		OBJECTS.gameListList2.set_rgb( 155, 0, 40 );
                break;
		case "NES":
                OBJECTS.logo.file_name = "nes.png";
		lt.set_bg_rgb( 0, 150, 136 );
		lb.set_bg_rgb( 0, 150, 136 );
		OBJECTS.gameListBox.set_selbg_rgb( 0, 150, 136 );
		OBJECTS.gameListList2.set_rgb( 0, 150, 136 );
                break;		
			}
			break;
    }
  }
}

function fade_transitions( ttype, var, ttime ) {
 switch ( ttype ) {
  case Transition.ToNewList:
  case Transition.ToNewSelection:
      gametitle.msg = gamename ( var );  
  break;
  }
 return false;
}

fe.add_transition_callback("transition_callback" );
fe.add_transition_callback( "fade_transitions" );